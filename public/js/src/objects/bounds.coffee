define [
  'views/base'
], (BaseView) ->
  class Bounds
    ctx: null

    defaults:
      color: [0, 0, 0]
      opacity: 0.4
      thickness: 10

    constructor: (world, options) ->
      @options = _.extend {}, @defaults, options
      @ctx = world.ctx
      @view = new BaseView @ctx
      @width = @ctx.canvas.width
      @height = @ctx.canvas.height
      @thickness = @options.thickness

    render: ->
      @ctx.strokeStyle = @view.rgba @options.color, @options.opacity
      @ctx.lineWidth = @thickness
      @ctx.strokeRect(@thickness / 2,
                      @thickness / 2,
                      @width - @thickness,
                      @height - @thickness)
