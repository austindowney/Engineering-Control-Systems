#import "@preview/cetz:0.5.2" as cetz
#import "colors.typ": *
#import "dimensions.typ": *
#import "mechanics.typ": *

#let draw = cetz.draw

#let mechanics-mm(value) = if type(value) == length {
  value / 1mm
} else {
  value
}

#let mechanics-angle(value) = if type(value) == angle {
  value
} else {
  value * 1deg
}

// Run component geometry in a local coordinate system whose positive x-axis
// points along the component. Angles are measured counterclockwise.
#let mechanics-frame(origin, angle, body) = {
  draw.group({
    draw.set-origin(origin)
    draw.rotate(angle)
    body
  })
}

// Fixed support usable as a floor, ceiling, or wall.
// hatch-side = -1 places hatching below the support; +1 places it above.
#let fixed-support(
  origin,
  length: 2cm,
  direction: 0,
  hatch-side: -1,
  hatch-depth: 2.7,
  hatch-spacing: 1.5,
  hatch-direction: "forward",
) = {
  assert(
    hatch-direction in ("forward", "backward"),
    message: "hatch-direction must be \"forward\" or \"backward\"",
  )
  let support-length = mechanics-mm(length)
  let support-direction = mechanics-angle(direction)
  let hatch-slant = if hatch-direction == "forward" { -35deg } else { 35deg }
  let hatch-angle = hatch-side * 90deg + hatch-slant
  let hatch-count = calc.floor(support-length / hatch-spacing) + 1
  let hatch-span = (hatch-count - 1) * hatch-spacing
  let hatch-inset = (support-length - hatch-span) / 2
  mechanics-frame(origin, support-direction, {
    // Draw hatching first so the heavy support edge remains visually
    // continuous and masks the ends of the thinner hatch strokes.
    for x in range(hatch-count) {
      let position = hatch-inset + x * hatch-spacing
      draw.line(
        (position, 0),
        (
          position + hatch-depth * calc.cos(hatch-angle),
          hatch-depth * calc.sin(hatch-angle),
        ),
        ..mechanics-hatch-style,
      )
    }
    draw.line(
      (0, 0),
      (support-length, 0),
      ..mechanics-support-style,
    )
  })
}

// Axial spring with straight leads at both ends.
#let linear-spring(
  origin,
  length: 2cm,
  angle: 0deg,
  coils: 7,
  amplitude: 2,
  lead: 3,
) = {
  let rendered-length = mechanics-mm(length)
  let lead-length = mechanics-mm(lead)
  assert(
    rendered-length > 2 * lead-length,
    message: "spring length is too short for the selected leads",
  )
  mechanics-frame(origin, angle, {
    let working = rendered-length - 2 * lead-length
    let peak-count = 2 * coils
    let peak-spacing = working / peak-count
    let points = ((0, 0), (lead-length, 0))

    // Peak centers are offset by half a pitch from both coil endpoints. This
    // makes the first and last half-coils equal and removes endpoint crowding.
    for index in range(peak-count) {
      let x = lead-length + (index + 0.5) * peak-spacing
      let y = if calc.rem(index, 2) == 0 { amplitude } else { -amplitude }
      points.push((x, y))
    }
    points.push((rendered-length - lead-length, 0))
    points.push((rendered-length, 0))
    draw.line(..points, ..mechanics-spring-style)
  })
}

// Viscous dashpot with equal external connector lengths at both ends.
// Only the total assembly length is required. The approved body geometry
// remains available as optional overrides for unusual figures.
#let viscous-damper(
  origin,
  length: 3cm,
  angle: 0deg,
  body-length: 4mm,
  body-width: 7mm,
  wall-clearance: 0.5mm,
  piston-position: 0.48,
) = {
  let rendered-length = mechanics-mm(length)
  let cylinder-length = mechanics-mm(body-length)
  let cylinder-width = mechanics-mm(body-width)
  let clearance = mechanics-mm(wall-clearance)
  let connector = (rendered-length - cylinder-length) / 2
  let cylinder-start = connector
  let cylinder-end = rendered-length - connector
  let piston-half-height = cylinder-width / 2 - clearance
  assert(
    cylinder-length > 0 and connector > 0,
    message: "damper body length must be shorter than its overall length",
  )
  assert(
    piston-half-height > 0,
    message: "wall clearance must be less than half the damper body height",
  )
  assert(
    piston-position > 0 and piston-position < 1,
    message: "piston-position must be between 0 and 1",
  )
  let piston-x = cylinder-start + cylinder-length * piston-position
  mechanics-frame(origin, angle, {
    // Draw both external connections and the piston rod first.
    draw.line((0, 0), (piston-x, 0), ..mechanics-damper-style)
    draw.line(
      (cylinder-end, 0),
      (rendered-length, 0),
      ..mechanics-damper-style,
    )

    // The piston plate stops short of both cylinder walls by wall-clearance.
    draw.line(
      (piston-x, -piston-half-height),
      (piston-x, piston-half-height),
      ..mechanics-damper-style,
    )

    // Open cylinder at the rod side; closed cylinder at the output side.
    draw.line(
      (cylinder-start, -cylinder-width / 2),
      (cylinder-end, -cylinder-width / 2),
      (cylinder-end, cylinder-width / 2),
      (cylinder-start, cylinder-width / 2),
      ..mechanics-damper-style,
    )
  })
}

