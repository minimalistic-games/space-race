define [
], ->
  class BaseView
    constructor: (@ctx) ->
      @color = [0, 0, 0]
      @opacity = 1

    rgba: (color, opacity) ->
      "rgba(#{color.join(',')}, #{opacity})"

    # store params to be able to reset it
    # in ctx mutation calls (e.g. "@text()")
    applyColor: (@color, @opacity) ->
      @ctx.fillStyle = @rgba color, opacity

    getRectCoord: (coord, size) ->
      coord - size / 2

    drawSquare: (coords, size) ->
      @ctx.fillRect(@getRectCoord(coords[0], size),
                    @getRectCoord(coords[1], size),
                    size,
                    size)

    drawCircle: (coords, radius) ->
      @ctx.beginPath()
      @ctx.arc(coords[0],
               coords[1],
               radius,
               0,
               Math.PI * 2,
               true)
      @ctx.fill()
