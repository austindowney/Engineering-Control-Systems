#import "/styles/figure.typ": *
#import "/src/ch02/ch02_first_order_stable.typ": (
  first-order-stability-row,
  unstable-response,
)

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full

#standalone[
  #set text(size: figure-label-size)
  #first-order-stability-row(
    unstable-response,
    (0, 21),
    (0, 10, 20),
    [$x_c/x_0 = e^t$],
    1,
  )
]
