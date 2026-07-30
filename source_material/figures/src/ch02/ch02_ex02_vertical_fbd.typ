#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
// figure-pipeline: width-profile=half
#standalone(
  box(
    width: figure-content-width("half"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          let equilibrium-x = 18
          let displaced-x = 60
          let body-y = 22
          let body-width = 16
          let body-height = 16
          let force-style = mechanics-force-style

          // Equilibrium state: static spring deflection delta.
          draw.rect(
            (
              equilibrium-x - body-width / 2,
              body-y - body-height / 2,
            ),
            (
              equilibrium-x + body-width / 2,
              body-y + body-height / 2,
            ),
            ..mechanics-body-style,
          )
          draw.content((equilibrium-x, body-y), [$m$])
          draw.line(
            (equilibrium-x, body-y + body-height / 2),
            (equilibrium-x, 40),
            ..force-style,
          )
          draw.content((equilibrium-x + 5, 37), [$k delta$])
          draw.line(
            (equilibrium-x, body-y - body-height / 2),
            (equilibrium-x, 4),
            ..force-style,
          )
          draw.content((equilibrium-x + 4, 7), [$m g$])
          draw.content(
            (equilibrium-x, 0),
            [Equilibrium],
          )

          // State displaced an additional distance x downward.
          draw.rect(
            (
              displaced-x - body-width / 2,
              body-y - body-height / 2,
            ),
            (
              displaced-x + body-width / 2,
              body-y + body-height / 2,
            ),
            ..mechanics-body-style,
          )
          draw.content((displaced-x, body-y), [$m$])
          draw.line(
            (displaced-x, body-y + body-height / 2),
            (displaced-x, 40),
            ..force-style,
          )
          draw.content(
            (displaced-x + 7.5, 37),
            [$k (delta + x)$],
          )
          draw.line(
            (displaced-x, body-y - body-height / 2),
            (displaced-x, 4),
            ..force-style,
          )
          draw.content((displaced-x + 4, 7), [$m g$])
          draw.content(
            (displaced-x, 0),
            [Displaced],
          )
        },
      ),
    ),
  ),
)
