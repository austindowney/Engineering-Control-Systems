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
    ylabel: [$Phi(t)$],
    xlim: (-1.5, 4),
    ylim: (-0.2, 1.35),
    xaxis: (
      subticks: none,
      ticks: (-1, 0, 1, 2, 3, 4),
    ),
    yaxis: (
      subticks: none,
      ticks: (0, 0.5, 1),
    ),
    plot(
      (-1.5, 0, 0, 4),
      (0, 0, 1, 1),
      stroke: signal-stroke,
    ),
    place(
      2.1,
      1.08,
      [unit level],
      align: center + bottom,
    ),
    place(
      0.08,
      0.18,
      [$t = 0$],
      align: left + bottom,
    ),
  )
]
