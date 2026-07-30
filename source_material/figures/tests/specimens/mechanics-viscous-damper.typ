#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#standalone(
  cetz-canvas(
    length: 1mm,
    {
      viscous-damper(
        (0, 23),
        length: 3cm,
      )
      draw.content((15, 14), [horizontal])

      viscous-damper(
        (44, 3),
        length: 3cm,
        angle: 90deg,
      )
      draw.content((44, -1), [vertical])

      viscous-damper(
        (72, 5),
        length: 3cm,
        angle: 40deg,
      )
      draw.content((83, 1), [inclined])
    },
  )
)
