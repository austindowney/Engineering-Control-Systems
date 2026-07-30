#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
// figure-pipeline: width-profile=full
#let plate-stroke = (
  paint: color-mechanical,
  thickness: line-heavy,
  cap: "square",
)

#let leader-stroke = (
  paint: color-guide,
  thickness: line-hairline,
  cap: "butt",
)

#standalone(
  box(
    width: figure-content-width("full"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          // (a) Parallel spring--damper system terminated at a massless,
          // rigid connector plate.
          let wall-x = 8
          let plate-x = 69
          let spring-y = 33
          let damper-y = 18
          let plate-bottom = 13
          let plate-top = 38

          fixed-support(
            (wall-x, 40),
            length: 29,
            direction: 270,
            hatch-side: -1,
          )
          linear-spring(
            (wall-x, spring-y),
            length: plate-x - wall-x,
            coils: 12,
            amplitude: 2.3,
            lead: 7,
          )
          viscous-damper(
            (wall-x, damper-y),
            length: plate-x - wall-x,
          )
          draw.content(
            (38.5, spring-y + 5.5),
            [spring ($k$)],
          )
          draw.content(
            (38.5, damper-y + 6),
            [viscous damper ($c$)],
          )

          draw.line(
            (plate-x, plate-bottom),
            (plate-x, plate-top),
            stroke: plate-stroke,
          )

          draw.line(
            (plate-x, 25.5),
            (88, 25.5),
            ..mechanics-force-style,
          )
          draw.content((80, 30), [$F(t)$])

          displacement-indicator(
            (plate-x, 43),
            length: 15,
            label: [$x(t)$],
            label-offset: 2.4,
            extension: 1.8,
          )

          draw.content(
            (53, 7),
            figure-small[massless rigid connector],
          )
          draw.line(
            (58, 9),
            (plate-x - 1.5, plate-bottom + 2),
            stroke: leader-stroke,
            mark: (fill: color-guide, ..arrow-small),
          )
          draw.content((48, 0), [(a)])

          // (b) Free-body diagram of that same connector. A plate is retained
          // instead of replacing it with a solid point that resembles a mass.
          let fbd-x = 126
          let fbd-bottom = 13
          let fbd-top = 38
          draw.line(
            (fbd-x, fbd-bottom),
            (fbd-x, fbd-top),
            stroke: plate-stroke,
          )

          draw.line(
            (fbd-x, 32),
            (105, 32),
            ..mechanics-force-style,
          )
          draw.content((112, 36), [$F_k = k x$])

          draw.line(
            (fbd-x, 19),
            (105, 19),
            ..mechanics-force-style,
          )
          draw.content((112, 23), [$F_c = c dot(x)$])

          draw.line(
            (fbd-x, 25.5),
            (148, 25.5),
            ..mechanics-force-style,
          )
          draw.content((141, 30), [$F(t)$])

          draw.content(
            (fbd-x, 7),
            figure-small[massless connector, $m = 0$],
          )
          draw.line(
            (fbd-x, 9),
            (fbd-x, fbd-bottom - 1),
            stroke: leader-stroke,
          )
          draw.content((126, 0), [(b)])
        },
      ),
    ),
  ),
)
