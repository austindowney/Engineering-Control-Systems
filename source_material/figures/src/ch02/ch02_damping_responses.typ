#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=page
#let time = linspace(0, 10, num: 401)
#let zeta-u = 0.12
#let omega-d = calc.sqrt(1 - zeta-u * zeta-u)
#let underdamped = time.map(t =>
  calc.exp(-zeta-u * t)
    * (calc.cos(omega-d * t) + zeta-u / omega-d * calc.sin(omega-d * t))
)
#let critical = time.map(t => (1 + t) * calc.exp(-t))
#let zeta-o = 3
#let root-term = calc.sqrt(zeta-o * zeta-o - 1)
#let pole-1 = -zeta-o + root-term
#let pole-2 = -zeta-o - root-term
#let coeff-1 = -pole-2 / (pole-1 - pole-2)
#let coeff-2 = pole-1 / (pole-1 - pole-2)
#let overdamped = time.map(t =>
  coeff-1 * calc.exp(pole-1 * t) + coeff-2 * calc.exp(pole-2 * t)
)

#let response-stroke = (
  paint: color-secondary,
  thickness: plot-stroke-width,
  cap: "round",
  join: "round",
)

#let y-tick(value) = box(
  width: 6mm,
  align(right + horizon)[#value],
)

#let damping-panel(response, classification, condition) = {
  grid(
    columns: (1fr,),
    row-gutter: 1.2mm,
    align: center,
    scale(74%, reflow: true)[
      #book-diagram(
        size: "panel",
        height: 42mm,
        xlabel: none,
        ylabel: none,
        xlim: (0, 10),
        ylim: (-0.8, 1.1),
        xaxis: (
          subticks: none,
          ticks: (0, 2, 4, 6, 8, 10),
        ),
        yaxis: (
          subticks: none,
          ticks: (-0.5, 0, 0.5, 1).map(value => (value, y-tick(value))),
        ),
        hlines(
          0,
          stroke: (paint: color-ink, thickness: line-normal),
        ),
        plot(time, response, stroke: response-stroke),
      )
    ],
    move(
      dx: 2mm,
      box(
        width: 50.83mm,
        align(center)[
          #text(weight: "bold", fill: color-secondary)[#classification] \
          #text(size: 8.5pt)[$#condition$]
        ],
      ),
    ),
  )
}

#standalone[
  #set text(size: 8.5pt)
  #pad(x: 2mm)[
    #grid(
      columns: (50.83mm, 50.83mm, 50.83mm),
      column-gutter: 3mm,
      align: top + center,
      damping-panel(
        underdamped,
        [Underdamped],
        [$0 < zeta < 1$],
      ),
      damping-panel(
        critical,
        [Critically damped],
        [$zeta = 1$],
      ),
      damping-panel(
        overdamped,
        [Overdamped],
        [$zeta > 1$],
      ),
    )
  ]
]
