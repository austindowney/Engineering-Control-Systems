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
          let center-x = 39
          let mass-left = 29
          let mass-right = 49
          let mass-bottom = 34
          let mass-top = 54
          let support-y = 5

          draw.rect(
            (mass-left, mass-bottom),
            (mass-right, mass-top),
            ..mechanics-body-style,
          )
          draw.content(
            (center-x, (mass-bottom + mass-top) / 2),
            [$m$],
          )
          linear-spring(
            (center-x, support-y),
            length: mass-bottom - support-y,
            angle: 90deg,
            coils: 8,
            amplitude: 2.2,
            lead: 4,
          )
          fixed-support(
            (center-x - 13, support-y),
            length: 26,
            hatch-side: -1,
          )
          draw.content((center-x + 5, 20), [$k$])
          displacement-indicator(
            (mass-left - 5, mass-bottom),
            length: 12,
            angle: -90deg,
            label: [$x$],
            label-offset: -2.3,
            extension: 1.7,
          )
        },
      ),
    ),
  ),
)
