#import "/styles/figure.typ": *

// figure-pipeline: kind=diagram
// figure-pipeline: width-profile=half
#standalone(
  box(
    width: figure-content-width("half"),
    align(
      center,
      cetz-canvas(
        length: 1mm,
        {
          draw.rect(
            (26, -6),
            (52, 6),
            name: "process",
            ..diagram-block-style,
          )

          draw.line(
            (1, 0),
            "process",
            stroke: diagram-signal-style.stroke,
            mark: (fill: color-secondary, ..arrow-medium),
          )
          draw.line(
            "process",
            (77, 0),
            stroke: diagram-output-style.stroke,
            mark: (fill: color-secondary, ..arrow-medium),
          )

          draw.content((39, 0), [Process])
          draw.content((13.5, 4.2), [Input])
          draw.content((64.5, 4.2), [Output])
        },
      ),
    ),
  ),
)
