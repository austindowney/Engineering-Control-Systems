// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full

#import "/styles/figure.typ": *

#let time = linspace(0, 12, num: 401)
#let zeta-omega = 0.28
#let omega-d = 1.7
#let phase = 0.55
#let upper = time.map(t => calc.exp(-zeta-omega * t))
#let lower = upper.map(value => -value)
#let response = time.map(t =>
  calc.exp(-zeta-omega * t) * calc.sin(omega-d * t + phase)
)
#let response-stroke = (
  paint: color-secondary,
  thickness: plot-stroke-width,
  dash: none,
  cap: "round",
  join: "round",
)
#let envelope-stroke = (
  paint: color-guide,
  thickness: line-normal,
  dash: "dashed",
  cap: "butt",
)
#let callout-stroke = (
  paint: color-ink,
  thickness: line-hairline,
  dash: none,
  cap: "butt",
)

#standalone[
  #book-diagram(
    size: "full",
    height: 55mm,
    xlabel: [$t$],
    ylabel: [$x_c(t)$],
    xlim: (0, 12),
    ylim: (-1.15, 1.15),
    xaxis: (
      subticks: none,
      ticks: (0, 2, 4, 6, 8, 10, 12),
    ),
    yaxis: (
      subticks: none,
      ticks: (-1, -0.5, 0, 0.5, 1),
    ),
    hlines(
      0,
      stroke: (paint: color-ink, thickness: line-normal),
    ),
    vlines(
      1,
      3,
      5,
      7,
      9,
      11,
      stroke: plot-grid-stroke,
      z-index: 0,
    ),
    plot(time, upper, stroke: envelope-stroke),
    plot(time, lower, stroke: envelope-stroke),
    plot(time, response, stroke: response-stroke),
    plot(
      (3.65, 3.75),
      (0.72, calc.exp(-zeta-omega * 3.75)),
      stroke: callout-stroke,
    ),
    plot(
      (8.55, 9.2),
      (
        -0.72,
        calc.exp(-zeta-omega * 9.2)
          * calc.sin(omega-d * 9.2 + phase),
      ),
      stroke: callout-stroke,
    ),
    scatter(
      (3.75, 9.2),
      (
        calc.exp(-zeta-omega * 3.75),
        calc.exp(-zeta-omega * 9.2)
          * calc.sin(omega-d * 9.2 + phase),
      ),
      mark: "o",
      size: (3pt, 3pt),
      color: color-ink,
      stroke: none,
    ),
    place(
      3.2,
      0.72,
      box(fill: color-background, inset: (x: 1mm, y: 0.5mm))[
        #text(size: 10pt)[$e^(-zeta omega_n t)$]
      ],
      align: left + bottom,
    ),
    place(
      6.8,
      -0.72,
      box(fill: color-background, inset: (x: 1mm, y: 0.6mm))[
        #text(size: 10pt)[
          $x_c(t) = C e^(-zeta omega_n t) sin(omega_d t + phi)$
        ]
      ],
      align: center + top,
    ),
  )
]
