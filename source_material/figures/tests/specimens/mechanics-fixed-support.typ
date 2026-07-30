#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#standalone(
  cetz-canvas(
    length: 1mm,
    {
      // The same 2 cm support in all four cardinal directions.
      fixed-support(
        (0, 27),
        length: 2cm,
        direction: 0,
        hatch-direction: "forward",
      )
      draw.content((10, 22), [direction: 0])

      fixed-support(
        (36, 7),
        length: 2cm,
        direction: 90,
        hatch-direction: "forward",
      )
      draw.content((36, 3), [direction: 90])

      fixed-support(
        (76, 27),
        length: 2cm,
        direction: 180,
        hatch-direction: "forward",
      )
      draw.content((66, 22), [direction: 180])

      fixed-support(
        (98, 27),
        length: 2cm,
        direction: 270,
        hatch-direction: "forward",
      )
      draw.content((98, 3), [direction: 270])

      // Direction names mirror the fixed 35-degree diagonal strokes.
      fixed-support(
        (0, -6),
        length: 2cm,
        direction: 0,
        hatch-direction: "forward",
      )
      draw.content((10, -11), [forward])

      fixed-support(
        (56, -6),
        length: 2cm,
        direction: 0,
        hatch-direction: "backward",
      )
      draw.content((66, -11), [backward])
    },
  )
)
