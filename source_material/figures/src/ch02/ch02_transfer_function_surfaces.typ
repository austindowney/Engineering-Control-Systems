#import "/styles/figure.typ": *
#import "@preview/plotsy-3d:0.2.1": plot-3d-surface

// figure-pipeline: kind=surface
// figure-pipeline: width-profile=full
#let safe-root(value) = calc.sqrt(calc.max(value, 0.0025))

#let magnitude-zero(sigma, omega) = {
  safe-root(calc.pow(sigma - 1, 2) + calc.pow(omega, 2))
}

#let magnitude-pole(sigma, omega) = {
  calc.min(1 / safe-root(calc.pow(sigma - 1, 2) + calc.pow(omega, 2)), 5)
}

#let magnitude-pole-zero(sigma, omega) = {
  let numerator = 20 * safe-root(
    calc.pow(1 - sigma, 2) + calc.pow(omega, 2)
  )
  let denominator = safe-root(
    calc.pow(sigma + 2, 2) + calc.pow(omega, 2)
  )
  calc.min(numerator / denominator, 60)
}

#let surface-color(x, y, z, x-lo, x-hi, y-lo, y-hi, z-lo, z-hi) = {
  let level = (z - z-lo) / (z-hi - z-lo)
  color-secondary.lighten((1 - level) * 68%)
}

#let surface-panel(equation, function, z-scale, label) = [
  #align(center)[
    #equation
    #box(width: 100%, height: 34mm)[
      #align(center + bottom)[
        #plot-3d-surface(
          function,
          color-func: surface-color,
          subdivisions: 3,
          subdivision-mode: "increase",
          scale-dim: (0.047, 0.021, z-scale),
          xdomain: (-4, 4),
          ydomain: (-4, 4),
          pad-high: (0, 0, 0),
          pad-low: (0, 0, 0),
          axis-step: (2, 2, if z-scale < 0.01 { 20 } else { 1 }),
          dot-thickness: 0.03em,
          front-axis-thickness: 0.065em,
          front-axis-dot-scale: (0.04, 0.04),
          rear-axis-dot-scale: (0.05, 0.05),
          rear-axis-text-size: 0.5em,
          axis-label-size: 0.82em,
          axis-text-offset: 0.13,
          axis-labels: ([$sigma$], [$omega$], [$abs(H(s))$]),
          rotation-matrix: ((-1.6, 0.7, 1.25), (0, -1, 0)),
          xyz-colors: (color-ink, color-ink, color-ink),
        )
      ]
    ]
    #v(-3mm)
    #label
  ]
]

#standalone[
  #set text(size: 8pt)
  #grid(
    columns: (51.53mm, 51.53mm, 51.53mm),
    column-gutter: 2mm,
    align: top + center,
    surface-panel(
      [$H(s) = s - 1$],
      magnitude-zero,
      0.0465,
      [(a)],
    ),
    surface-panel(
      [$H(s) = 1/(s - 1)$],
      magnitude-pole,
      0.065,
      [(b)],
    ),
    surface-panel(
      [$H(s) = (-20s + 20)/(s + 2)$],
      magnitude-pole-zero,
      0.0054,
      [(c)],
    ),
  )
]
