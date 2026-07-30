// figure-pipeline: kind=mechanics
// figure-pipeline: width-profile=full

#import "/styles/figure.typ": *

#standalone(
  box(
    width: figure-content-width("full"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          // (a) Forced spring--mass--damper system.
          let wall-x = 5
          let spring-y = 30
          let damper-y = 20
          let mass-left = 43
          let mass-right = 65
          let mass-bottom = 14
          let mass-top = 36
          let center-y = (mass-bottom + mass-top) / 2

          fixed-support(
            (wall-x, 38.5),
            length: 27,
            direction: 270,
            hatch-side: -1,
          )
          linear-spring(
            (wall-x, spring-y),
            length: mass-left - wall-x,
            coils: 8,
            amplitude: 2.4,
            lead: 6,
          )
          viscous-damper(
            (wall-x, damper-y),
            length: mass-left - wall-x,
          )
          draw.content(
            ((wall-x + mass-left) / 2, spring-y + 5),
            [$k$],
          )
          draw.content(
            ((wall-x + mass-left) / 2, damper-y + 5),
            [$c$],
          )

          draw.rect(
            (mass-left, mass-bottom),
            (mass-right, mass-top),
            ..mechanics-body-style,
          )
          draw.content(
            ((mass-left + mass-right) / 2, center-y),
            [$m$],
          )

          for x in (45.2, 49.6, 54, 58.4, 62.8) {
            draw.circle(
              (x, mass-bottom - 1.45),
              radius: 1.15,
              ..mechanics-roller-style,
            )
          }
          fixed-support(
            (40, mass-bottom - 2.85),
            length: 29,
            hatch-side: -1,
          )

          displacement-indicator(
            (mass-right, mass-top + 4),
            length: 12,
            label: [$x$],
            label-offset: 2.3,
            extension: 1.7,
          )

          draw.line(
            (mass-right, center-y),
            (82, center-y),
            ..mechanics-force-style,
          )
          draw.content((74, center-y + 3.5), [$F(t)$])
          draw.content((43.5, 0), [(a)])

          // (b) Free-body diagram of the mass.
          let body-left = 112
          let body-right = 134
          let body-bottom = 14
          let body-top = 36
          let body-center-x = (body-left + body-right) / 2
          let body-center-y = (body-bottom + body-top) / 2

          draw.rect(
            (body-left, body-bottom),
            (body-right, body-top),
            ..mechanics-body-style,
          )
          draw.content((body-center-x, body-center-y), [$m$])

          draw.line(
            (body-left, 30),
            (91, 30),
            ..mechanics-force-style,
          )
          draw.content((99, 33.5), [$F_s = k x$])

          draw.line(
            (body-left, 20),
            (91, 20),
            ..mechanics-force-style,
          )
          draw.content((99, 16.5), [$F_d = c dot(x)$])

          draw.line(
            (body-right, body-center-y),
            (155, body-center-y),
            ..mechanics-force-style,
          )
          draw.content((146, body-center-y + 3.5), [$F(t)$])

          draw.line(
            (body-center-x, body-bottom),
            (body-center-x, 5),
            ..mechanics-force-style,
          )
          draw.content((body-center-x + 4, 8), [$m g$])

          draw.line(
            (body-center-x, body-top),
            (body-center-x, 45),
            ..mechanics-force-style,
          )
          draw.content((body-center-x + 3, 43), [$N$])

          draw.content((body-center-x, 0), [(b)])
        },
      ),
    ),
  ),
)
