#!/usr/bin/env python3
"""Build, validate, and render the book's standalone Typst figures.

This script deliberately orchestrates command-line tools only. All drawing and
plotting remains in Typst, CeTZ, and Lilaq sources.
"""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import tempfile
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Iterable, Sequence
from urllib.parse import quote


REPO_ROOT = Path(__file__).resolve().parents[1]
FIGURE_ROOT = REPO_ROOT / "source_material" / "figures"
STYLE_ROOT = FIGURE_ROOT / "styles"
SPECIMEN_ROOT = FIGURE_ROOT / "tests" / "specimens"
PRODUCTION_ROOT = FIGURE_ROOT / "src"
GENERATED_ROOT = FIGURE_ROOT / "generated"
GENERATED_SPECIMEN_ROOT = GENERATED_ROOT / "specimens"
LATEX_FIXTURE = FIGURE_ROOT / "tests" / "latex" / "figure-inclusion.tex"
BUILD_ROOT = REPO_ROOT / "build"
REVIEW_ROOT = BUILD_ROOT / "figure-review"
PREVIEW_ROOT = REVIEW_ROOT / "previews"
REPORT_ROOT = REVIEW_ROOT / "reports"
REVIEW_SOURCE_ROOT = REVIEW_ROOT / "sources"
REVIEW_PDF_ROOT = REVIEW_ROOT / "pdfs"

TYPST_VERSION = "0.15.0"
CETZ_VERSION = "0.5.2"
LILAQ_VERSION = "0.6.0"
SIZE_TOLERANCE_PT = 0.25
REVIEW_PPI = 144

PACKAGE_RE = re.compile(
    r"@([A-Za-z0-9_-]+)/([A-Za-z0-9_-]+)"
    r"(?::([^\"'\s/]+))?"
)
EXPECTED_SIZE_RE = re.compile(
    r"figure-pipeline:\s*expected-size-pt\s*=\s*"
    r"([0-9]+(?:\.[0-9]+)?)\s*,\s*([0-9]+(?:\.[0-9]+)?)",
    re.IGNORECASE,
)
FIGURE_KIND_RE = re.compile(
    r"figure-pipeline:\s*kind\s*=\s*([a-z-]+)",
    re.IGNORECASE,
)
WIDTH_PROFILE_RE = re.compile(
    r"figure-pipeline:\s*width-profile\s*=\s*([a-z-]+)",
    re.IGNORECASE,
)
FIGURE_KINDS = {"diagram", "mechanics", "plot", "surface", "style", "test"}
WIDTH_PROFILES_MM = {"full": 160.0, "half": 80.0, "page": 163.9}
WARNING_RE = re.compile(
    r"(missing\s+glyph|glyph\b.*\bnot\s+found|font\b.*\bnot\s+found|"
    r"substitut(?:e|ed|ing)\b.*\bfont|\berror\b)",
    re.IGNORECASE,
)


class PipelineError(RuntimeError):
    """An expected, user-facing pipeline failure."""


@dataclass(frozen=True)
class Figure:
    source: Path
    output: Path
    kind: str

    @property
    def key(self) -> str:
        if self.kind == "specimen":
            return self.source.relative_to(SPECIMEN_ROOT).with_suffix("").as_posix()
        return self.source.relative_to(PRODUCTION_ROOT).with_suffix("").as_posix()

    @property
    def review_name(self) -> str:
        prefix = "specimen" if self.kind == "specimen" else "figure"
        return prefix + "--" + self.key.replace("/", "--")


@dataclass
class PdfReport:
    name: str
    kind: str
    source: str
    pdf: str
    pages: int | None = None
    width_pt: float | None = None
    height_pt: float | None = None
    width_in: float | None = None
    height_in: float | None = None
    width_profile: str | None = None
    font_count: int = 0
    fonts_embedded: bool = False
    no_type3_fonts: bool = False
    ghostscript_valid: bool = False
    vector_only: bool = False
    deterministic: bool = False
    committed_sha256: str | None = None
    rebuilt_sha256: str | None = None
    preview: str | None = None
    preview_width_px: int | None = None
    preview_height_px: int | None = None
    errors: list[str] = field(default_factory=list)

    @property
    def valid(self) -> bool:
        return not self.errors


def run(
    command: Sequence[str | os.PathLike[str]],
    *,
    cwd: Path = REPO_ROOT,
    env: dict[str, str] | None = None,
) -> subprocess.CompletedProcess[str]:
    command_strings = [os.fspath(item) for item in command]
    process_env = os.environ.copy()
    if env:
        process_env.update(env)
    return subprocess.run(
        command_strings,
        cwd=cwd,
        env=process_env,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )


def require_tool(name: str, install_hint: str = "") -> str:
    executable = shutil.which(name)
    if executable:
        return executable
    detail = f" {install_hint}" if install_hint else ""
    raise PipelineError(f"required tool '{name}' was not found.{detail}".rstrip())


def check_typst_version() -> str:
    typst = require_tool(
        "typst",
        f"Install Typst {TYPST_VERSION}; this project pins that exact version.",
    )
    result = run([typst, "--version"])
    if result.returncode != 0:
        raise PipelineError(f"could not query Typst: {result.stderr.strip()}")
    match = re.search(r"\btypst\s+([0-9]+\.[0-9]+\.[0-9]+)\b", result.stdout)
    actual = match.group(1) if match else "unknown"
    if actual != TYPST_VERSION:
        raise PipelineError(
            f"Typst {TYPST_VERSION} is required, but {actual} is installed."
        )
    return typst


def discover_specimens() -> list[Figure]:
    if not SPECIMEN_ROOT.exists():
        return []
    return [
        Figure(
            source=source,
            output=GENERATED_SPECIMEN_ROOT
            / source.relative_to(SPECIMEN_ROOT).with_suffix(".pdf"),
            kind="specimen",
        )
        for source in sorted(SPECIMEN_ROOT.rglob("*.typ"))
    ]


