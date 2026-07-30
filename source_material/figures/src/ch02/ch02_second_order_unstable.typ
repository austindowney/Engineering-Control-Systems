#import "/styles/figure.typ": *
#import "/src/ch02/ch02_second_order_stable.typ": (
  second-order-stability-row,
  unstable-envelope,
  unstable-response,
)

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full

#standalone[
  #set text(size: figure-label-size)
  #second-order-stability-row(
    unstable-response,
    unstable-envelope,
    (-4.6, 4.6),
    (-4, -2, 0, 2, 4),
    [$e^(abs(zeta) omega_n t) sin(omega_d t + phi)$],
    3.25,
    3.65,
    0.6,
    callout-start: (5.55, 3.3),
    callout-end: (
      7,
      calc.exp(0.18 * 7) * calc.sin(2.8 * 7),
    ),
  )
]
