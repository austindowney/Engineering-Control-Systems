#import "/styles/figure.typ": *
#import "/src/ch02/ch02_second_order_stable.typ": (
  marginal-envelope,
  marginal-response,
  second-order-stability-row,
)

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full

#standalone[
  #set text(size: figure-label-size)
  #second-order-stability-row(
    marginal-response,
    marginal-envelope,
    (-1.5, 1.5),
    (-1.5, -1, -0.5, 0, 0.5, 1, 1.5),
    [$sin(omega_n t + phi)$],
    4,
    1.28,
    0,
  )
]
