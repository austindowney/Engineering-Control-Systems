#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
// figure-pipeline: width-profile=full
#standalone(
  box(
    width: figure-content-width("full"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          // (a) Horizontal spring--mass system.
          let wall-x = 7
          let axis-y = 25
          let mass-left = 46
          let mass-right = 68
          let mass-bottom = 14
          let mass-top = 36

          fixed-support(
            (wall-x, 38.5),
            length: 27,
            direction: 270,
            hatch-side: -1,
          )
          linear-spring(
            (wall-x, axis-y),
            length: mass-left - wall-x,
            coils: 8,
            amplitude: 2.4,
            lead: 6,
          )
          draw.content(((wall-x + mass-left) / 2, axis-y - 5.2), [$k$])
          draw.rect(
            (mass-left, mass-bottom),
            (mass-right, mass-top),
            ..mechanics-body-style,
          )
          draw.content(
            ((mass-left + mass-right) / 2, (mass-bottom + mass-top) / 2),
            [$m$],
          )

          for x in (48.2, 52.6, 57, 61.4, 65.8) {
            draw.circle(
              (x, mass-bottom - 1.45),
              radius: 1.15,
              ..mechanics-roller-style,
            )
          }
          fixed-support(
            (43, mass-bottom - 2.85),
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
          draw.content((59, 49), [position at rest])
          draw.line(
            (60.5, 47.8),
            (67.7, 42),
            stroke: (
              paint: color-guide,
              thickness: line-hairline,
              cap: "butt",
            ),
            mark: (fill: color-guide, ..arrow-small),
          )
          draw.content(
            (57, 6),
            figure-small[frictionless surface],
          )
          draw.content((41.5, 0), [(a)])

          // (b) Free-body diagram of the mass.
          let body-left = 116
          let body-right = 138
          let body-bottom = 14
          let body-top = 36
          let body-center-x = (body-left + body-right) / 2
          let body-center-y = (body-bottom + body-top) / 2
          let fbd-force-style = mechanics-force-style

          draw.rect(
            (body-left, body-bottom),
            (body-right, body-top),
            ..mechanics-body-style,
          )
          draw.content((body-center-x, body-center-y), [$m$])

          draw.line(
            (body-left, body-center-y),
            (94, body-center-y),
            ..fbd-force-style,
          )
          draw.content((101, body-center-y + 3), [$F_s = k x$])

          draw.line(
            (body-center-x, body-bottom),
            (body-center-x, 5),
            ..fbd-force-style,
          )
          draw.content((body-center-x + 4, 8), [$m g$])

          draw.line(
            (body-center-x, body-top),
            (body-center-x, 45),
            ..fbd-force-style,
          )
          draw.content((body-center-x + 3, 43), [$N$])

          draw.content((body-center-x, 0), [(b)])
        },
      ),
    ),
  ),
)
