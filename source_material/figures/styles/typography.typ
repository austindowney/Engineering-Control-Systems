#import "colors.typ": color-ink

#let figure-text-font = "New Computer Modern"
#let figure-math-font = "New Computer Modern Math"

#let figure-minimum-text-size = 8pt
#let figure-text-size = 9pt
#let figure-small-text-size = figure-minimum-text-size
#let figure-label-size = 9pt
#let figure-axis-text-size = 9pt
#let figure-category-size = 9.5pt
#let figure-title-size = 10pt
#let figure-line-leading = 0.5em

// Enlarge text before scaling a plot so its final printed size still matches
// the semantic typography token.
#let figure-compensated-size(target-size, scale-factor) = (
  target-size / (scale-factor / 100%)
)

#let figure-typography(body) = {
  set text(
    font: figure-text-font,
    size: figure-text-size,
    fill: color-ink,
    // Tight auto-sized pages must include accents, ascenders, and descenders.
    // Using glyph bounds here prevents the page box from clipping math or text.
    top-edge: "bounds",
    bottom-edge: "bounds",
  )
  set par(leading: figure-line-leading)
  show math.equation: set text(font: figure-math-font)
  body
}

#let figure-small(body) = text(size: figure-small-text-size, body)
#let figure-title(body) = text(size: figure-title-size, weight: "semibold", body)
