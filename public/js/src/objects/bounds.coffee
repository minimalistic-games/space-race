define [
], ->
  class Bounds
    defaults:
      color: [ 0, 0, 0 ]
      opacity: 0.4
      thickness: 2

    constructor: (@ctx, options) ->
      @options = _.extend @defaults, options

      @width = @ctx.canvas.width
      @height = @ctx.canvas.height

      @thickness = @options.thickness

    render: ->
      @ctx.strokeStyle = "rgba(#{@options.color.join(',')}, #{@options.opacity})"

      @ctx.lineWidth = @thickness

      @ctx.strokeRect(
        @thickness / 2,
        @thickness / 2,
        @width - @thickness,
        @height - @thickness
      )
