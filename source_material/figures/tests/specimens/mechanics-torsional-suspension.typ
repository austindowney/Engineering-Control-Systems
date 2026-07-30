#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#standalone(
  cetz-canvas(
    length: 1mm,
    {
      torsional-suspension(
        (15, 38),
        length: 3cm,
        support-width: 2.4cm,
        body-width: 14,
        body-height: 10,
      )
    },
  )
)
