#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
// figure-pipeline: width-profile=full
#let angular-cue(origin, radius, start, stop, label) = {
  let start-point = (
    origin.at(0) + radius * calc.cos(start),
    origin.at(1) + radius * calc.sin(start),
  )
  draw.arc(
    start-point,
    start: start,
    stop: stop,
    radius: radius,
    stroke: (
      paint: color-displacement,
      thickness: line-normal,
      cap: "butt",
      join: "miter",
    ),
    mark: (fill: color-displacement, ..arrow-medium),
  )
  let middle = (start + stop) / 2
  draw.content(
    (
      origin.at(0) + (radius + 2.2) * calc.cos(middle),
      origin.at(1) + (radius + 2.2) * calc.sin(middle),
    ),
    text(fill: color-on-light)[#label],
  )
}

#standalone(
  box(
    width: figure-content-width("full"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          // (a) Vertical spring--mass oscillator.
          let ax = 19
          draw.rect(
            (ax - 9, 31),
            (ax + 9, 47),
            ..mechanics-body-style,
          )
          draw.content((ax, 39), [$m$])
          linear-spring(
            (ax, 31),
            length: 25,
            angle: -90deg,
            coils: 7,
            amplitude: 2.2,
            lead: 4,
          )
          fixed-support(
            (ax - 12, 6),
            length: 24,
          )
          displacement-indicator(
            (ax - 12, 31),
            length: 8,
            angle: -90deg,
            label: [$x$],
            label-offset: -2,
            extension: 1.6,
          )
          draw.content((ax + 5.2, 19), [$k$])
          draw.content((ax, 0.4), [(a)])

          // (b) Pendulum with a horizontal restoring spring.
          let bx = 80
          let pivot-y = 47
          let bob-y = 16
          let pendulum-length = pivot-y - bob-y
          let displaced-angle = -57deg
          let displaced-bob = (
            bx + pendulum-length * calc.cos(displaced-angle),
            pivot-y + pendulum-length * calc.sin(displaced-angle),
          )
          fixed-support(
            (bx - 27, 47),
            length: 51,
            hatch-side: 1,
          )
          draw.line((bx, pivot-y), (bx, bob-y), ..mechanics-line-style)
          draw.circle(
            (bx, bob-y),
            radius: 4.7,
            fill: color-surface-strong,
            stroke: (
              paint: color-mechanical,
              thickness: line-emphasis,
            ),
          )
          draw.content((bx, bob-y), [$m$])
          draw.content((bx - 2.7, (pivot-y + bob-y) / 2), [$l$])

          // Spring from the fixed wall to the equilibrium position.
          fixed-support(
            (bx - 27, 6),
            length: 25,
            direction: 90,
            hatch-side: 1,
          )
          linear-spring(
            (bx - 27, bob-y),
            length: 22.3,
            coils: 6,
            amplitude: 2.1,
            lead: 4,
          )
          draw.content((bx - 15.5, bob-y + 5), [$k$])

          // Displaced configuration and angular coordinate.
          draw.circle(
            displaced-bob,
            radius: 4.7,
            name: "displaced-bob",
            fill: none,
            stroke: mechanics-reference-style.stroke,
          )
          draw.line(
            (bx, pivot-y),
            "displaced-bob",
            ..mechanics-reference-style,
          )
          // Draw the pivot last so both pendulum rods terminate beneath it.
          draw.circle(
            (bx, pivot-y),
            radius: 1.05,
            fill: color-mechanical,
            stroke: none,
          )
          angular-cue(
            (bx, pivot-y),
            18,
            -90deg,
            -57deg,
            [$theta$],
          )
          draw.content((bx, 0.4), [(b)])

          // (c) Torsional spring--inertia oscillator.
          let cx = 137
          torsional-suspension(
            (cx, 47),
            length: 2.7cm,
            support-width: 2.6cm,
            coils: 8,
            body-width: 18,
            body-height: 14,
          )
          draw.content((cx, 0.4), [(c)])
        },
      ),
    ),
  ),
)
