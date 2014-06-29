define [
], ->
  class BaseView
    constructor: (@ctx, @size) ->
      @color = [0, 0, 0]
      @opacity = 1

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
