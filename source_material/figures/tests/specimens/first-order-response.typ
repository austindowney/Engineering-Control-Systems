#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=half
#let times = range(81).map(index => index / 10)

#standalone[
  #book-diagram(
    size: "half",
    xlabel: $t slash tau$,
    ylabel: $y(t) / y_infinity$,
    xlim: (0, 8),
    ylim: (0, 1.12),
    yaxis: (
      subticks: none,
      ticks: (0, 0.2, 0.4, 0.6, 0.8, 1),
    ),
    legend: (position: bottom + right),
    line(
      (0, 1),
      (8, 1),
      stroke: plot-guide-stroke,
      label: [$y_infinity = 1$],
    ),
    plot(
      times,
      time => 1 - calc.exp(-time),
      label: [$1 - e^(-t/tau)$],
    ),
  )
]
