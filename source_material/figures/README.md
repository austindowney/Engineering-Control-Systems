# CeTZ and Lilaq figure system

This directory contains the reproducible vector-figure system for the book.
Authored figures are written in Typst, diagrams and mechanical schematics use
CeTZ, and every quantitative plot uses Lilaq. LaTeX imports the generated PDF
files and remains responsible for figure placement, captions, numbering, and
cross-references.

The generated PDFs are standalone, single-page documents whose page boxes fit
their drawings. They are not Letter- or A4-sized pages. The shared standalone
template uses:

```typst
#set page(width: auto, height: auto, margin: 2pt)
```

The 2 pt margin is a safety area for strokes, labels, and arrowheads. Do not
override the page size or margin in an individual figure.

## Natural-size width profiles

Figures are authored at their intended final width so LaTeX does not have to
shrink the text, strokes, or markers:

- **Full width:** 160 mm
- **Half width:** 80 mm

These deliberately rounded dimensions fit within the book's approximately
165 mm text block. Two 80 mm figures also fit side by side with approximately
5 mm left for separation. The PDF MediaBox includes the 2 pt safety margin, so
the generated file—not just its plot area—is exactly 160 mm or 80 mm wide.

Every plot declares its intended output width in a pipeline comment and passes
the same profile to `book-diagram`:

```typst
#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full
#standalone[
  #book-diagram(
    size: "full",
    // Lilaq axes and series.
  )
]
```

Use `size: "half"` with `width-profile=half` for a standalone half-width plot.
Both profiles keep the shared 9 pt typography and stroke dimensions; half-width
figures contain less horizontal plotting space rather than a scaled-down copy
of a full-width figure.

The `panel` plot size is reserved for panels composed inside one full-width
160 mm PDF. Two panel columns use an 8 mm internal gutter. If panels require
separate LaTeX subcaptions, export them as separate 80 mm PDFs instead.

In LaTeX, normally import these files at natural size:

```latex
\includegraphics{path/to/figure.pdf}
```

Avoid compiling a full-width figure and then setting
`\includegraphics[width=0.5\textwidth]{...}`; that also halves its fonts and
strokes. Explicit LaTeX scaling remains useful only for exceptional layouts.

## Requirements

The supported toolchain is:

- Typst **0.15.0**
- CeTZ **0.5.2**
- Lilaq **0.6.0**
- GNU Make
- Python 3.9 or newer
- Poppler utilities (`pdfinfo`, `pdffonts`, `pdfimages`, and `pdftocairo`)
- Ghostscript
- a LaTeX installation containing `pdflatex` and `graphicx`

CeTZ and Lilaq are pinned in the shared style modules and are downloaded into
Typst's package cache on first use. Typst 0.15.0 includes New Computer Modern
and New Computer Modern Math. Builds use `--ignore-system-fonts`, so figure
typography does not depend on fonts installed on a contributor's computer.

On Debian or Ubuntu, the external PDF and LaTeX tools can be installed with:

```bash
sudo apt-get install ghostscript poppler-utils texlive-latex-base
```

Run all commands below from the repository root.

## Directory layout

```text
source_material/figures/
├── README.md
├── styles/                 shared colors, typography, dimensions, and styles
├── src/                    production figure sources, grouped by chapter
├── tests/
│   └── specimens/          visual and integration fixtures
└── generated/
    ├── specimens/          committed specimen PDFs
    └── ...                 committed production PDFs, grouped by chapter

build/
└── figure-review/          ignored local review gallery and reports
```

The Typst source is authoritative, but its generated PDF is committed so that
LaTeX-only contributors can build the book without installing Typst. Temporary
previews, reports, and LaTeX smoke-test files belong under `build/` and are not
committed.

## Build commands

The public build interface is:

```bash
make figure FIGURE=tests/specimens/diagram
make figure-specimens
make figures
make check-figures
make figure-review
make test-figures
make test
```

`make figure` accepts a path relative to `source_material/figures/`, with or
without the `.typ` extension. For example:

```bash
make figure FIGURE=tests/specimens/diagram
make figure FIGURE=src/chapter-02/free-decay.typ
```

The first command writes
`source_material/figures/generated/specimens/diagram.pdf`; the second writes
`source_material/figures/generated/chapter-02/free-decay.pdf`.

The remaining targets have these roles:

- `figure-specimens` builds every visual specimen.
- `figures` builds all specimen and production figure sources.
- `check-figures` enforces source policy and validates committed PDFs.
- `figure-review` checks the committed outputs and builds the human-readable
  review gallery without overwriting PDFs.
- `test-figures` runs source, compile, PDF, reproducibility, and gallery checks.
- `test` runs all figure checks plus the LaTeX `graphicx` smoke test.

All Typst compilation is performed with a fixed project root, ignored system
fonts, and `SOURCE_DATE_EPOCH=0`. Do not invoke Typst with different flags when
updating a committed PDF.

## Authoring a figure

Create a production source under `src/chapter-NN/` and import only the public
figure entry point:

```typst
#import "/styles/figure.typ": *

// figure-pipeline: kind=diagram
#standalone[
  // Figure content.
]
```

For a CeTZ canvas:

```typst
#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#standalone(
  cetz-canvas({
    // Raw CeTZ drawing calls.
  }),
)
```

Use semantic colors, dimensions, and style dictionaries exported by the shared
modules. Hard-coded RGB or hexadecimal colors outside `styles/colors.typ` are
rejected by `make check-figures`. Fixed page dimensions and unpinned Typst
package imports are rejected as well. Every source must declare exactly one
classification in a `figure-pipeline: kind=...` comment. Supported kinds are
`plot`, `surface`, `diagram`, `mechanics`, `style`, and `test`.

