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

          // Equilibrium state.
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
          draw.content((equilibrium-x + 3, 37), [$N$])
          draw.line(
            (equilibrium-x, body-y - body-height / 2),
            (equilibrium-x, 4),
            ..force-style,
          )
          draw.content((equilibrium-x + 4, 7), [$m g$])
          draw.content(
            (equilibrium-x, 0),
            align(center)[Equilibrium #linebreak() $x = 0$],
          )

          // Displaced state.
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
          draw.content((displaced-x + 3, 37), [$N$])
          draw.line(
            (displaced-x, body-y - body-height / 2),
            (displaced-x, 4),
            ..force-style,
          )
          draw.content((displaced-x + 4, 7), [$m g$])
          draw.line(
            (displaced-x - body-width / 2, body-y),
            (38, body-y),
            ..force-style,
          )
          draw.content((44, body-y + 3), [$F_s = k x$])
          draw.content(
            (displaced-x, 0),
            align(center)[Displaced #linebreak() $x > 0$],
          )
        },
      ),
    ),
  ),
)