// Planar torsional spring symbol. The outer connection is tangent to the
// first coil; the inner connection ends at the rotational axis.
#let torsional-spring(
  origin,
  angle: 0deg,
  turns: 2.5,
  outer-radius: 5,
  inner-radius: 1.4,
  lead: 4,
  samples-per-turn: 24,
) = mechanics-frame(origin, angle, {
  let sample-count = calc.ceil(turns * samples-per-turn)
  let points = ((-outer-radius - lead, 0), (-outer-radius, 0))
  for index in range(sample-count + 1) {
    let progress = index / sample-count
    let theta = 180deg + progress * turns * 360deg
    let radius = outer-radius + (inner-radius - outer-radius) * progress
    points.push((
      radius * calc.cos(theta),
      radius * calc.sin(theta),
    ))
  }
  points.push((0, 0))
  draw.line(..points, ..mechanics-spring-style)
})

// Suspended torsional oscillator. The vertical zigzag is the conventional
// side-view symbol for a torsional element; the curved cue and k_theta label
// distinguish it from a translating spring--mass system.
#let torsional-suspension(
  origin,
  length: 3cm,
  support-width: 2cm,
  coils: 6,
  spring-amplitude: 2,
  body-width: 14,
  body-height: 10,
  label: [$m$ #linebreak() $J$],
) = {
  let x = origin.at(0)
  let y = origin.at(1)
  let suspension-length = mechanics-mm(length)
  let ceiling-width = mechanics-mm(support-width)
  let body-top = y - suspension-length

  linear-spring(
    (x, y),
    length: suspension-length,
    angle: -90deg,
    coils: coils,
    amplitude: spring-amplitude,
    lead: 3,
  )
  // Draw the ceiling edge last so the spring terminates cleanly beneath it.
  fixed-support(
    (x - ceiling-width / 2, y),
    length: ceiling-width,
    direction: 0,
    hatch-side: 1,
  )
  draw.rect(
    (x - body-width / 2, body-top - body-height),
    (x + body-width / 2, body-top),
    ..mechanics-body-style,
  )
  draw.content((x, body-top - body-height / 2), label)

  // Rotation cue is intentionally local to this physical symbol; there is no
  // general angular-displacement component in the public mechanics API.
  let cue-radius-x = body-width * 0.50
  let cue-radius-y = cue-radius-x * 0.38
  let cue-origin = (x, y - suspension-length * 0.55 - 1.3)
  let cue-start = 165deg
  let cue-stop = 450deg
  let cue-start-point = (
    cue-origin.at(0) + cue-radius-x * calc.cos(cue-start),
    cue-origin.at(1) + cue-radius-y * calc.sin(cue-start),
  )
  draw.arc(
    cue-start-point,
    start: cue-start,
    stop: cue-stop,
    radius: (cue-radius-x, cue-radius-y),
    stroke: (
      paint: color-displacement,
      thickness: line-normal,
      cap: "butt",
      join: "miter",
    ),
    mark: (fill: color-displacement, ..arrow-medium),
  )
  draw.content(
    (x - cue-radius-x - 2, cue-origin.at(1) + 1.8),
    anchor: "east",
    text(fill: color-on-light)[$theta$],
  )
  draw.content(
    (x + spring-amplitude + 2.5, y - suspension-length * 0.32),
    anchor: "west",
    [$k_theta$],
  )
}

// Linear displacement measured from a datum to a displaced position.
#let displacement-indicator(
  origin,
  length: 12,
  angle: 0deg,
  label: [$x$],
  offset: 0,
  label-offset: 2,
  extension: 2.5,
  arrow: arrow-medium,
) = mechanics-frame(origin, angle, {
  draw.line(
    (0, -extension),
    (0, extension),
    stroke: (
      paint: color-displacement,
      thickness: line-normal,
      cap: "butt",
    ),
  )
  draw.line(
    (0, offset),
    (length, offset),
    stroke: mechanics-displacement-style.stroke,
    mark: (fill: color-displacement, ..arrow),
  )
  draw.content(
    (length / 2, offset + label-offset),
    label,
  )
})
