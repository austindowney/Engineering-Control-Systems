#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#standalone(
  cetz-canvas(
    length: 1mm,
    {
      torsional-spring(
        (13, 13),
        turns: 2.75,
        outer-radius: 5,
        inner-radius: 1.4,
        lead: 7,
      )
      draw.content((13, 4), [standard])

      torsional-spring(
        (48, 13),
        angle: 90deg,
        turns: 3.25,
        outer-radius: 6,
        inner-radius: 1.3,
        lead: 7,
      )
      draw.content((48, 4), [rotated])
    },
  )
)
