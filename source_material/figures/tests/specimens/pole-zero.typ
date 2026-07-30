#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=half
#standalone[
  #book-diagram(
    size: "half",
    height: auto,
    aspect-ratio: 1,
    xlim: (-5, 1),
    ylim: (-3, 3),
    legend: (position: top + left),
    xaxis: (
      position: 0,
      mirror: false,
      subticks: none,
      ticks: (-5, -4, -3, -2, -1, 0, 1),
    ),
    yaxis: (
      position: 0,
      mirror: false,
      subticks: none,
      ticks: (-3, -2, -1, 1, 2, 3),
    ),
    place(
      0.88,
      -0.4,
      [$upright("Re")(s)$],
      align: right + top,
    ),
    place(
      0.12,
      2.86,
      [$upright("Im")(s)$],
      align: left + top,
    ),
    scatter(
      (-1, -2.3, -2.3),
      (0, 2.1, -2.1),
      mark: "x",
      size: 8pt,
      color: color-primary,
      stroke: line-emphasis + color-primary,
      label: [Poles],
    ),
    scatter(
      (-4,),
      (0,),
      mark: "o",
      size: 8pt,
      color: color-background,
      stroke: line-emphasis + color-secondary,
      label: [Zero],
    ),
  )
]
