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
          // (a) Spring--mass schematic.
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

          // Rollers and ground.
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

          // Restrained leader lines keep the annotation hierarchy secondary.
          draw.content(
            ((wall-x + mass-left) / 2, 47),
            align(center)[Spring stores #linebreak() potential energy],
          )
          draw.line(
            ((wall-x + mass-left) / 2, 41),
            ((wall-x + mass-left) / 2, 28.5),
            stroke: (
              paint: color-guide,
              thickness: line-hairline,
              cap: "butt",
            ),
            mark: (fill: color-guide, ..arrow-small),
          )
          draw.content(
            (57, 47),
            align(center)[Moving mass stores #linebreak() kinetic energy],
          )
          draw.line(
            (57, 41),
            (57, 37),
            stroke: (
              paint: color-guide,
              thickness: line-hairline,
              cap: "butt",
            ),
            mark: (fill: color-guide, ..arrow-small),
          )
          draw.content((41.5, 2.2), [(a)])

          // (b) Equivalent point-mass force representation.
          let point-x = 122
          let point-y = 23
          let arrow-span = 26
          draw.line(
            (point-x, point-y),
            (point-x - arrow-span, point-y),
            ..mechanics-force-style,
          )
          draw.line(
            (point-x, point-y),
            (point-x + arrow-span, point-y),
            ..mechanics-force-style,
          )
          draw.circle(
            (point-x, point-y),
            radius: 2.1,
            fill: color-on-light,
            stroke: none,
          )
          draw.content(
            (point-x - arrow-span - 4.2, point-y),
            [$F$],
          )
          draw.content(
            (point-x + arrow-span + 5.5, point-y),
            [$m a$],
          )
          draw.content(
            (point-x, 31.5),
            align(center)[Equivalent point-mass #linebreak() representation],
          )
          draw.content((point-x, 2.2), [(b)])
        },
      ),
    ),
  ),
)
