#import "/styles/figure.typ": *

// figure-pipeline: kind=style
#let swatch(name, color, foreground) = box(
  width: 27mm,
  height: 13mm,
  inset: 2mm,
  fill: color,
  stroke: (paint: color-border, thickness: line-hairline),
  radius: 0pt,
  align(center + horizon)[
    #text(fill: foreground, weight: "bold", size: figure-small-text-size)[#name]
  ],
)

#let specimen-heading(body) = text(
  size: figure-text-size,
  weight: "semibold",
  body,
)

#let stroke-sample(name, thickness, dash: "solid") = grid(
  columns: (25mm, 41mm),
  column-gutter: 3mm,
  align: horizon,
  figure-small(name),
  box(
    width: 41mm,
    height: 4mm,
    align(
      horizon,
      std.line(
        length: 41mm,
        stroke: (
          paint: color-ink,
          thickness: thickness,
          dash: dash,
          cap: "round",
        ),
      ),
    ),
  ),
)

#let arrow-sample(head) = cetz-canvas(
  length: 1pt,
  {
    draw.line(
      (0, 0),
      (112, 0),
      stroke: (
        paint: color-primary,
        thickness: line-emphasis,
        cap: "butt",
        join: "miter",
      ),
      mark: (fill: color-primary, ..head),
    )
  },
)

#standalone[
  #figure-title[Figure palette and typography]
  #v(2.5mm)
  #specimen-heading[Semantic colors]
  #v(1.5mm)
  #grid(
    columns: 3,
    gutter: 2.5mm,
    swatch("Garnet rose", color-garnet-rose, color-background),
    swatch("Deep teal", color-deep-teal, color-background),
    swatch("Graphite", color-graphite, color-background),
    swatch("Brass", color-brass, color-on-light),
    swatch("Slate", color-slate, color-background),
    swatch("Cool grey", color-cool-grey, color-on-light),
  )
  #v(3mm)
  #specimen-heading[Neutrals and surfaces]
  #v(1.5mm)
  #grid(
    columns: 4,
    gutter: 2mm,
    swatch("Ink", color-ink, color-background),
    swatch("Muted", color-muted, color-background),
    swatch("Border", color-border, color-background),
    swatch("Guide", color-guide, color-on-light),
    swatch("Grid", color-grid, color-on-light),
    swatch("Surface", color-surface, color-on-light),
    swatch("Surface strong", color-surface-strong, color-on-light),
    swatch("Background", color-background, color-on-light),
  )
  #v(3mm)
  #specimen-heading[Stroke and arrow language]
  #v(1.5mm)
  #grid(
    columns: 2,
    column-gutter: 8mm,
    row-gutter: 1mm,
    stroke-sample("Hairline", line-hairline),
    stroke-sample("Normal", line-normal),
    stroke-sample("Emphasis", line-emphasis),
    stroke-sample("Heavy", line-heavy),
    stroke-sample("Dashed guide", line-normal, dash: "dashed"),
    [],
    grid(
      columns: (25mm, 41mm),
      column-gutter: 3mm,
      align: horizon,
      figure-small[Small arrow],
      box(width: 41mm, height: 4mm, align(horizon, arrow-sample(arrow-small))),
    ),
    grid(
      columns: (25mm, 41mm),
      column-gutter: 3mm,
      align: horizon,
      figure-small[Medium arrow],
      box(width: 41mm, height: 4mm, align(horizon, arrow-sample(arrow-medium))),
    ),
    grid(
      columns: (25mm, 41mm),
      column-gutter: 3mm,
      align: horizon,
      figure-small[Large arrow],
      box(width: 41mm, height: 4mm, align(horizon, arrow-sample(arrow-large))),
    ),
    [],
  )
  #v(3mm)
  #specimen-heading[Typography and mathematics]
  #v(1.5mm)
  #grid(
    columns: (27mm, auto),
    column-gutter: 4mm,
    row-gutter: 1.5mm,
    [Body],
    [New Computer Modern for explanatory labels and annotations.],
    [Small],
    figure-small[Secondary labels remain legible at their intended book size.],
    [Mathematics],
    [$G(s) = (omega_n^2) / (s^2 + 2 zeta omega_n s + omega_n^2)$],
    [Vectors],
    [$dot(bold(x))(t) = bold(A) bold(x)(t) + bold(B) bold(u)(t)$],
  )
]
