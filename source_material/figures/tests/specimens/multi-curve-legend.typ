#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full
#let times = range(161).map(index => index / 20)

#let response(zeta, time) = {
  let omega-d = calc.sqrt(1 - zeta * zeta)
  1 - calc.exp(-zeta * time) * (
    calc.cos(omega-d * time)
    + zeta / omega-d * calc.sin(omega-d * time)
  )
}

#standalone[
  #book-diagram(
    size: "full",
    xlabel: $omega_n t$,
    ylabel: $y(t) / y_infinity$,
    xlim: (0, 8),
    ylim: (0, 1.65),
    legend: (position: top + right),
    line((0, 1), (8, 1), stroke: plot-guide-stroke),
    place(
      7.85,
      1.03,
      figure-small[$y_infinity = 1$],
      align: right + bottom,
    ),
    plot(times, time => response(0.2, time), label: [$zeta = 0.2$]),
    plot(times, time => response(0.45, time), label: [$zeta = 0.45$]),
    plot(times, time => response(0.7, time), label: [$zeta = 0.7$]),
  )
]
