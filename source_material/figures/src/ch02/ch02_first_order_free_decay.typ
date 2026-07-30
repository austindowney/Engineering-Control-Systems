#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=half
#let time = linspace(0, 5, num: 151)
#let response = time.map(value => calc.exp(-value))
#let decay-stroke = (
  paint: color-secondary,
  thickness: plot-stroke-width,
  cap: "round",
  join: "round",
)
#let guide-stroke = (
  paint: color-guide,
  thickness: line-hairline,
  dash: "dashed",
  cap: "butt",
)

#standalone[
  #book-diagram(
    size: "half",
    height: 42mm,
    xlabel: [Normalized time, $t/T$],
    ylabel: [Normalized response, $x_c/x_0$],
    xlim: (0, 5),
    ylim: (0, 1.08),
    xaxis: (
      subticks: none,
      ticks: (0, 1, 2, 3, 4, 5),
    ),
    yaxis: (
      subticks: none,
      ticks: (0, 0.2, 0.4, 0.6, 0.8, 1),
    ),
    plot(
      time,
      response,
      stroke: decay-stroke,
    ),
    vlines(
      1,
      min: 0,
      max: calc.exp(-1),
      stroke: guide-stroke,
    ),
    hlines(
      calc.exp(-1),
      min: 0,
      max: 1,
      stroke: guide-stroke,
    ),
    scatter(
      (1,),
      (calc.exp(-1),),
      mark: "o",
      size: (6pt,),
      color: color-background,
      stroke: (paint: color-secondary, thickness: 1.2pt),
    ),
    place(
      0.12,
      0.97,
      [$x_c(0)=x_0$],
      align: left + top,
    ),
    place(
      1.12,
      calc.exp(-1) + 0.05,
      [$x_c(T)/x_0=e^{-1} approx 0.368$],
      align: left + bottom,
    ),
  )
]
