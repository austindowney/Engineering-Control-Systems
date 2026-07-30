#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=half
#let signal-stroke = (
  paint: color-secondary,
  thickness: plot-stroke-width,
  cap: "butt",
  join: "miter",
)

#standalone[
  #book-diagram(
    size: "half",
    height: 44mm,
    xlabel: [$t$],
    ylabel: [$delta(t)$],
    xlim: (-2, 2),
    ylim: (-0.15, 1.25),
    xaxis: (
      subticks: none,
      ticks: (-2, -1, 0, 1, 2),
    ),
    yaxis: (
      subticks: none,
      ticks: none,
    ),
    hlines(
      0,
      0.5,
      1,
      stroke: plot-grid-stroke,
      z-index: 0,
    ),
    plot(
      (-2, 2),
      (0, 0),
      stroke: signal-stroke,
    ),
    line(
      (0, 0),
      (0, 1.08),
      stroke: signal-stroke,
      tip: plot-stealth-tip,
    ),
    place(
      0.12,
      0.92,
      [unit impulse],
      align: left + horizon,
    ),
    place(
      0.12,
      0.68,
      [$A = 1$],
      align: left + horizon,
    ),
  )
]
