#import "/styles/figure.typ": *

// figure-pipeline: kind=diagram
// figure-pipeline: width-profile=full
#standalone(
  box(
    width: figure-content-width("full"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          summing-node(
            (24, 0),
            radius: 3,
            name: "sum",
          )
          draw.rect(
            (50, -6),
            (76, 6),
            name: "controller",
            ..diagram-block-style,
          )
          draw.rect(
            (96, -6),
            (122, 6),
            name: "process",
            ..diagram-block-style,
          )
          draw.circle(
            (129, 0),
            radius: diagram-branch-radius * diagram-unit / 1mm,
            name: "takeoff",
            ..diagram-branch-style,
          )
          draw.rect(
            (63.5, -24),
            (89.5, -12),
            name: "measurement",
            ..diagram-block-style,
          )

          draw.line(
            (0, 0),
            "sum",
            stroke: diagram-signal-style.stroke,
            mark: (fill: color-secondary, ..arrow-medium),
          )
          draw.line(
            "sum",
            "controller",
            stroke: diagram-internal-style.stroke,
            mark: (fill: color-on-light, ..arrow-medium),
          )
          draw.line(
            "controller",
            "process",
            stroke: diagram-internal-style.stroke,
            mark: (fill: color-on-light, ..arrow-medium),
          )
          draw.line(
            "process",
            "takeoff",
            stroke: diagram-output-style.stroke,
          )
          draw.line(
            "takeoff",
            (153, 0),
            stroke: diagram-output-style.stroke,
            mark: (fill: color-secondary, ..arrow-medium),
          )
          draw.line(
            "takeoff",
            (129, -18),
            "measurement",
            stroke: diagram-internal-style.stroke,
            mark: (fill: color-on-light, ..arrow-medium),
          )
          draw.line(
            "measurement",
            (24, -18),
            "sum",
            stroke: diagram-internal-style.stroke,
            mark: (fill: color-on-light, ..arrow-medium),
          )

          draw.content((10.5, 7), align(center)[Input\ vector $bold(r)(t)$])
          draw.content((38.5, 7), align(center)[Error\ vector $bold(e)(t)$])
          draw.content((63, 0), [Controller])
          draw.content((86, 7), align(center)[Control\ vector $bold(u)(t)$])
          draw.content((109, 0), [Process])
          draw.content((141, 7), align(center)[Output\ vector $bold(y)(t)$])
          draw.content((76.5, -18), [Measurement])
        },
      ),
    ),
  ),
)
