define [
], ->
  class Bullet
    world: null

    defaults:
      color: [ 0, 0, 0 ]
      opacity: 0.6
      radius: 6
      step: 4
      step_treshold: 8

    constructor: (@world, @coords, @direction, options) ->
      _.extend @, Backbone.Events

      @options = _.extend @defaults, options

      @radius = @options.radius
      @step = @options.step
      @opacity = @options.opacity

      @initEvents()

    initEvents: ->
      @toggleMutators on, @shift, @fadeOut, @speadUp, @deflate

      @on 'step_treshold', ->
        @toggleMutators off, @speadUp, @deflate
        @toggleMutators on, @slowDown, @inflate

      @on 'stop', ->
        @stopListening @world, 'tick'

    render: ->
      ctx = @world.ctx

      ctx.fillStyle = "rgba(#{@options.color.join(',')}, #{@opacity})"

      ctx.beginPath()
      ctx.arc(
        @coords[0],
        @coords[1],
        @radius,
        0,
        Math.PI * 2,
        true)
      ctx.fill()

    shift: ->
      axis = +(@direction in [ 'up', 'down' ])
      isPositive = +(@direction in [ 'right', 'down' ])

      @coords[axis] += @step * (if isPositive then 1 else -1)

    speadUp: ->
      @step *= 1.04
      @trigger 'step_treshold' if @options.step_treshold < @step

    slowDown: ->
      @step /= 1.01
      @trigger 'stop' if @options.step > @step

    inflate: ->
      @radius *= 1.1

    deflate: ->
      @radius /= 1.08

    fadeOut: ->
      @opacity -= 0.01

    toggleMutators: (to_enable, mutators...) ->
      @[if to_enable then 'listenTo' else 'stopListening'] @world, 'tick', mutator for mutator in mutators
