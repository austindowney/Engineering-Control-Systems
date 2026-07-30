#import "/styles/figure.typ": *

// figure-pipeline: kind=diagram
#standalone(
  cetz-canvas(
    length: diagram-unit,
    {
      summing-node((0, 0), name: "sum")
      draw.rect(
        (1, -diagram-block-height / 2),
        (1 + diagram-block-width, diagram-block-height / 2),
        name: "controller",
        ..diagram-controller-style,
      )
      draw.rect(
        (4.5, -diagram-block-height / 2),
        (4.5 + diagram-block-width, diagram-block-height / 2),
        name: "plant",
        ..diagram-plant-style,
      )
      draw.circle(
        (7.7, 0),
        radius: diagram-branch-radius,
        name: "branch",
        ..diagram-branch-style,
      )

      draw.line((-1.7, 0), "sum", ..diagram-signal-style)
      draw.line("sum", "controller", ..diagram-signal-style)
      draw.line("controller", "plant", ..diagram-signal-style)
      draw.line("plant", "branch", ..diagram-output-style)
      draw.line("branch", (9.3, 0), ..diagram-output-style)
      draw.line(
        "branch",
        (7.7, -2),
        (0, -2),
        "sum",
        ..diagram-feedback-style,
      )

      draw.content((2.25, 0), [Controller])
      draw.content((5.75, 0), [Plant])
      draw.content((-1.15, 0.35), [$r(t)$])
      draw.content((0.5, 0.35), [$e(t)$])
      draw.content((4, 0.35), [$u(t)$])
      draw.content((8.55, 0.35), [$y(t)$])
      draw.content((3.85, -2.3), [$y(t)$])
    },
  )
)
