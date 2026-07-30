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
          draw.rect(
            (38, -6),
            (64, 6),
            name: "actuator",
            ..diagram-block-style,
          )
          draw.rect(
            (96, -6),
            (122, 6),
            name: "process",
            ..diagram-block-style,
          )

          draw.line(
            (2, 0),
            "actuator",
            stroke: diagram-signal-style.stroke,
            mark: (fill: color-secondary, ..arrow-medium),
          )
          draw.line(
            "actuator",
            "process",
            stroke: diagram-internal-style.stroke,
            mark: (fill: color-on-light, ..arrow-medium),
          )
          draw.line(
            "process",
            (156, 0),
            stroke: diagram-output-style.stroke,
            mark: (fill: color-secondary, ..arrow-medium),
          )

          draw.content((51, 0), align(center)[Actuating\ device])
          draw.content((109, 0), [Process])
          draw.content((20, 5.2), [Input])
          draw.content((139, 5.2), [Output])
        },
      ),
    ),
  ),
)
