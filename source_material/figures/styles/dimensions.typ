#let figure-page-margin = 2pt

#let figure-full-width = 160mm
#let figure-half-width = 80mm

#let figure-content-width(profile) = {
  let final-width = if profile == "full" {
    figure-full-width
  } else if profile == "half" {
    figure-half-width
  } else {
    panic("unknown figure width profile: " + repr(profile))
  }
  final-width - 2 * figure-page-margin
}

#let line-hairline = 0.4pt
#let line-normal = 0.75pt
#let line-emphasis = 1.1pt
#let line-heavy = 1.4pt

#let arrow-head-shape = ">>"
#let arrow-small = (
  end: arrow-head-shape,
  length: 5.5pt,
  width: 4pt,
  inset: 1.2pt,
)
#let arrow-medium = (
  end: arrow-head-shape,
  length: 7.5pt,
  width: 5.5pt,
  inset: 1.6pt,
)
#let arrow-large = (
  end: arrow-head-shape,
  length: 9.5pt,
  width: 7pt,
  inset: 2.1pt,
)

#let diagram-unit = 8mm
#let diagram-block-width = 2.5
#let diagram-block-height = 1.1
#let diagram-node-radius = 0.36
#let diagram-branch-radius = 0.075
#let diagram-corner-radius = 0pt

#let mechanics-unit = 8mm
#let mechanics-mass-width = 2.2
#let mechanics-mass-height = 2.2
#let mechanics-roller-radius = 0.18
#let mechanics-spring-amplitude = 0.28
#let mechanics-support-hatch = 0.32

#let plot-full-width = 0% + figure-content-width("full")
#let plot-half-width = 0% + figure-content-width("half")
#let plot-full-height = 80mm
#let plot-half-height = 40mm

#let plot-panel-gutter = 8mm
#let plot-panel-width = (
  0% + (figure-content-width("full") - plot-panel-gutter) / 2
)
#let plot-panel-height = 40mm

#let plot-stroke-width = 1.05pt
#let plot-axis-width = 0.7pt
#let plot-grid-width = 0.35pt
