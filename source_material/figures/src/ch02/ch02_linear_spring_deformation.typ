#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full
#let deflections = range(41).map(index => -1 + index / 20)

#let spring-states = box(
  width: plot-panel-width,
  align(
    center,
    cetz-canvas(
      length: 1mm,
      {
        let compressed-x = 10
        let rest-x = 37.5
        let extended-x = 65
        let support-y = 8
        let compressed-y = 25
        let rest-y = 34
        let extended-y = 46

        // The unloaded height is the common displacement datum.
        draw.line(
          (2, rest-y),
          (73, rest-y),
          ..mechanics-reference-style,
        )

        // Compressed state under an applied compressive force.
        linear-spring(
          (compressed-x, support-y),
          length: compressed-y - support-y,
          angle: 90deg,
          coils: 6,
          amplitude: 1.7,
          lead: 3,
        )
        fixed-support(
          (compressed-x - 8, support-y),
          length: 16,
          hatch-side: -1,
        )
        draw.circle(
          (compressed-x, compressed-y),
          radius: 1.3,
          fill: color-on-light,
          stroke: none,
        )
        draw.line(
          (compressed-x, compressed-y + 9),
          (compressed-x, compressed-y),
          ..mechanics-force-style,
        )
        draw.content((compressed-x + 3.6, compressed-y + 6), [$F$])
        draw.content(
          (compressed-x, 0),
          align(center)[Compressed #linebreak() $x < 0$],
        )

        // Unloaded reference state.
        linear-spring(
          (rest-x, support-y),
          length: rest-y - support-y,
          angle: 90deg,
          coils: 7,
          amplitude: 1.7,
          lead: 4,
        )
        fixed-support(
          (rest-x - 8, support-y),
          length: 16,
          hatch-side: -1,
        )
        draw.circle(
          (rest-x, rest-y),
          radius: 1.3,
          fill: color-on-light,
          stroke: none,
        )
        draw.content((rest-x, rest-y + 7), [$F = 0$])
        draw.content(
          (rest-x, 0),
          align(center)[Rest #linebreak() $x = 0$],
        )

        // Extended state under an applied tensile force.
        linear-spring(
          (extended-x, support-y),
          length: extended-y - support-y,
          angle: 90deg,
          coils: 7,
          amplitude: 1.7,
          lead: 4,
        )
        fixed-support(
          (extended-x - 8, support-y),
          length: 16,
          hatch-side: -1,
        )
        draw.circle(
          (extended-x, extended-y),
          radius: 1.3,
          fill: color-on-light,
          stroke: none,
        )
        draw.line(
          (extended-x, extended-y),
          (extended-x, extended-y + 9),
          ..mechanics-force-style,
        )
        draw.content((extended-x + 3.6, extended-y + 6), [$F$])
        draw.content(
          (extended-x, 0),
          align(center)[Extended #linebreak() $x > 0$],
        )
      },
    ),
  ),
)

#let spring-plot = book-diagram(
  size: "panel",
  height: 55mm,
  xlabel: [Deflection, $x$],
  ylabel: [Force, $F$],
  xlim: (-1.1, 1.1),
  ylim: (-1.1, 1.1),
  xaxis: (
    subticks: none,
    ticks: (-1, -0.5, 0, 0.5, 1),
  ),
  yaxis: (
    subticks: none,
    ticks: (-1, -0.5, 0, 0.5, 1),
  ),
  line(
    (0.7, -1.1),
    (0.7, 0.7),
    stroke: plot-guide-stroke,
  ),
  line(
    (-1.1, 0.7),
    (0.7, 0.7),
    stroke: plot-guide-stroke,
  ),
  plot(deflections, deflection => deflection),
  scatter(
    (-0.7, 0, 0.7),
    (-0.7, 0, 0.7),
    mark: "o",
    size: 6pt,
    color: color-secondary,
    stroke: line-normal + color-secondary,
  ),
  place(
    0.16,
    0.82,
    [$F = k x$],
    align: left + bottom,
  ),
  place(
    0.7,
    -1.02,
    [$x$],
    align: center + bottom,
  ),
  place(
    -1.02,
    0.7,
    [$F$],
    align: left + horizon,
  ),
)

#standalone[
  #book-layout(
    grid(
      columns: (plot-panel-width, plot-panel-width),
      column-gutter: plot-panel-gutter,
      align: center + horizon,
      spring-states,
      spring-plot,
    )
  )
]