def discover_production() -> list[Figure]:
    if not PRODUCTION_ROOT.exists():
        return []
    return [
        Figure(
            source=source,
            output=GENERATED_ROOT
            / source.relative_to(PRODUCTION_ROOT).with_suffix(".pdf"),
            kind="production",
        )
        for source in sorted(PRODUCTION_ROOT.rglob("*.typ"))
    ]


def discover_all() -> list[Figure]:
    return discover_specimens() + discover_production()


def resolve_figure(value: str) -> Figure:
    raw = Path(value)
    if raw.suffix and raw.suffix != ".typ":
        raise PipelineError("FIGURE must omit its extension or end in '.typ'.")
    if not raw.suffix:
        raw = raw.with_suffix(".typ")
    if raw.is_absolute():
        try:
            source = raw.resolve().relative_to(FIGURE_ROOT.resolve())
        except ValueError as exc:
            raise PipelineError("FIGURE must be inside source_material/figures.") from exc
    else:
        source = raw
    if ".." in source.parts:
        raise PipelineError("FIGURE cannot escape source_material/figures.")
    full_source = (FIGURE_ROOT / source).resolve()
    try:
        specimen_relative = full_source.relative_to(SPECIMEN_ROOT.resolve())
    except ValueError:
        specimen_relative = None
    try:
        production_relative = full_source.relative_to(PRODUCTION_ROOT.resolve())
    except ValueError:
        production_relative = None
    if specimen_relative is not None:
        figure = Figure(
            full_source,
            GENERATED_SPECIMEN_ROOT / specimen_relative.with_suffix(".pdf"),
            "specimen",
        )
    elif production_relative is not None:
        figure = Figure(
            full_source,
            GENERATED_ROOT / production_relative.with_suffix(".pdf"),
            "production",
        )
    else:
        raise PipelineError(
            "FIGURE must begin with 'tests/specimens/' or 'src/' "
            "relative to source_material/figures."
        )
    if not figure.source.is_file():
        raise PipelineError(f"figure source does not exist: {figure.source}")
    return figure


def typst_environment(package_cache: Path | None = None) -> dict[str, str]:
    environment = {"SOURCE_DATE_EPOCH": "0"}
    if package_cache is not None:
        package_cache.mkdir(parents=True, exist_ok=True)
        environment["TYPST_PACKAGE_CACHE_PATH"] = os.fspath(package_cache)
    return environment


def compile_figure(
    figure: Figure,
    destination: Path | None = None,
    *,
    package_cache: Path | None = None,
) -> None:
    typst = check_typst_version()
    output = destination or figure.output
    output.parent.mkdir(parents=True, exist_ok=True)
    command = [
        typst,
        "compile",
        "--root",
        FIGURE_ROOT,
        "--ignore-system-fonts",
        figure.source,
        output,
    ]
    result = run(command, env=typst_environment(package_cache))
    if result.returncode != 0:
        diagnostics = (result.stdout + "\n" + result.stderr).strip()
        raise PipelineError(f"Typst compilation failed for {figure.source}:\n{diagnostics}")
    print(f"built {figure.source.relative_to(REPO_ROOT)} -> {output.relative_to(REPO_ROOT) if output.is_relative_to(REPO_ROOT) else output}")


def compile_many(figures: Iterable[Figure]) -> None:
    selected = list(figures)
    if not selected:
        print("No matching Typst figure sources were found.")
        return
    for figure in selected:
        compile_figure(figure)
    print(f"Built {len(selected)} figure(s).")


def strip_typst_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)
    return re.sub(r"//.*?$", "", text, flags=re.MULTILINE)


def uses_book_diagram(source: Path, code: str, visited: set[Path] | None = None) -> bool:
    """Return whether a figure or one of its local imports uses book-diagram."""
    if re.search(r"(?<![A-Za-z0-9_.-])book-diagram\s*\(", code):
        return True

    visited = set() if visited is None else visited
    resolved_source = source.resolve()
    if resolved_source in visited:
        return False
    visited.add(resolved_source)

    for imported in re.findall(
        r"#\s*import\s+[\"'](/[^\"']+\.typ)[\"']",
        code,
    ):
        dependency = (FIGURE_ROOT / imported.lstrip("/")).resolve()
        if not dependency.is_relative_to(FIGURE_ROOT.resolve()):
            continue
        if not dependency.is_file():
            continue
        dependency_code = strip_typst_comments(
            dependency.read_text(encoding="utf-8")
        )
        if uses_book_diagram(dependency, dependency_code, visited):
            return True
    return False


