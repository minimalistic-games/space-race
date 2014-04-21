define [
], ->
  class ShipView
    constructor: (@ctx, @size) ->
      @direction_angles =
        right: 0
        up: - Math.PI * 0.5
        left: - Math.PI
        down: - Math.PI * 1.5

      @color = [ 0, 0, 0 ]
      @opacity = 1

      @preset()

    preset: ->
      @ctx.textAlign = 'start'
      @ctx.textBaseline = 'top'
      @ctx.font = '10px sans-serif'

    applyColor: (@color, @opacity) ->
      @ctx.fillStyle = "rgba(#{color.join(',')}, #{opacity})"

    getRectCoord: (coord, size) ->
      coord - size / 2

    drawBody: (coords, size) ->
      size = @size unless size

      @ctx.fillRect(
        @getRectCoord(coords[0], size),
        @getRectCoord(coords[1], size),
        size,
        size)

    drawFrontArc: (coords, radius, angle, direction) ->
      @ctx.beginPath()
      @ctx.arc(
        coords[0],
        coords[1],
        radius,
        angle / 2 + @direction_angles[direction],
        - angle / 2 + @direction_angles[direction],
        yes)
      @ctx.fill()

    text: (text, coords, offset = 0, align = 'start', baseline = 'top') ->
      color = @color
      opacity = @opacity
      text_align = @ctx.textAlign
      text_baseline = @ctx.textBaseline

      @applyColor [ 255, 255, 255 ], 0.4
      @ctx.textAlign = align
      @ctx.textBaseline = baseline

      @ctx.fillText text, coords[0] + offset, coords[1] + offset

      @applyColor color, opacity
      @ctx.textAlign = text_align
      @ctx.textBaseline = text_baseline
