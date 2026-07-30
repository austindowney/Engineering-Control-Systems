#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#standalone(
  cetz-canvas(
    length: 1mm,
    {
      draw.content((0, 48), anchor: "west", text(weight: "bold")[Fixed supports])
      fixed-support((0, 43), length: 24)
      fixed-support((34, 31), length: 24, direction: 90)
      fixed-support((66, 43), length: 24, hatch-side: 1)
      draw.content((12, 38), [floor])
      draw.content((29, 43), [wall])
      draw.content((78, 38), [ceiling])

      draw.content((0, 27), anchor: "west", text(weight: "bold")[Linear springs])
      linear-spring((0, 20), length: 25, coils: 8)
      linear-spring((38, 9), length: 22, angle: 90deg, coils: 7)
      linear-spring((68, 12), length: 25, angle: 35deg, coils: 8)

      draw.content((0, 6), anchor: "west", text(weight: "bold")[Torsional spring])
      torsional-spring((18, -3), turns: 2.75)

      draw.content((104, 48), anchor: "west", text(weight: "bold")[Dampers])
      viscous-damper((104, 40), length: 25, body-width: 7)
      viscous-damper(
        (111, 10),
        length: 25,
        angle: 90deg,
        body-width: 7,
      )
      viscous-damper(
        (139, 18),
        length: 25,
        angle: 135deg,
        body-width: 7,
      )

      draw.content((104, 6), anchor: "west", text(weight: "bold")[Displacement])
      displacement-indicator((104, -2), length: 24, label: [$x$])
      displacement-indicator(
        (140, -8),
        length: 19,
        angle: 90deg,
        label: [$y$],
      )
    },
  )
)
