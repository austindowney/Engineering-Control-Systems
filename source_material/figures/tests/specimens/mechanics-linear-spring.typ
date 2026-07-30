#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#standalone(
  cetz-canvas(
    length: 1mm,
    {
      draw.content((0, 28), anchor: "west", text(weight: "bold")[2 cm])
      linear-spring(
        (18, 28),
        length: 2cm,
        coils: 8,
        amplitude: 2,
        lead: 3,
      )

      draw.content((0, 17), anchor: "west", text(weight: "bold")[3 cm])
      linear-spring(
        (18, 17),
        length: 3cm,
        coils: 8,
        amplitude: 2,
        lead: 3,
      )

      draw.content((0, 6), anchor: "west", text(weight: "bold")[4 cm])
      linear-spring(
        (18, 6),
        length: 4cm,
        coils: 8,
        amplitude: 2,
        lead: 3,
      )
    },
  )
)
