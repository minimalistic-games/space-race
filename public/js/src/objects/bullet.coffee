define [
], ->
  class Bullet
    world: null

    defaults:
      color: [0, 0, 0]
      opacity: 0.6
      radius: 6
      speed: 4
      speed_limit: 8

    constructor: (@world, @coords, @direction, options) ->
      _.extend @, Backbone.Events

      @options = _.extend @defaults, options

      @radius = @options.radius
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
      @radius *= 1.04

    deflate: ->
      @radius /= 1.02

    fadeOut: ->
      @opacity -= 0.01

    toggleMutators: (to_enable, mutators...) ->
      @[if to_enable then 'listenTo' else 'stopListening'] @world, 'tick', mutator for mutator in mutators
