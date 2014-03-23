define [
  'behaviors/beating'
], (Beating) ->
  class Bullet
    defaults:
      color: [ 0, 0, 0 ]
      opacity: 0.6
      radius: 6
      step: 4
      step_treshold: 8

    constructor: (@ctx, @coords, @direction, options) ->
      @options = _.extend @defaults, options

      @radius = @options.radius
      @step = @options.step
      @opacity = @options.opacity

      _.extend @, new Beating

      @initEvents()
      @runBeating()

    render: ->
      @ctx.fillStyle = "rgba(#{@options.color.join(',')}, #{@opacity})"

      @ctx.beginPath()
      @ctx.arc(
        @coords[0],
        @coords[1],
        @radius,
        0,
        Math.PI * 2,
        true
      )
      @ctx.fill()

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

    blowUp: ->
      @radius *= 1.1

    blowDown: ->
      @radius /= 1.08

    fadeOut: ->
      @opacity -= 0.01

    toggleMutators: (to_enable, mutators...) ->
      @[if to_enable then 'on' else 'off'] 'beat', mutator for mutator in mutators

    initEvents: ->
      @toggleMutators on, @shift, @fadeOut, @speadUp, @blowDown

      @on 'step_treshold', ->
        @toggleMutators off, @speadUp, @blowDown
        @toggleMutators on, @slowDown, @blowUp

      @on 'stop', ->
        @off 'beat', @slowDown
