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
      @view.applyStrokeColor @options.color, @options.opacity
      @view.drawStrokeRect [0, 0], @width, @height, @thickness
