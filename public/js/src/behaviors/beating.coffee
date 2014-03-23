define [
], ->
  class Beating
    _beating_interval: 10

    constructor: ->
      _.extend @, Backbone.Events

    runBeating: (interval) ->
      window.setInterval (@_onBeat.bind @), @_beating_interval

    _onBeat: ->
      @trigger 'beat'
