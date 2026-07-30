// figure-pipeline: kind=diagram
// figure-pipeline: width-profile=full

#import "/styles/figure.typ": *

#let amplitude = 18
#let period = 48
#let baseline = 25
#let phase-shift = 4
#let response(x) = baseline + amplitude * calc.cos(
  2 * calc.pi * (x + phase-shift) / period,
)
#let slope-at-zero = (
  -amplitude * 2 * calc.pi / period
    * calc.sin(2 * calc.pi * phase-shift / period)
)

#standalone(
  box(
    width: figure-content-width("full"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          let curve-points = range(-160, 1081).map(i => {
            let x = i / 10
            (x, response(x))
          })

          // Construction lines are drawn first.
          draw.line(
            (-16, 15),
            (-16, baseline),
            stroke: (paint: color-guide, thickness: line-hairline),
          )
          draw.line(
            (0, 15),
            (0, baseline),
            stroke: (paint: color-guide, thickness: line-hairline),
          )
          draw.line(
            (-16, 17),
            (0, 17),
            stroke: (
              paint: color-guide,
              thickness: line-hairline,
              dash: "dashed",
            ),
          )

          for x in (32, 80) {
            draw.line(
              (x, 3),
              (x, baseline + 5),
              stroke: (paint: color-guide, thickness: line-hairline),
            )
          }
          draw.line(
            (32, 7),
            (80, 7),
            stroke: (paint: color-guide, thickness: line-hairline),
          )

          // Axes.
          draw.line(
            (-24, baseline),
            (124, baseline),
            stroke: (paint: color-ink, thickness: line-emphasis),
            mark: (fill: color-ink, ..arrow-medium),
          )
          draw.line(
            (0, 12),
            (0, 52),
            stroke: (paint: color-ink, thickness: line-emphasis),
            mark: (fill: color-ink, ..arrow-medium),
          )
          draw.content((-4.5, 51), text(size: 13pt)[$x$])
          draw.content((118, 29.5), text(size: 13pt)[$t$])

          // Harmonic response.
          draw.line(
            ..curve-points,
            stroke: (
              paint: color-secondary,
              thickness: 1.25pt,
              cap: "round",
              join: "round",
            ),
          )

          // Initial displacement x_0.
          let initial = response(0)
          draw.line(
            (-6, initial),
            (0, initial),
            stroke: (paint: color-ink, thickness: line-normal),
          )
          let initial-mid = (baseline + initial) / 2
          draw.line(
            (-4, initial-mid),
            (-4, initial - 0.2),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-small),
          )
          draw.line(
            (-4, initial-mid),
            (-4, baseline + 0.8),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-small),
          )
          draw.content((-8.7, (baseline + initial) / 2), text(size: 11pt)[$x_0$])

          // Initial-velocity tangent and callout.
          draw.line(
            (-8, initial - 8 * slope-at-zero),
            (9, initial + 9 * slope-at-zero),
            stroke: (
              paint: color-ink,
              thickness: line-hairline,
              dash: "dashed",
            ),
          )
          draw.line(
            (10, 48),
            (0.8, initial + 0.8),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-medium),
          )
          draw.content((10.5, 49), text(size: 11pt)[$v_0$])

          // Amplitude A.
          let amplitude-mid = baseline + amplitude / 2
          draw.line(
            (44, amplitude-mid),
            (44, baseline + amplitude - 0.8),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-small),
          )
          draw.line(
            (44, amplitude-mid),
            (44, baseline + 0.8),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-small),
          )
          draw.content(
            (44, 34.5),
            box(fill: color-background, inset: (x: 0.6mm, y: 0.2mm))[
              #text(size: 12pt)[$A$]
            ],
          )

          // Period and phase annotations.
          draw.content(
            (56, 7),
            box(fill: color-background, inset: (x: 1.2mm, y: 0.2mm))[
              #text(size: 12pt)[$T$]
            ],
          )
          draw.content((-8, 13), text(size: 11pt)[$-phi / omega_n$])

          // Maximum velocity occurs at a zero crossing.
          draw.line(
            (74, 48),
            (56, baseline + 0.7),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-medium),
          )
          draw.content((72, 51), text(size: 12pt)[maximum velocity])

          // Identify the response expression.
          let response-x = 108
          let response-y = response(response-x)
          draw.circle(
            (response-x, response-y),
            radius: 1.25,
            fill: color-secondary,
            stroke: none,
          )
          draw.line(
            (117, 8),
            (response-x + 0.35, response-y - 0.35),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-medium),
          )
          draw.content(
            (117, 4.5),
            text(size: 11pt)[$A sin(omega_n t + phi)$],
          )
        },
      ),
    ),
  ),
)
