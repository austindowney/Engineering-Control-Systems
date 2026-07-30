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
          let wall-x = 4
          let axis-y = 21
          let mass-left = 42
          let mass-right = 62
          let mass-bottom = 11
          let mass-top = 31

          fixed-support(
            (wall-x, 33),
            length: 24,
            direction: 270,
            hatch-side: -1,
          )
          linear-spring(
            (wall-x, axis-y),
            length: mass-left - wall-x,
            coils: 8,
            amplitude: 2.2,
            lead: 6,
          )
          draw.content(((wall-x + mass-left) / 2, axis-y - 5), [$k$])
          draw.rect(
            (mass-left, mass-bottom),
            (mass-right, mass-top),
            ..mechanics-body-style,
          )
          draw.content(
            ((mass-left + mass-right) / 2, (mass-bottom + mass-top) / 2),
            [$m$],
          )
          for x in (44, 48, 52, 56, 60) {
            draw.circle(
              (x, mass-bottom - 1.4),
              radius: 1.1,
              ..mechanics-roller-style,
            )
          }
          fixed-support(
            (39, mass-bottom - 2.75),
            length: 26,
            hatch-side: -1,
          )
          displacement-indicator(
            (mass-right, mass-top + 3.5),
            length: 11,
            label: [$x$],
            label-offset: 2.2,
            extension: 1.6,
          )
        },
      ),
    ),
  ),
)
