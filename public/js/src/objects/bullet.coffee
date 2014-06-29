define [
  'views/base'
], (BaseView) ->
  class Bullet
    world: null

    defaults:
      color: [0, 0, 0]
      opacity: 0.6
      size: 6
      speed: 4
      speed_limit: 8

    constructor: (@world, @coords, @direction, options) ->
      _.extend @, Backbone.Events

      @options = _.extend @defaults, options

      @view = new BaseView @world.ctx, @options.size

      @size = @options.size
      @speed = @options.speed
      @opacity = @options.opacity

      @initEvents()

    initEvents: ->
      @toggleMutators on, @shift, @fadeOut, @speadUp, @deflate

      @on 'speed_limit', ->
        @toggleMutators off, @speadUp, @deflate
        @toggleMutators on, @slowDown, @inflate

      @on 'stop', ->
        @stopListening @world, 'tick'

    render: ->
      @view.applyColor @options.color, @opacity
      @view.drawBody @coords, @size

    shift: ->
      axis = +(@direction in ['up', 'down'])
      isPositive = +(@direction in ['right', 'down'])

      @coords[axis] += @speed * (if isPositive then 1 else -1)

    speadUp: ->
      @speed *= 1.04
      @trigger 'speed_limit' if @options.speed_limit < @speed

    slowDown: ->
      @speed /= 1.01
      @trigger 'stop' if @options.speed > @speed

    inflate: ->
      @size *= 1.04

    deflate: ->
      @size /= 1.02

    fadeOut: ->
      @opacity -= 0.01

    toggleMutators: (to_enable, mutators...) ->
      @[if to_enable then 'listenTo' else 'stopListening'] @world, 'tick', mutator for mutator in mutators