def policy_errors() -> list[str]:
    errors: list[str] = []
    typst_sources = sorted(FIGURE_ROOT.rglob("*.typ")) if FIGURE_ROOT.exists() else []
    figure_sources = {
        figure.source.resolve(): figure
        for figure in discover_all()
    }
    allowed_lilaq = STYLE_ROOT / "plots.typ"
    allowed_cetz = {
        (STYLE_ROOT / "figure.typ").resolve(),
        (STYLE_ROOT / "mechanics-components.typ").resolve(),
    }
    allowed_colors = STYLE_ROOT / "colors.typ"
    allowed_page = STYLE_ROOT / "figure.typ"

    for source in typst_sources:
        relative = source.relative_to(FIGURE_ROOT).as_posix()
        content = source.read_text(encoding="utf-8")
        code = strip_typst_comments(content)
        figure = figure_sources.get(source.resolve())

        for namespace, package, version in PACKAGE_RE.findall(code):
            if not version:
                errors.append(
                    f"{relative}: package @{namespace}/{package} is not "
                    "version-pinned"
                )
            if package == "cetz" and version != CETZ_VERSION:
                errors.append(
                    f"{relative}: CeTZ must be pinned to {CETZ_VERSION}, found {version}"
                )
            if package == "lilaq" and version != LILAQ_VERSION:
                errors.append(
                    f"{relative}: Lilaq must be pinned to {LILAQ_VERSION}, found {version}"
                )
            if package == "lilaq" and source.resolve() != allowed_lilaq.resolve():
                errors.append(
                    f"{relative}: only styles/plots.typ may import Lilaq"
                )
            if package == "cetz" and source.resolve() not in allowed_cetz:
                errors.append(
                    f"{relative}: only styles/figure.typ and "
                    "styles/mechanics-components.typ may import CeTZ"
                )

        if source.resolve() != allowed_lilaq.resolve() and re.search(
            r"\blq\s*\.\s*diagram\s*\(", code
        ):
            errors.append(
                f"{relative}: direct lq.diagram calls are prohibited; use book-diagram"
            )

        if source.resolve() != allowed_colors.resolve():
            if re.search(r"\brgb\s*\(", code):
                errors.append(
                    f"{relative}: hard-coded rgb colors are prohibited outside styles/colors.typ"
                )
            if re.search(r"(?<![A-Za-z0-9_])#[0-9A-Fa-f]{3,8}\b", code):
                errors.append(
                    f"{relative}: hard-coded hex colors are prohibited outside styles/colors.typ"
                )

        if figure is not None:
            for match in re.finditer(
                r"(?:#?\s*set\s+text|(?<![A-Za-z0-9_.-])text)"
                r"\s*\([^)]*?\bsize\s*:\s*([0-9]+(?:\.[0-9]+)?)pt\b",
                code,
                flags=re.DOTALL,
            ):
                size_points = float(match.group(1))
                if size_points < 8.0:
                    errors.append(
                        f"{relative}: literal text size {size_points:g}pt is "
                        "below the 8pt production-figure minimum"
                    )

        if source.resolve() != allowed_page.resolve():
            if re.search(r"#?\s*set\s+page\s*\(", code):
                errors.append(
                    f"{relative}: page sizing is centralized in "
                    "styles/figure.typ"
                )
            elif re.search(r"(?<![A-Za-z0-9_.-])page\s*\(", code):
                errors.append(
                    f"{relative}: direct page construction is prohibited; "
                    "use the shared standalone wrapper"
                )

        if figure is not None:
            kind_matches = FIGURE_KIND_RE.findall(content)
            if not kind_matches:
                errors.append(
                    f"{relative}: declare a figure classification with "
                    "'figure-pipeline: "
                    "kind=plot|surface|diagram|mechanics|style|test'"
                )
                figure_kind = None
            elif len(kind_matches) > 1:
                errors.append(
                    f"{relative}: declare exactly one figure-pipeline kind"
                )
                figure_kind = None
            else:
                figure_kind = kind_matches[0].lower()
                if figure_kind not in FIGURE_KINDS:
                    errors.append(
                        f"{relative}: unknown figure-pipeline kind "
                        f"'{figure_kind}'"
                    )

            if not re.search(
                r"#\s*import\s+[\"']/styles/figure\.typ[\"']\s*:\s*\*",
                code,
            ):
                errors.append(
                    f"{relative}: figure sources must import "
                    "'/styles/figure.typ': *"
                )
            if not re.search(r"(?<![A-Za-z0-9_.-])standalone\s*[\[(]", code):
                errors.append(
                    f"{relative}: figure sources must use the shared "
                    "standalone wrapper"
                )
            if re.search(r"#\s*let\s+standalone\b", code):
                errors.append(
                    f"{relative}: figure sources may not redefine standalone"
                )
            if figure_kind == "plot" and not uses_book_diagram(source, code):
                errors.append(
                    f"{relative}: plot figures must use book-diagram so "
                    "the shared Lilaq theme is mandatory"
                )
            if figure_kind == "surface":
                if not re.search(
                    r"#\s*import\s+[\"']@preview/plotsy-3d:0\.2\.1[\"']",
                    code,
                ):
                    errors.append(
                        f"{relative}: surface figures must import the pinned "
                        "Plotsy 3D 0.2.1 package"
                    )
                if not re.search(
                    r"\bplot-3d-(?:surface|parametric-surface)\s*\(",
                    code,
                ):
                    errors.append(
                        f"{relative}: surface figures must use a Plotsy 3D "
                        "surface constructor"
                    )
            if figure_kind in {"plot", "surface"} and re.search(
                r"\btitle\s*:", code
            ):
                errors.append(
                    f"{relative}: plot titles belong in LaTeX captions"
                )
            if figure_kind in {"plot", "surface"}:
                width_profiles = WIDTH_PROFILE_RE.findall(content)
                if not width_profiles:
                    errors.append(
                        f"{relative}: quantitative figures must declare "
                        "'figure-pipeline: width-profile=full|half|page'"
                    )
                elif len(width_profiles) > 1:
                    errors.append(
                        f"{relative}: declare exactly one figure-pipeline "
                        "width profile"
                    )
                elif width_profiles[0].lower() not in WIDTH_PROFILES_MM:
                    errors.append(
                        f"{relative}: unknown figure-pipeline width profile "
                        f"'{width_profiles[0]}'"
                    )

    if allowed_page.exists():
        figure_style = strip_typst_comments(allowed_page.read_text(encoding="utf-8"))
        page_match = re.search(
            r"#?\s*set\s+page\s*\((.*?)\)",
            figure_style,
            re.DOTALL,
        )
        if not page_match:
            errors.append("styles/figure.typ: missing centralized #set page(...)")
        else:
            page_settings = page_match.group(1)
            required = {
                "width": r"\bwidth\s*:\s*auto\b",
                "height": r"\bheight\s*:\s*auto\b",
            }
            for name, pattern in required.items():
                if not re.search(pattern, page_settings):
                    errors.append(
                        f"styles/figure.typ: page {name} must be "
                        "auto"
                    )
            margin_match = re.search(
                r"\bmargin\s*:\s*(2pt|figure-page-margin)\b",
                page_settings,
            )
            if not margin_match:
                errors.append(
                    "styles/figure.typ: page margin must be 2pt or "
                    "the shared figure-page-margin constant"
                )
            elif margin_match.group(1) == "figure-page-margin":
                dimensions = STYLE_ROOT / "dimensions.typ"
                dimensions_code = (
                    strip_typst_comments(dimensions.read_text(encoding="utf-8"))
                    if dimensions.exists()
                    else ""
                )
                if not re.search(
                    r"\blet\s+figure-page-margin\s*=\s*2pt\b",
                    dimensions_code,
                ):
                    errors.append(
                        "styles/dimensions.typ: figure-page-margin must equal 2pt"
                    )

    return errors


