define [
  'views/base'
], (BaseView) ->
  class Star
    defaults:
      coords: [0, 0]
      color: [0, 0, 0]
      opacity: 0.1
      radius: 40

    constructor: (world, options) ->
      @options = _.extend({}, @defaults, options)
      @coords = @options.coords
      @radius = @options.radius
      @view = new BaseView world.ctx

    render: ->
      @view.applyColor(@options.color, @options.opacity)
      @view.drawCircle(@coords, @radius)
