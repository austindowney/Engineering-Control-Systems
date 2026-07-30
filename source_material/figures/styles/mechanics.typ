#import "colors.typ": *
#import "dimensions.typ": *

// Raw-CeTZ style dictionaries and dimensions only. These styles deliberately
// do not provide automatic component placement, routing, or constructors.

#let mechanics-body-style = (
  fill: color-surface-strong,
  stroke: (
    paint: color-mechanical,
    thickness: line-emphasis,
    cap: "square",
    join: "miter",
  ),
  radius: 0pt,
)

#let mechanics-line-style = (
  stroke: (
    paint: color-mechanical,
    thickness: line-normal,
    cap: "round",
    join: "round",
  ),
)

#let mechanics-spring-style = (
  stroke: (
    paint: color-mechanical,
    thickness: line-emphasis,
    cap: "round",
    join: "round",
  ),
)

#let mechanics-damper-style = (
  stroke: (
    paint: color-mechanical,
    thickness: line-emphasis,
    cap: "round",
    join: "round",
  ),
)

#let mechanics-roller-style = (
  fill: color-background,
  stroke: (
    paint: color-mechanical,
    thickness: line-normal,
    cap: "round",
    join: "round",
  ),
)

#let mechanics-support-style = (
  stroke: (
    paint: color-on-light,
    thickness: line-heavy,
    cap: "square",
    join: "round",
  ),
)

#let mechanics-hatch-style = (
  stroke: (
    paint: color-guide,
    thickness: line-hairline,
    cap: "round",
  ),
)

#let mechanics-reference-style = (
  stroke: (
    paint: color-guide,
    thickness: line-hairline,
    dash: "dashed",
    cap: "round",
  ),
)

#let mechanics-force-style = (
  stroke: (
    paint: color-force,
    thickness: line-emphasis,
    cap: "butt",
    join: "miter",
  ),
  mark: (
    fill: color-force,
    ..arrow-small,
  ),
)

#let mechanics-displacement-style = (
  stroke: (
    paint: color-displacement,
    thickness: line-normal,
    cap: "butt",
    join: "miter",
  ),
  mark: (
    fill: color-displacement,
    ..arrow-small,
  ),
)