def parse_pdfinfo(output: str) -> tuple[int, float, float]:
    pages_match = re.search(r"^Pages:\s+(\d+)\s*$", output, re.MULTILINE)
    media_match = re.search(
        r"^(?:Page\s+\d+\s+)?MediaBox:\s+"
        r"(-?[0-9.]+)\s+(-?[0-9.]+)\s+(-?[0-9.]+)\s+(-?[0-9.]+)\s*$",
        output,
        re.MULTILINE,
    )
    size_match = re.search(
        r"^Page size:\s+([0-9.]+)\s+x\s+([0-9.]+)\s+pts",
        output,
        re.MULTILINE,
    )
    if not pages_match:
        raise PipelineError("pdfinfo did not report a page count")
    if media_match:
        x1, y1, x2, y2 = map(float, media_match.groups())
        width, height = x2 - x1, y2 - y1
    elif size_match:
        width, height = map(float, size_match.groups())
    else:
        raise PipelineError("pdfinfo did not report a MediaBox or page size")
    return int(pages_match.group(1)), width, height


def parse_fonts(output: str) -> tuple[int, bool, bool]:
    lines = [
        line
        for line in output.splitlines()
        if line.strip()
        and not line.startswith("name ")
        and not set(line.strip()) <= {"-"}
    ]
    embedded = True
    no_type3 = True
    parsed = 0
    flags_re = re.compile(
        r"\s+(yes|no)\s+(yes|no)\s+(yes|no)\s+\d+\s+\d+\s*$",
        re.IGNORECASE,
    )
    for line in lines:
        match = flags_re.search(line)
        if not match:
            continue
        parsed += 1
        embedded = embedded and match.group(1).lower() == "yes"
        no_type3 = no_type3 and "type 3" not in line.lower()
    return parsed, embedded, no_type3


def has_raster_images(pdf: Path) -> bool:
    pdfimages = require_tool("pdfimages", "Install Poppler utilities.")
    result = run([pdfimages, "-list", pdf])
    if result.returncode != 0:
        raise PipelineError(f"pdfimages failed: {result.stderr.strip()}")
    rows = []
    for line in result.stdout.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("page") or set(stripped) <= {"-"}:
            continue
        if re.match(r"^\d+\s+\d+\s+", stripped):
            rows.append(stripped)
    return bool(rows)


def source_expected_size(source: Path) -> tuple[float, float] | None:
    match = EXPECTED_SIZE_RE.search(source.read_text(encoding="utf-8"))
    if not match:
        return None
    return float(match.group(1)), float(match.group(2))


