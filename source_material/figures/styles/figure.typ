#import "@preview/cetz:0.5.2" as cetz
#import "colors.typ": *
#import "typography.typ": *
#import "dimensions.typ": *
#import "diagrams.typ": *
#import "mechanics.typ": *
#import "mechanics-components.typ": *
#import "plots.typ": *

#let cetz-canvas = cetz.canvas
#let draw = cetz.draw

// Standard negative-feedback summing junction. The offsets are proportional
// to the radius so the operator marks retain their placement at custom sizes.
#let summing-node(
  position,
  name: "sum",
  radius: diagram-node-radius,
) = {
  let x = position.at(0)
  let y = position.at(1)
  draw.circle(
    position,
    radius: radius,
    name: name,
    ..diagram-summing-style,
  )
  draw.content(
    (x - 0.4667 * radius, y + 0.0667 * radius),
    text(fill: color-on-light)[$+$],
  )
  draw.content(
    (x, y - 0.5833 * radius),
    text(fill: color-on-light)[$-$],
  )
}

// All standalone figures use a one-page, content-sized canvas. The 2 pt page
// margin is a clipping guard for strokes and arrowheads, not a paper margin.
#let standalone(body) = {
  set page(
    width: auto,
    height: auto,
    margin: figure-page-margin,
    // Keep the standalone PDF page transparent so figures inherit the
    // surrounding LaTeX page, example-box, or review-gallery background.
    fill: none,
  )
  figure-typography(body)
}
