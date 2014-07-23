define [
], ->
  class BaseView
    constructor: (@ctx) ->

    applyColor: (color, opacity) ->
      @ctx.fillStyle = @_rgba color, opacity

    applyStrokeColor: (color, opacity) ->
      @ctx.strokeStyle = @_rgba color, opacity

    drawCircle: (coords, radius) ->
      @ctx.beginPath()
      @ctx.arc(coords[0],
               coords[1],
               radius,
               0,
               Math.PI * 2,
               true)
      @ctx.fill()

    drawSquare: (coords, size) ->
      @ctx.fillRect(@_getRectCoord(coords[0], size),
                    @_getRectCoord(coords[1], size),
                    size,
                    size)

    drawStrokeRect: (top_left_coords, width, height, thickness) ->
      offset = thickness / 2
      @ctx.lineWidth = thickness
      @ctx.strokeRect(top_left_coords[0] + offset,
                      top_left_coords[1] + offset,
                      width - thickness,
                      height - thickness)

    _getRectCoord: (coord, size) ->
      coord - size / 2

    _rgba: (color, opacity) ->
      "rgba(#{color.join(',')}, #{opacity})"