def source_width_profile(source: Path) -> str | None:
    matches = WIDTH_PROFILE_RE.findall(source.read_text(encoding="utf-8"))
    if len(matches) != 1:
        return None
    profile = matches[0].lower()
    return profile if profile in WIDTH_PROFILES_MM else None


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def validate_pdf(figure: Figure) -> PdfReport:
    report = PdfReport(
        name=figure.key,
        kind=figure.kind,
        source=figure.source.relative_to(REPO_ROOT).as_posix(),
        pdf=figure.output.relative_to(REPO_ROOT).as_posix(),
    )
    report.width_profile = source_width_profile(figure.source)
    pdf = figure.output
    if not pdf.is_file():
        report.errors.append(f"missing generated PDF: {report.pdf}")
        return report

    try:
        pdfinfo = require_tool("pdfinfo", "Install Poppler utilities.")
        info = run([pdfinfo, "-box", pdf])
        if info.returncode != 0:
            raise PipelineError(info.stderr.strip() or "pdfinfo failed")
        pages, width, height = parse_pdfinfo(info.stdout)
        report.pages = pages
        report.width_pt = round(width, 4)
        report.height_pt = round(height, 4)
        report.width_in = round(width / 72.0, 4)
        report.height_in = round(height / 72.0, 4)
        if report.width_profile is not None:
            expected_width_mm = WIDTH_PROFILES_MM[report.width_profile]
            expected_width_pt = expected_width_mm * 72.0 / 25.4
            if abs(width - expected_width_pt) > SIZE_TOLERANCE_PT:
                actual_width_mm = width * 25.4 / 72.0
                report.errors.append(
                    f"{report.width_profile} width profile requires "
                    f"{expected_width_mm:.0f}mm, found {actual_width_mm:.3f}mm"
                )
        if pages != 1:
            report.errors.append(f"expected exactly one page, found {pages}")
        paper_sizes = {
            "Letter": (612.0, 792.0),
            "A4": (595.276, 841.89),
        }
        for label, (paper_width, paper_height) in paper_sizes.items():
            matches = (
                abs(width - paper_width) <= 2.0
                and abs(height - paper_height) <= 2.0
            ) or (
                abs(width - paper_height) <= 2.0
                and abs(height - paper_width) <= 2.0
            )
            if matches:
                report.errors.append(
                    f"MediaBox is {label}-sized instead of content-sized"
                )
        expected = source_expected_size(figure.source)
        if figure.source.name == "bounding-box.typ" and expected is None:
            report.errors.append(
                "bounding-box.typ must declare "
                "'figure-pipeline: expected-size-pt=W,H'"
            )
        if expected is not None:
            expected_width, expected_height = expected
            if abs(width - expected_width) > SIZE_TOLERANCE_PT:
                report.errors.append(
                    f"MediaBox width {width:.3f}pt differs from expected "
                    f"{expected_width:.3f}pt by more than {SIZE_TOLERANCE_PT}pt"
                )
            if abs(height - expected_height) > SIZE_TOLERANCE_PT:
                report.errors.append(
                    f"MediaBox height {height:.3f}pt differs from expected "
                    f"{expected_height:.3f}pt by more than {SIZE_TOLERANCE_PT}pt"
                )
    except PipelineError as exc:
        report.errors.append(f"PDF metadata check failed: {exc}")

    try:
        pdffonts = require_tool("pdffonts", "Install Poppler utilities.")
        fonts = run([pdffonts, pdf])
        if fonts.returncode != 0:
            raise PipelineError(fonts.stderr.strip() or "pdffonts failed")
        count, embedded, no_type3 = parse_fonts(fonts.stdout)
        report.font_count = count
        report.fonts_embedded = embedded
        report.no_type3_fonts = no_type3
        if count == 0:
            report.errors.append("no embedded text fonts were found")
        elif not embedded:
            report.errors.append("one or more PDF fonts are not embedded")
        if not no_type3:
            report.errors.append("Type 3 fonts are prohibited")
    except PipelineError as exc:
        report.errors.append(f"font check failed: {exc}")

    try:
        gs = require_tool("gs", "Install Ghostscript.")
        ghostscript = run(
            [gs, "-q", "-dNOPAUSE", "-dBATCH", "-sDEVICE=nullpage", pdf]
        )
        diagnostics = (ghostscript.stdout + "\n" + ghostscript.stderr).strip()
        report.ghostscript_valid = (
            ghostscript.returncode == 0 and not WARNING_RE.search(diagnostics)
        )
        if ghostscript.returncode != 0:
            report.errors.append(
                f"Ghostscript validation failed: {diagnostics or 'unknown error'}"
            )
        elif WARNING_RE.search(diagnostics):
            report.errors.append(
                f"Ghostscript reported a font/glyph error: {diagnostics}"
            )
    except PipelineError as exc:
        report.errors.append(f"Ghostscript check failed: {exc}")

    try:
        allow_raster = "figure-pipeline: allow-raster" in figure.source.read_text(
            encoding="utf-8"
        )
        raster = has_raster_images(pdf)
        report.vector_only = not raster
        if raster and not allow_raster:
            report.errors.append(
                "raster image objects found; add an explicit "
                "'figure-pipeline: allow-raster' source comment only when intentional"
            )
    except PipelineError as exc:
        report.errors.append(f"vector-content check failed: {exc}")

    report.committed_sha256 = sha256(pdf)
    return report


def expected_output_errors(figures: Sequence[Figure]) -> list[str]:
    errors: list[str] = []
    expected = {figure.output.resolve(): figure for figure in figures}
    for figure in figures:
        if not figure.output.is_file():
            errors.append(
                f"missing generated PDF for {figure.source.relative_to(REPO_ROOT)}: "
                f"{figure.output.relative_to(REPO_ROOT)}"
            )
    if GENERATED_ROOT.exists():
        for pdf in sorted(GENERATED_ROOT.rglob("*.pdf")):
            if pdf.resolve() not in expected:
                errors.append(
                    f"orphan generated PDF has no Typst source: "
                    f"{pdf.relative_to(REPO_ROOT)}"
                )
    return errors


def reproducibility_reports(
    figures: Sequence[Figure],
    reports: dict[Path, PdfReport],
) -> list[str]:
    errors: list[str] = []
    if not figures:
        return errors
    check_typst_version()
    with tempfile.TemporaryDirectory(prefix="figure-rebuild-", dir=BUILD_ROOT) as temp:
        temporary_root = Path(temp)
        package_cache = temporary_root / "typst-package-cache"
        for figure in figures:
            report = reports[figure.output.resolve()]
            rebuilt = temporary_root / "outputs" / figure.kind / f"{figure.key}.pdf"
            try:
                compile_figure(
                    figure,
                    rebuilt,
                    package_cache=package_cache,
                )
            except PipelineError as exc:
                message = f"{figure.key}: deterministic rebuild failed: {exc}"
                report.errors.append(message)
                errors.append(message)
                continue
            report.rebuilt_sha256 = sha256(rebuilt)
            if figure.output.is_file():
                report.committed_sha256 = sha256(figure.output)
                report.deterministic = (
                    report.rebuilt_sha256 == report.committed_sha256
                )
                if not report.deterministic:
                    message = (
                        f"{figure.key}: generated PDF is stale or nondeterministic "
                        f"({report.committed_sha256} != {report.rebuilt_sha256})"
                    )
                    report.errors.append(message)
                    errors.append(message)
            else:
                message = f"{figure.key}: generated PDF is missing"
                report.errors.append(message)
                errors.append(message)
    return errors


def png_dimensions(path: Path) -> tuple[int, int]:
    with path.open("rb") as stream:
        signature = stream.read(8)
        if signature != b"\x89PNG\r\n\x1a\n":
            raise PipelineError(f"not a PNG file: {path}")
        length = struct.unpack(">I", stream.read(4))[0]
        chunk_type = stream.read(4)
        if chunk_type != b"IHDR" or length < 8:
            raise PipelineError(f"PNG is missing an IHDR header: {path}")
        width, height = struct.unpack(">II", stream.read(8))
    return width, height


