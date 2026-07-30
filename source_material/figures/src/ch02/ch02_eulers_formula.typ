// figure-pipeline: kind=diagram
// figure-pipeline: width-profile=full

#import "/styles/figure.typ": *

#let radius = 27
#let angle = 58deg
#let point-x = radius * calc.cos(angle)
#let point-y = radius * calc.sin(angle)

#standalone(
  box(
    width: figure-content-width("full"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          // A symmetric, invisible extent keeps the circle centered in the
          // full-width figure independently of the equation annotation.
          draw.rect(
            (-74, -31),
            (74, 37),
            fill: none,
            stroke: none,
          )

          // Complex-plane axes.
          draw.line(
            (-31, 0),
            (37, 0),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-small),
          )
          draw.line(
            (0, -31),
            (0, 37),
            stroke: (paint: color-ink, thickness: line-normal),
            mark: (fill: color-ink, ..arrow-small),
          )

          // Unit circle.
          draw.circle(
            (0, 0),
            radius: radius,
            fill: none,
            stroke: (
              paint: color-ink,
              thickness: line-emphasis,
            ),
          )

          // Real and imaginary projections.
          draw.line(
            (0, 0),
            (point-x, 0),
            stroke: (
              paint: color-secondary,
              thickness: line-emphasis,
              cap: "butt",
              join: "miter",
            ),
          )
          draw.line(
            (point-x, 0),
            (point-x, point-y),
            stroke: (
              paint: color-secondary,
              thickness: line-emphasis,
              dash: "dashed",
              cap: "butt",
            ),
          )

          // Unit phasor.
          draw.line(
            (0, 0),
            (point-x, point-y),
            stroke: (
              paint: color-ink,
              thickness: line-emphasis,
              cap: "butt",
            ),
            mark: (fill: color-ink, ..arrow-medium),
          )

          // Phase angle.
          let arc-radius = 7
          let arc-start = (arc-radius, 0)
          draw.arc(
            arc-start,
            start: 0deg,
            stop: angle,
            radius: arc-radius,
            stroke: (
              paint: color-secondary,
              thickness: line-emphasis,
              cap: "butt",
            ),
          )
          draw.content(
            (
              5.2 * calc.cos(angle / 2),
              5.2 * calc.sin(angle / 2),
            ),
            text(size: 11pt)[$psi$],
          )

          // Labels.
          draw.content((-5.5, 2.6), text(size: 9pt)[$(0, 0)$])
          draw.content(
            (point-x / 2, -3.6),
            text(size: 10pt)[$cos(psi)$],
          )
          draw.content(
            (point-x + 5.8, point-y / 2 - 2.2),
            text(size: 10pt)[$sin(psi)$],
          )
          draw.content((-3.5, 34.5), text(size: 10pt)[Im])
          draw.content((-2.1, radius + 2.5), text(size: 10pt)[$j$])
          draw.content((radius + 1.6, -3.2), text(size: 10pt)[$1$])
          draw.content((33.5, -3.2), text(size: 10pt)[Re])

          draw.content(
            (point-x - 1, point-y + 4),
            anchor: "west",
            text(size: 10pt)[
              $e^(j psi) = cos(psi) + j sin(psi)$
            ],
          )
        },
      ),
    ),
  ),
)
