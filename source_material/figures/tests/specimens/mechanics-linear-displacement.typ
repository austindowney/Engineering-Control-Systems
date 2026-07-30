#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#standalone(
  cetz-canvas(
    length: 1mm,
    {
      displacement-indicator(
        (0, 18),
        length: 28,
        label: [$x$],
      )
      draw.content((14, 12), [horizontal])

      displacement-indicator(
        (44, 2),
        length: 25,
        angle: 90deg,
        label: [$y$],
      )
      draw.content((44, -2), [vertical])

      displacement-indicator(
        (66, 4),
        length: 27,
        angle: 35deg,
        label: [$s$],
      )
      draw.content((78, 1), [inclined])
    },
  )
)
