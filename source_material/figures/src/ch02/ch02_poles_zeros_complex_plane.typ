#import "/styles/figure.typ": *
#import "@preview/plotsy-3d:0.2.1": plot-3d-surface

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full
#let magnitude(sigma, omega) = {
  let numerator = (
    (calc.pow(sigma + 2, 2) + calc.pow(omega, 2))
    * (calc.pow(sigma - 3, 2) + calc.pow(omega, 2))
  )
  let denominator = (
    calc.pow(calc.pow(sigma, 2) - calc.pow(omega, 2) + 4 * sigma + 20, 2)
    + calc.pow(2 * sigma * omega + 4 * omega, 2)
  )
  // Cap the singular pole peaks so their locations remain visible without
  // compressing the rest of the surface into a nearly flat sheet.
  calc.min(calc.sqrt(numerator / calc.max(denominator, 0.02)), 4)
}

#let surface-color(x, y, z, x-lo, x-hi, y-lo, y-hi, z-lo, z-hi) = {
  let level = (z - z-lo) / (z-hi - z-lo)
  color-secondary.lighten((1 - level) * 68%)
}

#standalone[
  #set text(size: 8pt)
  #grid(
    columns: (94.59mm, 62mm),
    column-gutter: 2mm,
    align: top + center,
    [
      #align(center)[
        #box(width: 100%, height: 47mm)[
          #align(center + bottom)[
            #plot-3d-surface(
          magnitude,
          color-func: surface-color,
          subdivisions: 3,
          subdivision-mode: "increase",
          // With the oblique camera, sigma is strongly foreshortened. These
          // scales compensate so the projected sigma and omega axes appear
          // approximately equal in length while the complete plot still fits.
          scale-dim: (0.095, 0.0311, 0.0934),
          xdomain: (-5, 4),
          ydomain: (-6, 6),
          pad-high: (0, 0, 0),
          pad-low: (0, 0, 0),
          axis-step: (2, 2, 1),
          dot-thickness: 0.035em,
          front-axis-thickness: 0.07em,
          front-axis-dot-scale: (0.04, 0.04),
          rear-axis-dot-scale: (0.05, 0.05),
          rear-axis-text-size: 0.55em,
          axis-label-size: 0.9em,
          axis-text-offset: 0.13,
          axis-labels: ([$sigma$], [$omega$], [$abs(G(s))$]),
          // Equal physical axis lengths plus a conventional isometric view
          // produce a visually balanced coordinate box.
          rotation-matrix: ((-1.6, 0.7, 1.25), (0, -1, 0)),
              xyz-colors: (color-ink, color-ink, color-ink),
            )
          ]
        ]
        #v(1mm)
        (a)
      ]
    ],
    [
      #align(center)[
        #box(width: 100%, height: 47mm)[
          #align(center + bottom)[
            #scale(80%, reflow: true)[
              #book-diagram(
            size: "panel",
            height: 48mm,
            xlabel: [Real part, $sigma$],
            ylabel: [Imaginary part, $omega$],
            xlim: (-5, 4),
            ylim: (-6, 6),
            xaxis: (
              subticks: none,
              ticks: (-4, -2, 0, 2, 4),
            ),
            yaxis: (
              subticks: none,
              ticks: (-6, -4, -2, 0, 2, 4, 6),
            ),
            vlines(0, stroke: (paint: color-ink, thickness: 0.8pt)),
            hlines(0, stroke: (paint: color-ink, thickness: 0.8pt)),
            scatter(
              (-2, 3),
              (0, 0),
              mark: "o",
              size: (7pt, 7pt),
              color: color-background,
              stroke: (paint: color-secondary, thickness: 1.3pt),
            ),
            scatter(
              (-2, -2),
              (4, -4),
              mark: "x",
              size: (8pt, 8pt),
              color: color-secondary,
              stroke: (paint: color-secondary, thickness: 1.3pt),
            ),
            place(-1.65, 4.25, [pole], align: left + bottom),
            place(-1.65, -3.75, [pole], align: left + bottom),
            place(-2.35, 0.45, [zero], align: right + bottom),
                place(2.65, 0.45, [zero], align: right + bottom),
              )
            ]
          ]
        ]
        #v(1mm)
        (b)
      ]
    ],
  )
]
