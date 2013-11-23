define [
  'behaviors/beating'
], (Beating) ->
  class Bullet
    constructor: (@ctx, @coords, @direction, options) ->
      @options = _.extend
        color: [ 0, 0, 0 ]
        opacity: 0.6
        radius: 8
        step: 2
        stepTreshold: 32
      , options

      @radius = @options.radius
      @step = @options.step
      @opacity = @options.opacity

      _.extend @, new Beating

      @initEvents()
      @runBeating 10

    render: ->
      @ctx.fillStyle = 'rgba(' + @options.color.join(',') + ',' + @opacity + ')'

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
      isPositive = +(direction in [ 'right', 'down' ])

      @coords[axis] += @step * (if isPositive then 1 else -1)

    speadUp: ->
      @step *= 1.05
      @trigger 'stepTreshold' if @options.stepTreshold < @step

    slowDown: ->
      @step /= 2
      @trigger 'stop' if @options.step > @step

    blowUp: ->
      @radius *= 1.04

    fadeOut: ->
      @opacity -= 0.01

    initEvents: ->
      @on 'beat', @shift
      @on 'beat', @speadUp
      @on 'beat', @blowUp
      @on 'beat', @fadeOut

      @on 'stepTreshold', ->
        @off 'beat', @speadUp
        @on 'beat', @slowDown

      @on 'stop', ->
        @off 'beat', @slowDown
