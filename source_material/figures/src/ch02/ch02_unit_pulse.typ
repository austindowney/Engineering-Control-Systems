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
    ylabel: [$rho(t; tau)$],
    xlim: (-0.6, 2),
    ylim: (-0.2, 1.35),
    xaxis: (
      subticks: none,
      ticks: none,
    ),
    yaxis: (
      subticks: none,
      ticks: none,
    ),
    vlines(
      -0.5,
      0,
      0.5,
      1,
      1.5,
      2,
      stroke: plot-grid-stroke,
      z-index: 0,
    ),
    hlines(
      0,
      0.5,
      1,
      stroke: plot-grid-stroke,
      z-index: 0,
    ),
    rect(
      0,
      0,
      width: 1,
      height: 1,
      fill: color-secondary.transparentize(84%),
      stroke: none,
    ),
    plot(
      (-0.6, 0, 0, 1, 1, 2),
      (0, 0, 1, 1, 0, 0),
      stroke: signal-stroke,
    ),
    place(
      -0.04,
      1,
      [$1 / tau$],
      align: right + horizon,
    ),
    place(
      0,
      -0.08,
      [$0$],
      align: center + top,
    ),
    place(
      1,
      -0.08,
      [$tau$],
      align: center + top,
    ),
    place(
      0.5,
      0.48,
      [$A = tau (1 / tau) = 1$],
      align: center + horizon,
    ),
  )
]
