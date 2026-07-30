#import "/styles/figure.typ": *

// figure-pipeline: kind=test
// figure-pipeline: expected-size-pt=168,64
#standalone(
  cetz-canvas(
    length: 1pt,
    {
      draw.rect(
        (0, 0),
        (160, 56),
        fill: color-surface,
        stroke: (
          paint: color-border,
          thickness: line-normal,
          cap: "round",
          join: "miter",
        ),
        radius: 0pt,
      )

      // Keep the arrows on all four content edges to stress the safety margin,
      // but leave one full arrow length at each corner so adjacent stealth
      // arrowheads remain visually independent.
      draw.line((10, 0), (150, 0), ..diagram-bidirectional-style)
      draw.line((160, 10), (160, 46), ..diagram-bidirectional-style)
      draw.line((150, 56), (10, 56), ..diagram-bidirectional-style)
      draw.line((0, 46), (0, 10), ..diagram-bidirectional-style)

      draw.content((80, 4), anchor: "south", [bottom arrowheads])
      draw.content((155, 28), angle: 90deg, [right edge], wrap: figure-small)
      draw.content((80, 52), anchor: "north", [top arrowheads])
      draw.content((5, 28), angle: 90deg, [left edge], wrap: figure-small)
      draw.content((80, 31), [tight content bounds])
      draw.content((80, 23), [\+ 2 pt safety margin], wrap: figure-small)
    },
  )
)
