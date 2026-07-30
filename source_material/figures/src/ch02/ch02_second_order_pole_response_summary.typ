#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=page
#let time = linspace(0, 6, num: 241)
#let pole-scale = 58%
#let response-scale = 84%
#let under-zeta = 0.25
#let under-wd = calc.sqrt(1 - under-zeta * under-zeta)
#let over-zeta = 2
#let over-root = calc.sqrt(over-zeta * over-zeta - 1)
#let over-p1 = -over-zeta + over-root
#let over-p2 = -over-zeta - over-root
#let over-c1 = -over-p2 / (over-p1 - over-p2)
#let over-c2 = over-p1 / (over-p1 - over-p2)

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

#let axis-label(body, size: figure-axis-text-size) = box(
  fill: color-background,
  inset: 0.3mm,
  text(size: size)[#body],
)

#let pole-panel(xs, ys, multiplicity: none) = {
  scale(pole-scale, reflow: true)[
    #book-diagram(
      size: "panel",
      height: 48mm,
      xlim: (-2, 2),
      ylim: (-1.5, 1.5),
      xaxis: (ticks: none, subticks: none),
      yaxis: (ticks: none, subticks: none),
      vlines(0, stroke: (paint: color-ink, thickness: line-normal)),
      hlines(0, stroke: (paint: color-ink, thickness: line-normal)),
      scatter(
        xs,
        ys,
        mark: "x",
        size: xs.map(_ => 8pt),
        color: color-secondary,
        stroke: (paint: color-secondary, thickness: 1.3pt),
      ),
      place(
        1.94,
        0.035,
        axis-label(
          [Re],
          size: figure-compensated-size(figure-axis-text-size, pole-scale),
        ),
        align: right,
      ),
      place(
        0.195,
        1.27,
        axis-label(
          [Im],
          size: figure-compensated-size(figure-axis-text-size, pole-scale),
        ),
        align: right,
      ),
      if multiplicity != none {
        place(
          multiplicity.at(0),
          multiplicity.at(1),
          text(
            size: figure-compensated-size(figure-axis-text-size, pole-scale),
            weight: "bold",
            fill: color-secondary,
          )[$times 2$],
          align: left,
        )
      },
    )
  ]
}

#let response-panel(values, ylim, yticks, envelope: none) = {
  scale(response-scale, reflow: true)[
    #book-diagram(
      size: "panel",
      height: 33mm,
      xlim: (0, 6),
      ylim: ylim,
      xaxis: (
        ticks: none,
        subticks: none,
      ),
      yaxis: (
        ticks: none,
        subticks: none,
      ),
      hlines(0, stroke: (paint: color-ink, thickness: line-normal)),
      if envelope != none {
        plot(time, envelope, stroke: envelope-stroke)
      },
      if envelope != none {
        plot(time, envelope.map(value => -value), stroke: envelope-stroke)
      },
      plot(time, values, stroke: response-stroke),
      place(
        5.85,
        ylim.at(0) + 0.09 * (ylim.at(1) - ylim.at(0)),
        axis-label(
          [$t$],
          size: figure-compensated-size(
            figure-axis-text-size,
            response-scale,
          ),
        ),
        align: right,
      ),
    )
  ]
}

#let case-label(title, condition, behavior) = box(
  width: 35mm,
  inset: (left: 1.5mm, right: 1mm),
  align(left + horizon)[
    #text(size: figure-title-size, weight: "bold", fill: color-secondary)[#title] \
    #text(size: figure-label-size)[#condition] \
    #text(size: figure-label-size, fill: color-muted)[#behavior]
  ],
)

#let group-label(body, rows, fill) = grid.cell(
  rowspan: rows,
  fill: fill,
  inset: 0pt,
  stroke: (right: (paint: color-secondary, thickness: 0.7pt)),
  align: center + horizon,
  rotate(
    -90deg,
    box(
      width: 30mm,
      align(center)[
        #text(size: figure-category-size, weight: "bold", fill: color-secondary)[#body]
      ],
    ),
  ),
)

#let row(label, poles, response) = (
  grid.cell(inset: 0pt, align: horizon, label),
  grid.cell(inset: 0pt, align: center + horizon, poles),
  grid.cell(inset: 0pt, align: center + horizon, response),
)

