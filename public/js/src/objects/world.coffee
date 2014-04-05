define [
], ->
  class World
    ctx: null

    _time_step: 10

    constructor: ->
      _.extend @, Backbone.Events

    run: ->
      window.setInterval (@_onTick.bind @), @_time_step

    _onTick: ->
      @trigger 'tick'
