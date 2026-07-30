#import "/styles/figure.typ": *
#import "/src/ch02/ch02_first_order_stable.typ": (
  first-order-stability-row,
  marginal-response,
)

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full

#standalone[
  #set text(size: figure-label-size)
  #first-order-stability-row(
    marginal-response,
    (0, 1.1),
    (0, 0.5, 1),
    [$x_c/x_0 = 1$],
    0,
  )
]
