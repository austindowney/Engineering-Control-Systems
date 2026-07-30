// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full

#import "/styles/figure.typ": *

#let time = linspace(0, 10, num: 301)
#let decay = time.map(t => calc.exp(-0.28 * t))
#let oscillation = time.map(t => calc.sin(1.65 * t + 0.55))
#let response-stroke = (
  paint: color-secondary,
  thickness: plot-stroke-width,
  cap: "round",
  join: "round",
)

#let decay-panel = book-diagram(
  size: "panel",
  height: 38mm,
  xlabel: [$t$],
  ylabel: [Decay factor],
  xlim: (0, 10),
  ylim: (0, 1.1),
  xaxis: (subticks: none, ticks: (0, 2, 4, 6, 8, 10)),
  yaxis: (subticks: none, ticks: (0, 0.25, 0.5, 0.75, 1)),
  plot(time, decay, stroke: response-stroke),
)

#let oscillation-panel = book-diagram(
  size: "panel",
  height: 38mm,
  xlabel: [$t$],
  ylabel: [Oscillatory factor],
  xlim: (0, 10),
  ylim: (-1.1, 1.1),
  xaxis: (subticks: none, ticks: (0, 2, 4, 6, 8, 10)),
  yaxis: (subticks: none, ticks: (-1, -0.5, 0, 0.5, 1)),
  hlines(
    0,
    stroke: (paint: color-ink, thickness: line-normal),
  ),
  plot(time, oscillation, stroke: response-stroke),
)

#standalone(
  box(
    width: figure-content-width("full"),
    grid(
      columns: (1fr, 10mm, 1fr),
      align: center + horizon,
      scale(90%, reflow: true)[#decay-panel],
      text(size: 18pt)[$times$],
      scale(90%, reflow: true)[#oscillation-panel],
    ),
  ),
)
