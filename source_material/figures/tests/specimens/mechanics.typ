#import "/styles/figure.typ": *

// figure-pipeline: kind=mechanics
#let mass-left = 2.8
#let mass-right = mass-left + mechanics-mass-width
#let mass-bottom = 2 * mechanics-roller-radius
#let mass-top = mass-bottom + mechanics-mass-height
#let mass-center-y = mass-bottom + mechanics-mass-height / 2
#let spring-y = mass-bottom + 2 * mechanics-mass-height / 3
#let damper-y = mass-bottom + mechanics-mass-height / 3
#let reference-x = 1.4
#let dimension-y = mass-top + 0.65

#standalone(
  cetz-canvas(
    length: mechanics-unit,
    {
      // Fixed wall and hatch.
      draw.line((0, 0), (0, 3.6), ..mechanics-support-style)
      for y in range(13).map(index => index * mechanics-support-hatch) {
        draw.line((-0.28, y - 0.18), (0, y), ..mechanics-hatch-style)
      }

      // Spring: fixed wall to mass, in parallel with the damper.
      draw.line(
        (0, spring-y),
        (0.45, spring-y),
        (0.62, spring-y + mechanics-spring-amplitude),
        (0.80, spring-y - mechanics-spring-amplitude),
        (0.98, spring-y + mechanics-spring-amplitude),
        (1.16, spring-y - mechanics-spring-amplitude),
        (1.34, spring-y + mechanics-spring-amplitude),
        (1.52, spring-y - mechanics-spring-amplitude),
        (1.70, spring-y + mechanics-spring-amplitude),
        (1.88, spring-y - mechanics-spring-amplitude),
        (2.06, spring-y + mechanics-spring-amplitude),
        (2.24, spring-y - mechanics-spring-amplitude),
        (2.41, spring-y),
        (mass-left, spring-y),
        ..mechanics-spring-style,
      )

      // Viscous damper: wall-mounted piston rod inside a cylinder whose
      // closed end is connected to the mass.
      draw.line((0, damper-y), (1.35, damper-y), ..mechanics-damper-style)
      draw.line(
        (1.35, damper-y - 0.24),
        (1.35, damper-y + 0.24),
        ..mechanics-damper-style,
      )
      draw.line(
        (1.05, damper-y - 0.28),
        (2.25, damper-y - 0.28),
        (2.25, damper-y + 0.28),
        (1.05, damper-y + 0.28),
        ..mechanics-damper-style,
      )
      draw.line(
        (2.25, damper-y),
        (mass-left, damper-y),
        ..mechanics-damper-style,
      )

      // Hatched ground and explicit rollers make the frictionless translation
      // convention visible rather than relying on an unstated assumption.
      draw.line((2.45, 0), (5.35, 0), ..mechanics-support-style)
      for x in range(10).map(index => 2.55 + index * mechanics-support-hatch) {
        draw.line((x, 0), (x - 0.25, -0.25), ..mechanics-hatch-style)
      }
      for x in (3.12, 3.64, 4.16, 4.68) {
        draw.circle(
          (x, mechanics-roller-radius),
          radius: mechanics-roller-radius,
          ..mechanics-roller-style,
        )
      }

      draw.rect(
        (mass-left, mass-bottom),
        (
          mass-right,
          mass-top,
        ),
        name: "mass",
        ..mechanics-body-style,
      )
      draw.content(((mass-left + mass-right) / 2, mass-center-y), [$m$])

      draw.line("mass", (7.1, mass-center-y), ..mechanics-force-style)
      draw.content((6.25, mass-center-y + 0.35), [$F(t)$])

      // Measure displacement from the equilibrium datum to the current
      // position of the mass's left face.
      draw.line(
        (reference-x, dimension-y - 0.35),
        (reference-x, dimension-y + 0.35),
        ..mechanics-reference-style,
      )
      draw.line(
        (mass-left, mass-top + 0.08),
        (mass-left, dimension-y + 0.35),
        ..mechanics-reference-style,
      )
      draw.line(
        (reference-x, dimension-y),
        (mass-left, dimension-y),
        ..mechanics-displacement-style,
      )
      draw.content(
        (reference-x - 0.12, dimension-y + 0.5),
        anchor: "east",
        [$x = 0$],
        wrap: figure-small,
      )
      draw.content(
        ((reference-x + mass-left) / 2, dimension-y + 0.5),
        [$x(t)$],
      )

      draw.content((1.42, spring-y + 0.45), [$k$])
      draw.content((1.62, damper-y - 0.55), [$c$])
    },
  )
)