def render_preview(figure: Figure, report: PdfReport) -> None:
    if not figure.output.is_file():
        return
    pdftocairo = require_tool("pdftocairo", "Install Poppler utilities.")
    PREVIEW_ROOT.mkdir(parents=True, exist_ok=True)
    output_base = PREVIEW_ROOT / figure.review_name
    result = run(
        [
            pdftocairo,
            "-png",
            "-singlefile",
            "-r",
            str(REVIEW_PPI),
            figure.output,
            output_base,
        ]
    )
    diagnostics = (result.stdout + "\n" + result.stderr).strip()
    preview = output_base.with_suffix(".png")
    if result.returncode != 0 or not preview.is_file():
        report.errors.append(
            f"preview rendering failed: {diagnostics or 'pdftocairo produced no PNG'}"
        )
        return
    if WARNING_RE.search(diagnostics):
        report.errors.append(
            f"preview rendering reported a font/glyph error: {diagnostics}"
        )
    try:
        width_px, height_px = png_dimensions(preview)
        if width_px <= 0 or height_px <= 0:
            raise PipelineError("preview has zero width or height")
        report.preview = preview.relative_to(REVIEW_ROOT).as_posix()
        report.preview_width_px = width_px
        report.preview_height_px = height_px
        if report.width_pt and report.height_pt:
            pdf_ratio = report.width_pt / report.height_pt
            png_ratio = width_px / height_px
            pixel_tolerance = max(0.015, 2.0 / min(width_px, height_px))
            if abs(pdf_ratio - png_ratio) / pdf_ratio > pixel_tolerance:
                report.errors.append(
                    f"preview aspect ratio {png_ratio:.4f} does not match "
                    f"PDF aspect ratio {pdf_ratio:.4f}"
                )
    except PipelineError as exc:
        report.errors.append(f"preview validation failed: {exc}")


def relative_url(from_directory: Path, target: Path) -> str:
    relative = os.path.relpath(target, from_directory)
    return quote(Path(relative).as_posix(), safe="/")


