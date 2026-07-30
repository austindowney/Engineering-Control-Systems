#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full

#let time = linspace(0, 3, num: 121)
#let stable-response = time.map(value => calc.exp(-value))
#let marginal-response = time.map(_ => 1)
#let unstable-response = time.map(value => calc.exp(value))

#let response-stroke = (
  paint: color-secondary,
  thickness: plot-stroke-width,
  cap: "round",
  join: "round",
)

#let fixed-y-label(value) = box(
  width: 7mm,
  align(right + horizon)[#value],
)

#let fixed-y-title(body) = box(
  height: 8mm,
  align(center + horizon, move(dy: 6mm, body)),
)

#let response-panel(response, ylim, yticks, equation, show-y: false) = {
  let response-ylabel = fixed-y-title([Response, $x_c/x_0$])
  move(dx: -3mm, scale(70%, reflow: true)[
    #book-diagram(
      size: "panel",
      height: 36mm,
      xlabel: [$t$],
      ylabel: if show-y { response-ylabel } else { hide(response-ylabel) },
      xlim: (0, 3),
      ylim: ylim,
      xaxis: (
        subticks: none,
        ticks: (0, 1, 2, 3),
      ),
      yaxis: (
        subticks: none,
        ticks: yticks.map(value => (value, fixed-y-label(value))),
      ),
      plot(
        time,
        response,
        stroke: response-stroke,
      ),
      place(
        1.75,
        ylim.at(1) * 0.78,
        text(size: 12pt)[#equation],
        align: center,
      ),
    )
  ])
}

#let pole-panel(location) = {
  let pole-ylabel = fixed-y-title([Imaginary part])
  let pole-yticks = (-0.5, 0, 0.5)
  move(dx: -3mm, scale(70%, reflow: true)[
    #book-diagram(
      size: "panel",
      height: 36mm,
      xlabel: [Real part of $p$],
      ylabel: pole-ylabel,
      xlim: (-1.5, 1.5),
      ylim: (-0.75, 0.75),
      xaxis: (
        subticks: none,
        ticks: (-1, 0, 1),
      ),
      yaxis: (
        subticks: none,
        ticks: pole-yticks.map(value => (value, fixed-y-label(value))),
      ),
      vlines(0, stroke: (paint: color-ink, thickness: 0.75pt)),
      hlines(0, stroke: (paint: color-ink, thickness: 0.75pt)),
      scatter(
        (location,),
        (0,),
        mark: "x",
        size: (8pt,),
        color: color-secondary,
        stroke: (paint: color-secondary, thickness: 1.3pt),
      ),
    )
  ])
}

#let enlarged(body) = scale(142%, reflow: true, body)
#let centered-plot(body) = move(dx: -4.5mm, enlarged(body))

#let first-order-stability-row(response, ylim, yticks, equation, pole) = grid(
  columns: (78.794mm, 78.794mm),
  column-gutter: 1mm,
  align: center + top,
  centered-plot(response-panel(
    response,
    ylim,
    yticks,
    equation,
    show-y: true,
  )),
  centered-plot(pole-panel(pole)),
)

#standalone[
  #set text(size: figure-label-size)
  #first-order-stability-row(
    stable-response,
    (0, 1.1),
    (0, 0.5, 1),
    [$x_c/x_0 = e^(-t)$],
    -1,
  )
]
