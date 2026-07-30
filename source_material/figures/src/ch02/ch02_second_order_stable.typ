#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full

#let time = linspace(0, 8, num: 321)
#let stable-response = time.map(t =>
  calc.exp(-0.28 * t) * calc.sin(2.8 * t)
)
#let marginal-response = time.map(t => calc.sin(2.8 * t))
#let unstable-response = time.map(t =>
  calc.exp(0.18 * t) * calc.sin(2.8 * t)
)
#let stable-envelope = time.map(t => calc.exp(-0.28 * t))
#let marginal-envelope = time.map(_ => 1)
#let unstable-envelope = time.map(t => calc.exp(0.18 * t))

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
  thickness: line-normal,
  dash: none,
  cap: "butt",
)

#let fixed-y-label(value) = box(
  width: 7mm,
  align(right + horizon)[#value],
)

#let fixed-y-title(body) = box(
  height: 8mm,
  align(center + horizon, move(dy: 6mm, body)),
)

#let response-panel(
  response,
  envelope,
  ylim,
  yticks,
  equation,
  equation-x,
  equation-y,
  callout-start: none,
  callout-end: none,
  show-y: false,
) = {
  let response-ylabel = fixed-y-title([Normalized response])
  move(dx: -3mm, scale(70%, reflow: true)[
    #book-diagram(
      size: "panel",
      height: 36mm,
      xlabel: [$t$],
      ylabel: if show-y { response-ylabel } else { hide(response-ylabel) },
      xlim: (0, 8),
      ylim: ylim,
      xaxis: (
        subticks: none,
        ticks: (0, 2, 4, 6, 8),
      ),
      yaxis: (
        subticks: none,
        ticks: yticks.map(value => (value, fixed-y-label(value))),
      ),
      hlines(
        0,
        stroke: (paint: color-ink, thickness: line-normal),
      ),
      plot(
        time,
        response,
        stroke: response-stroke,
      ),
      plot(
        time,
        envelope,
        stroke: envelope-stroke,
      ),
      plot(
        time,
        envelope.map(value => -value),
        stroke: envelope-stroke,
      ),
      if callout-end != none {
        plot(
          (callout-start.at(0), callout-end.at(0)),
          (callout-start.at(1), callout-end.at(1)),
          stroke: callout-stroke,
        )
      },
      if callout-end != none {
        scatter(
          (callout-end.at(0),),
          (callout-end.at(1),),
          mark: "o",
          size: (3pt,),
          color: color-ink,
          stroke: none,
        )
      },
      place(
        equation-x,
        equation-y,
        box(fill: color-background, inset: (x: 0.8mm, y: 0.4mm))[
          #text(size: 9pt)[#equation]
        ],
        align: center,
      ),
    )
  ])
}

#let pole-panel(real-part) = {
  let pole-ylabel = fixed-y-title([Imaginary part])
  let pole-yticks = (-2, -1, 0, 1, 2)
  move(dx: -3mm, scale(70%, reflow: true)[
    #book-diagram(
      size: "panel",
      height: 36mm,
      xlabel: [Real part of $p$],
      ylabel: pole-ylabel,
      xlim: (-1.25, 1.25),
      ylim: (-2.1, 2.1),
      xaxis: (
        subticks: none,
        ticks: (-1, 0, 1),
      ),
      yaxis: (
        subticks: none,
        ticks: pole-yticks.map(value => (value, fixed-y-label(value))),
      ),
      vlines(
        -0.5,
        0.5,
        stroke: plot-grid-stroke,
        z-index: 0,
      ),
      vlines(0, stroke: (paint: color-ink, thickness: line-normal)),
      hlines(0, stroke: (paint: color-ink, thickness: line-normal)),
      scatter(
        (real-part, real-part),
        (-1.2, 1.2),
        mark: "x",
        size: (8pt, 8pt),
        color: color-secondary,
        stroke: (paint: color-secondary, thickness: 1.3pt),
      ),
    )
  ])
}

#let enlarged(body) = scale(142%, reflow: true, body)
#let centered-plot(body) = move(dx: -4.5mm, enlarged(body))

#let second-order-stability-row(
  response,
  envelope,
  ylim,
  yticks,
  equation,
  equation-x,
  equation-y,
  pole,
  callout-start: none,
  callout-end: none,
) = grid(
  columns: (78.794mm, 78.794mm),
  column-gutter: 1mm,
  align: center + top,
  centered-plot(response-panel(
    response,
    envelope,
    ylim,
    yticks,
    equation,
    equation-x,
    equation-y,
    callout-start: callout-start,
    callout-end: callout-end,
    show-y: true,
  )),
  centered-plot(pole-panel(pole)),
)

#standalone[
  #set text(size: figure-label-size)
  #second-order-stability-row(
    stable-response,
    stable-envelope,
    (-1.1, 1.1),
    (-1, -0.5, 0, 0.5, 1),
    [$e^(-zeta omega_n t) sin(omega_d t + phi)$],
    3.25,
    0.87,
    -0.6,
    callout-start: (4.25, 0.68),
    callout-end: (
      4.675,
      calc.exp(-0.28 * 4.675) * calc.sin(2.8 * 4.675),
    ),
  )
]