def write_reports(
    reports: Sequence[PdfReport],
    validation_errors: Sequence[str] = (),
) -> None:
    REPORT_ROOT.mkdir(parents=True, exist_ok=True)
    for report in reports:
        report_path = REPORT_ROOT / (
            ("specimen--" if report.kind == "specimen" else "figure--")
            + report.name.replace("/", "--")
            + ".json"
        )
        report_path.write_text(
            json.dumps(asdict(report), indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )
    summary = {
        "valid": (
            all(report.valid for report in reports)
            and not validation_errors
        ),
        "count": len(reports),
        "passed": sum(report.valid for report in reports),
        "failed": sum(not report.valid for report in reports),
        "errors": list(validation_errors),
        "reports": [asdict(report) for report in reports],
    }
    (REPORT_ROOT / "summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def status_label(report: PdfReport) -> str:
    return "PASS" if report.valid else "FAIL"


def write_gallery(
    figures: Sequence[Figure],
    reports: Sequence[PdfReport],
    validation_errors: Sequence[str] = (),
) -> None:
    REVIEW_ROOT.mkdir(parents=True, exist_ok=True)
    report_map = {
        (report.kind, report.name): report
        for report in reports
    }
    cards: list[str] = []
    markdown: list[str] = [
        "# Figure review",
        "",
        (
            f"Overall validation: "
            f"{'FAIL' if validation_errors else 'PASS'}."
        ),
        "",
        f"Rendered at {REVIEW_PPI} PPI. Generated PDFs remain the authoritative output.",
        "",
    ]
    if validation_errors:
        markdown.extend(
            ["## Validation issues", ""]
            + [f"- {error}" for error in validation_errors]
            + [""]
        )
    for figure in figures:
        report = report_map[(figure.kind, figure.key)]
        review_subdirectory = (
            "specimens" if figure.kind == "specimen" else "figures"
        )
        source_copy = (
            REVIEW_SOURCE_ROOT
            / review_subdirectory
            / Path(figure.key).with_suffix(".typ")
        )
        pdf_copy = (
            REVIEW_PDF_ROOT
            / review_subdirectory
            / Path(figure.key).with_suffix(".pdf")
        )
        source_copy.parent.mkdir(parents=True, exist_ok=True)
        pdf_copy.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(figure.source, source_copy)
        if figure.output.is_file():
            shutil.copy2(figure.output, pdf_copy)
        source_url = relative_url(REVIEW_ROOT, source_copy)
        pdf_url = (
            relative_url(REVIEW_ROOT, pdf_copy)
            if pdf_copy.is_file()
            else "#"
        )
        dimensions = (
            f"{report.width_pt:.2f} × {report.height_pt:.2f} pt "
            f"({report.width_in:.3f} × {report.height_in:.3f} in)"
            if report.width_pt is not None
            and report.height_pt is not None
            and report.width_in is not None
            and report.height_in is not None
            else "unavailable"
        )
        width_profile = report.width_profile or "natural"
        errors_html = ""
        if report.errors:
            errors_html = "<ul class=\"errors\">" + "".join(
                f"<li>{html.escape(error)}</li>" for error in report.errors
            ) + "</ul>"
        image_html = (
            f'<a href="{html.escape(pdf_url)}">'
            f'<img src="{html.escape(report.preview)}" '
            f'alt="{html.escape(figure.key)} preview"></a>'
            if report.preview
            else '<div class="missing">Preview unavailable</div>'
        )
        cards.append(
            f"""
<article class="card {'pass' if report.valid else 'fail'}">
  <h2>{html.escape(figure.key)}</h2>
  {image_html}
  <dl>
    <dt>Status</dt><dd>{status_label(report)}</dd>
    <dt>Kind</dt><dd>{html.escape(report.kind)}</dd>
    <dt>Width profile</dt><dd>{html.escape(width_profile)}</dd>
    <dt>MediaBox</dt><dd>{html.escape(dimensions)}</dd>
    <dt>Pages</dt><dd>{report.pages if report.pages is not None else 'unknown'}</dd>
    <dt>Fonts</dt><dd>{report.font_count}; embedded: {report.fonts_embedded}; Type 3 free: {report.no_type3_fonts}</dd>
    <dt>Ghostscript</dt><dd>{report.ghostscript_valid}</dd>
    <dt>Vector only</dt><dd>{report.vector_only}</dd>
    <dt>Deterministic</dt><dd>{report.deterministic}</dd>
  </dl>
  <p><a href="{html.escape(source_url)}">Typst source</a> ·
     <a href="{html.escape(pdf_url)}">Generated PDF</a></p>
  {errors_html}
</article>"""
        )
        markdown.extend(
            [
                f"## {figure.key} — {status_label(report)}",
                "",
                (
                    f"![{figure.key} preview]({report.preview})"
                    if report.preview
                    else "_Preview unavailable._"
                ),
                "",
                f"- Source: [{report.source}]({source_url})",
                f"- PDF: [{report.pdf}]({pdf_url})",
                f"- Width profile: {width_profile}",
                f"- MediaBox: {dimensions}",
                f"- Pages: {report.pages if report.pages is not None else 'unknown'}",
                f"- Fonts embedded: {report.fonts_embedded}; Type 3 free: {report.no_type3_fonts}",
                f"- Ghostscript valid: {report.ghostscript_valid}",
                f"- Vector only: {report.vector_only}",
                f"- Deterministic rebuild: {report.deterministic}",
            ]
        )
        if report.errors:
            markdown.append("- Errors:")
            markdown.extend(f"  - {error}" for error in report.errors)
        markdown.append("")

    passed = sum(report.valid for report in reports)
    overall_status = "FAIL" if validation_errors else "PASS"
    validation_html = ""
    if validation_errors:
        validation_html = (
            '<section class="global-errors"><h2>Validation issues</h2><ul>'
            + "".join(
                f"<li>{html.escape(error)}</li>"
                for error in validation_errors
            )
            + "</ul></section>"
        )
    document = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Figure review</title>
  <style>
    :root {{ color-scheme: light dark; font-family: system-ui, sans-serif; }}
    body {{ margin: 0 auto; max-width: 1200px; padding: 2rem; }}
    header {{ margin-bottom: 2rem; }}
    .grid {{ display: grid; gap: 1.25rem; grid-template-columns: repeat(auto-fit, minmax(330px, 1fr)); }}
    .card {{ border: 3px solid #777; border-radius: .5rem; padding: 1rem; overflow: hidden; }}
    .card.pass {{ border-color: #238636; }}
    .card.fail {{ border-color: #cf222e; }}
    .card img {{ background: white; display: block; height: auto; margin: 1rem auto; max-height: 420px; max-width: 100%; }}
    .missing {{ background: #ddd; color: #222; padding: 4rem 1rem; text-align: center; }}
    dl {{ display: grid; grid-template-columns: max-content 1fr; gap: .25rem .75rem; }}
    dt {{ font-weight: 700; }}
    dd {{ margin: 0; overflow-wrap: anywhere; }}
    .errors {{ color: #cf222e; overflow-wrap: anywhere; }}
    .global-errors {{ border: 3px solid #cf222e; border-radius: .5rem; margin-bottom: 2rem; padding: 0 1rem; }}
    .global-errors li {{ overflow-wrap: anywhere; }}
    a {{ color: #0969da; }}
  </style>
</head>
<body>
  <header>
    <h1>Figure review</h1>
    <p>Overall validation: <strong>{overall_status}</strong>.
       {passed} of {len(reports)} figure PDFs passed.
       Previews rendered at {REVIEW_PPI} PPI.</p>
  </header>
  {validation_html}
  <main class="grid">{''.join(cards)}</main>
</body>
</html>
"""
    (REVIEW_ROOT / "index.html").write_text(document, encoding="utf-8")
    (REVIEW_ROOT / "review.md").write_text(
        "\n".join(markdown) + "\n",
        encoding="utf-8",
    )
    write_reports(reports, validation_errors)
    print(f"Wrote visual review gallery to {REVIEW_ROOT.relative_to(REPO_ROOT)}/index.html")


def assess_figures(
    figures: Sequence[Figure],
    *,
    rebuild: bool,
    render: bool,
) -> tuple[list[PdfReport], list[str]]:
    BUILD_ROOT.mkdir(parents=True, exist_ok=True)
    errors = expected_output_errors(figures)
    reports = {
        figure.output.resolve(): validate_pdf(figure)
        for figure in figures
    }
    if rebuild:
        try:
            errors.extend(reproducibility_reports(figures, reports))
        except PipelineError as exc:
            errors.append(str(exc))
            for report in reports.values():
                if str(exc) not in report.errors:
                    report.errors.append(str(exc))
    if render:
        for figure in figures:
            render_preview(figure, reports[figure.output.resolve()])
    ordered = [reports[figure.output.resolve()] for figure in figures]
    for report in ordered:
        errors.extend(f"{report.name}: {error}" for error in report.errors)
    return ordered, deduplicate(errors)


def deduplicate(items: Iterable[str]) -> list[str]:
    return list(dict.fromkeys(items))


def print_errors(errors: Sequence[str]) -> None:
    if not errors:
        return
    print(f"\nFigure checks failed with {len(errors)} issue(s):", file=sys.stderr)
    for error in errors:
        print(f"  - {error}", file=sys.stderr)


def clean_review_output() -> None:
    if REVIEW_ROOT.exists():
        shutil.rmtree(REVIEW_ROOT)
    PREVIEW_ROOT.mkdir(parents=True, exist_ok=True)
    REPORT_ROOT.mkdir(parents=True, exist_ok=True)


def run_checks(*, render: bool) -> int:
    figures = discover_all()
    errors = policy_errors()
    reports, assessment_errors = assess_figures(
        figures,
        rebuild=True,
        render=render,
    )
    errors.extend(assessment_errors)
    errors = deduplicate(errors)
    if render:
        write_gallery(figures, reports, errors)
    elif reports:
        write_reports(reports, errors)
    print_errors(errors)
    if errors:
        return 1
    print(f"All {len(figures)} figure(s) passed source, PDF, and reproducibility checks.")
    return 0


def latex_escape_detokenized(value: str) -> str:
    return value.replace("\\", "/")


def run_latex_smoke(figures: Sequence[Figure]) -> list[str]:
    errors: list[str] = []
    pdflatex = shutil.which("pdflatex")
    if not pdflatex:
        return [
            "required tool 'pdflatex' was not found. Install a minimal TeX Live "
            "distribution with latex-base and graphics support, or run "
            "'make test-figures' to execute all non-LaTeX figure checks."
        ]
    if not LATEX_FIXTURE.is_file():
        return [
            f"LaTeX fixture is missing: {LATEX_FIXTURE.relative_to(REPO_ROOT)}"
        ]
    if not figures:
        return ["LaTeX smoke test requires at least one generated figure."]

    latex_root = BUILD_ROOT / "latex-smoke"
    if latex_root.exists():
        shutil.rmtree(latex_root)
    output_root = latex_root / "out"
    output_root.mkdir(parents=True, exist_ok=True)
    pairs: list[str] = []
    for figure in figures:
        pdf_path = latex_escape_detokenized(figure.output.resolve().as_posix())
        label = latex_escape_detokenized(
            figure.source.relative_to(FIGURE_ROOT).as_posix()
        )
        pairs.append(
            "\\FigurePair"
            f"{{{pdf_path}}}"
            f"{{\\detokenize{{{label}}}}}"
        )
    driver = latex_root / "driver.tex"
    fixture_path = latex_escape_detokenized(LATEX_FIXTURE.resolve().as_posix())
    driver.write_text(
        "\\def\\FigurePipelineFigures{%\n"
        + "\n".join(pairs)
        + "\n}\n"
        + f"\\input{{{fixture_path}}}\n",
        encoding="utf-8",
    )
    result = run(
        [
            pdflatex,
            "-interaction=nonstopmode",
            "-halt-on-error",
            f"-output-directory={output_root}",
            driver,
        ],
        cwd=latex_root,
        env={"SOURCE_DATE_EPOCH": "0"},
    )
    if result.returncode != 0:
        log = output_root / "driver.log"
        log_hint = (
            f" See {log.relative_to(REPO_ROOT)}."
            if log.exists()
            else ""
        )
        errors.append(
            "LaTeX figure-inclusion smoke test failed."
            + log_hint
            + "\n"
            + (result.stdout + "\n" + result.stderr)[-4000:]
        )
    elif not (output_root / "driver.pdf").is_file():
        errors.append("pdflatex reported success but did not produce driver.pdf")
    else:
        print(
            "LaTeX inclusion smoke test passed: "
            f"{(output_root / 'driver.pdf').relative_to(REPO_ROOT)}"
        )
    return errors


def command_figure(args: argparse.Namespace) -> int:
    figure = resolve_figure(args.figure)
    compile_figure(figure)
    return 0


def command_figure_specimens(_: argparse.Namespace) -> int:
    compile_many(discover_specimens())
    return 0


def command_figures(_: argparse.Namespace) -> int:
    compile_many(discover_all())
    return 0


def command_check_figures(_: argparse.Namespace) -> int:
    return run_checks(render=False)


def command_figure_review(_: argparse.Namespace) -> int:
    clean_review_output()
    figures = discover_all()
    reports, assessment_errors = assess_figures(
        figures,
        rebuild=True,
        render=True,
    )
    errors = deduplicate(policy_errors() + assessment_errors)
    write_gallery(figures, reports, errors)
    print_errors(errors)
    return 1 if errors else 0


def command_test_figures(_: argparse.Namespace) -> int:
    clean_review_output()
    return run_checks(render=True)


def command_test(_: argparse.Namespace) -> int:
    clean_review_output()
    figure_status = run_checks(render=True)
    latex_errors = run_latex_smoke(discover_all())
    print_errors(latex_errors)
    return 1 if figure_status or latex_errors else 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    figure_parser = subparsers.add_parser("figure", help="compile one figure")
    figure_parser.add_argument(
        "--figure",
        required=True,
        help=(
            "path relative to source_material/figures, such as "
            "tests/specimens/diagram or src/chapter-01/open-loop"
        ),
    )
    figure_parser.set_defaults(handler=command_figure)

    for command, help_text, handler in [
        ("figure-specimens", "compile every specimen", command_figure_specimens),
        ("figures", "compile every specimen and production figure", command_figures),
        ("check-figures", "run source, PDF, and reproducibility checks", command_check_figures),
        ("figure-review", "build the visual review gallery", command_figure_review),
        ("test-figures", "run all non-LaTeX checks and build the gallery", command_test_figures),
        ("test", "run all checks, gallery generation, and LaTeX smoke test", command_test),
    ]:
        subparser = subparsers.add_parser(command, help=help_text)
        subparser.set_defaults(handler=handler)
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        return int(args.handler(args))
    except PipelineError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("error: interrupted", file=sys.stderr)
        return 130


if __name__ == "__main__":
    raise SystemExit(main())
