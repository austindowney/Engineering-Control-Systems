#import "colors.typ": *
#import "dimensions.typ": *

// Raw-CeTZ style dictionaries and dimensions only. Figure sources remain in
// control of placement and routing and use CeTZ's native named anchors.

#let diagram-block-style = (
  fill: color-surface-strong,
  stroke: (
    paint: color-on-light,
    thickness: line-normal,
    cap: "square",
    join: "miter",
  ),
  radius: diagram-corner-radius,
)

#let diagram-controller-style = (
  fill: color-primary.lighten(88%),
  stroke: (
    paint: color-primary,
    thickness: line-emphasis,
    cap: "square",
    join: "miter",
  ),
  radius: diagram-corner-radius,
)

#let diagram-plant-style = (
  fill: color-secondary.lighten(89%),
  stroke: (
    paint: color-secondary,
    thickness: line-emphasis,
    cap: "square",
    join: "miter",
  ),
  radius: diagram-corner-radius,
)

#let diagram-summing-style = (
  fill: color-background,
  stroke: (
    paint: color-on-light,
    thickness: line-normal,
    cap: "round",
    join: "round",
  ),
)

#let diagram-branch-style = (
  fill: color-ink,
  stroke: none,
)

#let diagram-signal-style = (
  stroke: (
    paint: color-secondary,
    thickness: line-emphasis,
    cap: "butt",
    join: "miter",
  ),
  mark: (
    fill: color-secondary,
    ..arrow-small,
  ),
)

#let diagram-output-style = (
  stroke: (
    paint: color-output,
    thickness: line-emphasis,
    cap: "butt",
    join: "miter",
  ),
  mark: (
    fill: color-output,
    ..arrow-small,
  ),
)

#let diagram-internal-style = (
  stroke: (
    paint: color-on-light,
    thickness: line-emphasis,
    cap: "butt",
    join: "miter",
  ),
  mark: (
    fill: color-on-light,
    ..arrow-small,
  ),
)

#let diagram-feedback-style = (
  stroke: (
    paint: color-feedback,
    thickness: line-emphasis,
    cap: "butt",
    join: "miter",
  ),
  mark: (
    fill: color-feedback,
    ..arrow-small,
  ),
)

#let diagram-bidirectional-style = (
  stroke: (
    paint: color-primary,
    thickness: line-normal,
    cap: "butt",
    join: "miter",
  ),
  mark: (
    start: arrow-head-shape,
    fill: color-primary,
    ..arrow-small,
  ),
)

#let diagram-guide-style = (
  stroke: (
    paint: color-guide,
    thickness: line-hairline,
    dash: "dashed",
    cap: "round",
  ),
)
