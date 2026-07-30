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
    ylabel: [$r(t)$],
    xlim: (-2, 2),
    ylim: (-0.2, 2.25),
    xaxis: (
      subticks: none,
      ticks: (-2, -1, 0, 1, 2),
    ),
    yaxis: (
      subticks: none,
      ticks: (0, 0.5, 1, 1.5, 2),
    ),
    plot(
      (-2, 0, 2),
      (0, 0, 2),
      stroke: signal-stroke,
    ),
    line(
      (0.25, 0.25),
      (1.25, 0.25),
      stroke: plot-guide-stroke,
    ),
    line(
      (1.25, 0.25),
      (1.25, 1.25),
      stroke: plot-guide-stroke,
    ),
    place(
      0.75,
      0.32,
      [$Delta t = 1$],
      align: center + bottom,
    ),
    place(
      1.32,
      0.75,
      figure-small[$Delta r = 1$],
      align: left + horizon,
    ),
    place(
      0.25,
      1.05,
      [unit slope],
      align: left + bottom,
    ),
  )
]