After adding or changing a figure:

1. Build it with `make figure FIGURE=src/chapter-NN/figure-name`.
2. Run `make figure-review` and inspect the rendered result at its intended
   book size.
3. Run `make test`.
4. Commit both the `.typ` source and its generated `.pdf`.

Use lowercase kebab-case names and give the source and PDF identical stems.

## Lilaq-only plots

Lilaq is mandatory for every two-dimensional quantitative plot. Only
`styles/plots.typ` may import `@preview/lilaq:0.6.0`, and production sources
must not call `lq.diagram` directly. Use the shared plot interface exported by
`figure.typ`, especially `book-diagram`, so axes, labels, legends, colors, and
line styles remain consistent across the book. The default plot treatment uses
Lilaq's conventional rectangular frame: the bottom and left axes carry labels
and inward ticks, while tickless mirrors close the top and right edges. The
wrapper also applies the shared book dimensions, light major grid, palette,
line cycle, and square-cornered legend treatment. A figure may still place its
axes explicitly—for example, a pole-zero map can cross them at the origin and
disable the mirrors.

Declare quantitative figures with `figure-pipeline: kind=plot`. The policy
check requires every plot-classified source to call `book-diagram`; a raw CeTZ
axes-and-curve replacement will not satisfy that classification. It also
requires a `width-profile=full|half` declaration and verifies that the
generated PDF has the corresponding 160 mm or 80 mm MediaBox width.
The shared series cycle combines semantic colors with solid, dashed, dash-dot,
and dotted strokes so plots remain distinguishable in grayscale.

Three-dimensional mathematical surfaces are the narrow exception because
Lilaq does not provide a 3D surface constructor. Declare these as
`figure-pipeline: kind=surface`; the policy then requires the pinned
`@preview/plotsy-3d:0.2.1` import and a Plotsy 3D surface constructor. Surface
figures retain the same width-profile, shared color, typography, standalone
page, and caption policies as Lilaq plots.

Do not set Lilaq's `title:` field in a plot source. Plot titles belong in the
LaTeX `\caption{...}` so numbering, typography, spacing, and the list of
figures remain under the book's control. The source-policy check enforces this
rule. If a multipanel figure needs independently numbered subcaptions, export
the panels as separate PDFs and compose them with the book's LaTeX subfigure
mechanism. Use `book-layout` only when the complete panel group is described by
one LaTeX caption.

Do not imitate an axis, response curve, pole-zero map, or data series with raw
CeTZ primitives. CeTZ remains appropriate for annotations around a Lilaq plot
when the shared plot interface does not provide the required annotation.

## Diagrams and mechanics

Control diagrams and mechanical schematics deliberately use raw CeTZ. The
shared modules provide style dictionaries and dimensional constants, not an
automatic layout system or a library of fixed component constructors.

Place shapes intentionally, give important elements CeTZ names, and connect
them with CeTZ's native anchors. This keeps unusual engineering diagrams
possible without requiring a custom routing engine. Add a higher-level helper
only after a repeated construction has a stable visual and semantic pattern.

The standard negative-feedback summing junction is available as
`summing-node(position, name: "sum", radius: diagram-node-radius)`. It creates
the named circular node together with its black plus and minus symbols, so
figures only need to connect signals to the node's native CeTZ boundary.

Shared signal, force, and displacement styles use stealth arrowheads.
Rectangular blocks, bodies, swatches, frames, and legends use square corners;
round forms are reserved for semantic elements such as summing nodes, poles,
zeros, branch points, and rollers. Mechanical figures should make each
physical load path and boundary condition explicit—for example, a parallel
spring and damper must each visibly connect the fixed support to the mass.

The shared arrowhead tokens are `arrow-small`, `arrow-medium`, and
`arrow-large`. They select the common stealth shape and its head dimensions
only. Line paint, thickness, dash, cap, and join remain separate stroke
properties. Standard signal, feedback, force, and displacement styles use
`arrow-small`; individual figures may combine a larger arrowhead token with
their own stroke when additional emphasis is required.

## Visual review and PDF checks

Run:

```bash
make figure-review
```

Then open `build/figure-review/index.html`. The gallery includes a 144-PPI
preview for each specimen along with source and PDF links, physical dimensions,
page count, font status, reproducibility status, and PDF validation results. A
Markdown version is available at `build/figure-review/review.md`, and
machine-readable reports are stored under `build/figure-review/reports/`.
Copies of each source and PDF are included inside the gallery directory, so
all links continue to work when the CI artifact is downloaded on its own.

The automated checks require each generated PDF to:

- contain exactly one content-sized page;
- avoid Letter and A4 page dimensions;
- use the shared auto-sized template with its 2 pt clipping guard;
- contain valid PDF data and embedded, non-Type-3 fonts;
- render to a nonempty preview with the correct aspect ratio;
- rebuild byte-for-byte identically with `SOURCE_DATE_EPOCH=0`; and
- import successfully through LaTeX's `graphicx` at natural and scaled sizes
  with an external LaTeX caption.

The bounding-box stress specimen verifies the known content dimensions plus
the 2 pt margin within ±0.25 pt and places labels and stealth arrowheads at all
four edges. The remaining figures inherit that tested template and are also
inspected through the rendered gallery.

Pull requests that affect the figure system run the same `make test` command.
The workflow uploads `build/figure-review/` as the **figure-review** artifact
even when validation fails, when enough output exists to create the gallery.

Visual golden baselines are intentionally not enabled in the initial
foundation. After the specimen gallery is reviewed and approved, a later
change will add blocking image comparisons and an explicit
`make approve-figure-baselines` command. That command does not exist yet and
must not be used as part of the current workflow.
