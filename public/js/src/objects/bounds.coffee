define [
], ->
  class Bounds
    world: null
    ctx: null

    defaults:
      color: [ 0, 0, 0 ]
      opacity: 0.4
      thickness: 10

    constructor: (@world, options) ->
      @options = _.extend @defaults, options

      @ctx = @world.ctx

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
        @height - @thickness)
