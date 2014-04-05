define [
  'objects/bounds'
], (Bounds) ->
  class World
    bounds: null
    ctx: null

    _time_step: 10

    constructor: ->
      _.extend @, Backbone.Events

    run: ->
      window.setInterval (@_onTick.bind @), @_time_step

    isObjectFacingBound: (coords, size, direction) ->
      throw new Error 'Bounds must be defined' unless @bounds instanceof Bounds

      limit = size / 2 + @bounds.thickness

      distances =
        left: coords[0]
        right: @bounds.width - coords[0]
        up: coords[1]
        down: @bounds.height - coords[1]

      distances[direction] < limit

    _onTick: ->
      @trigger 'tick'