#let overdamped = time.map(t =>
  over-c1 * calc.exp(over-p1 * t) + over-c2 * calc.exp(over-p2 * t)
)
#let critical = time.map(t => (1 + t) * calc.exp(-t))
#let underdamped = time.map(t => calc.exp(-0.25 * t) * calc.cos(4.4 * t))
#let stable-envelope = time.map(t => calc.exp(-0.25 * t))
#let marginal = time.map(t => calc.cos(4.4 * t))
#let marginal-envelope = time.map(_ => 1)
#let unstable-osc = time.map(t => calc.exp(0.22 * t) * calc.cos(4.4 * t))
#let unstable-envelope = time.map(t => calc.exp(0.22 * t))
#let unstable-repeat = time.map(t => (1 + 0.4 * t) * calc.exp(0.22 * t))
#let unstable-distinct = time.map(t =>
  0.7 * calc.exp(0.18 * t) + 0.3 * calc.exp(0.45 * t)
)

#standalone[
  #set text(size: figure-label-size)
  #pad(x: 1.5mm, y: 1mm)[
    #grid(
      columns: (6mm, 35mm, 50mm, 67mm),
      column-gutter: 0.5mm,
      row-gutter: 1mm,
      align: center + horizon,
      grid.cell(
        fill: color-surface-strong,
        inset: 0pt,
        [],
      ),
      grid.cell(
        fill: color-surface-strong,
        inset: (x: 1.5mm, y: 1.2mm),
        align: left,
        text(weight: "bold")[Pole configuration],
      ),
      grid.cell(
        fill: color-surface-strong,
        inset: (x: 1.5mm, y: 1.2mm),
        text(weight: "bold")[Complex plane],
      ),
      grid.cell(
        fill: color-surface-strong,
        inset: (x: 1.5mm, y: 1.2mm),
        text(weight: "bold")[Free response],
      ),

      group-label([Stable], 3, color-secondary.lighten(92%)),
      ..row(
        case-label([Overdamped], [$p_1 < p_2 < 0$], [Monotonic decay]),
        pole-panel((-1.35, -0.45), (0, 0)),
        response-panel(overdamped, (-0.1, 1.08), ((0, [0]), (1, [1]))),
      ),
      ..row(
        case-label([Critically damped], [$p_1 = p_2 < 0$], [Fastest nonoscillatory decay]),
        pole-panel((-0.85,), (0,), multiplicity: (-0.68, 0.23)),
        response-panel(critical, (-0.1, 1.08), ((0, [0]), (1, [1]))),
      ),
      ..row(
        case-label([Underdamped], [$p_(1,2) = sigma plus.minus i omega$, $sigma < 0$], [Decaying oscillation]),
        pole-panel((-0.55, -0.55), (-0.85, 0.85)),
        response-panel(
          underdamped,
          (-1.08, 1.08),
          ((-1, [-1]), (0, [0]), (1, [1])),
          envelope: stable-envelope,
        ),
      ),

      group-label([Critically stable], 1, color-surface-strong),
      ..row(
        case-label([Undamped], [$p_(1,2) = plus.minus i omega$], [Sustained oscillation]),
        pole-panel((0, 0), (-0.85, 0.85)),
        response-panel(
          marginal,
          (-1.1, 1.1),
          ((-1, [-1]), (0, [0]), (1, [1])),
          envelope: marginal-envelope,
        ),
      ),

      group-label([Unstable], 3, color-secondary.lighten(94%)),
      ..row(
        case-label([Oscillatory unstable], [$p_(1,2) = sigma plus.minus i omega$, $sigma > 0$], [Growing oscillation]),
        pole-panel((0.55, 0.55), (-0.85, 0.85)),
        response-panel(
          unstable-osc,
          (-3.9, 3.9),
          ((-3, [-3]), (0, [0]), (3, [3])),
          envelope: unstable-envelope,
        ),
      ),
      ..row(
        case-label([Repeated-real unstable], [$p_1 = p_2 > 0$], [Monotonic growth]),
        pole-panel((0.85,), (0,), multiplicity: (0.42, 0.42)),
        response-panel(unstable-repeat, (-0.7, 14), ((0, [0]), (7, [7]), (14, [14]))),
      ),
      ..row(
        case-label([Distinct-real unstable], [$p_1 > p_2 > 0$], [Monotonic growth]),
        pole-panel((0.45, 1.35), (0, 0)),
        response-panel(unstable-distinct, (-0.35, 7), ((0, [0]), (3, [3]), (6, [6]))),
      ),
    )
  ]
]
