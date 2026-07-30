#import "/styles/figure.typ": *

// figure-pipeline: kind=plot
// figure-pipeline: width-profile=full
#let times = range(61).map(index => index / 10)
#let oscillation-times = range(301).map(index => index / 50)

#standalone[
  #book-layout(
    grid(
      columns: 2,
      column-gutter: plot-panel-gutter,
      row-gutter: 7mm,
      book-diagram(
        size: "panel",
        xlabel: $t$,
        ylabel: $u(t - 1)$,
        xlim: (0, 6),
        ylim: (-0.1, 1.2),
        plot(times, time => if time < 1 { 0 } else { 1 }, step: end),
      ),
      book-diagram(
        size: "panel",
        xlabel: $t$,
        ylabel: $(t - 1) u(t - 1)$,
        xlim: (0, 6),
        ylim: (-0.1, 5.5),
        plot(times, time => calc.max(0, time - 1)),
      ),
      book-diagram(
        size: "panel",
        xlabel: $t$,
        ylabel: $x(t)$,
        xlim: (0, 6),
        ylim: (-0.05, 1.1),
        plot(times, time => calc.exp(-time)),
      ),
      book-diagram(
        size: "panel",
        xlabel: $t$,
        ylabel: $x(t)$,
        xlim: (0, 6),
        ylim: (-1.1, 1.1),
        plot(
          oscillation-times,
          time => calc.exp(-0.2 * time) * calc.cos(4 * time),
        ),
      ),
    )
  )
]
