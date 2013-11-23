define [
], ->
  class ShipView
    constructor: (@ctx, @size) ->
      @directionAngles =
        right: 0
        up: - Math.PI * 0.5
        left: - Math.PI
        down: - Math.PI * 1.5

      @color = [ 0, 0, 0 ]
      @opacity = 1

      @preset()

    preset: ->
      @ctx.textAlign = 'end'
      @ctx.font = "12px sans-serif"

    applyColor: (color, opacity) ->
      @color = color
      @opacity = opacity

      @ctx.fillStyle = 'rgba(' + color.join(',') + ',' + opacity + ')'

    text: (coords, text) ->
      @ctx.fillText text, coords[0] + 10, coords[1] + 10

    getRectCoord: (coord, size) ->
      coord - size / 2

    drawBody: (coords, size) ->
      size = @size unless size

      @ctx.fillRect(
        @getRectCoord(coords[0], size),
        @getRectCoord(coords[1], size),
        size,
        size
      )

    drawFrontArc: (coords, radius, angle, direction) ->
      @ctx.beginPath()
      @ctx.arc(
        coords[0],
        coords[1],
        radius,
        angle / 2 + @directionAngles[direction],
        - angle / 2 + @directionAngles[direction],
        yes
      )
      @ctx.fill()

    showBulletsInQueue: (coords, number) ->
      color = @color
      opacity = @opacity

      @applyColor [ 255, 255, 255 ], 0.4
      @text coords, number or ''
      @applyColor color, opacity
