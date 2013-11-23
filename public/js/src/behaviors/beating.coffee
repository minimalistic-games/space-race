define [
], ->
  class Beating
    constructor: ->
      _.extend @, Backbone.Events

    runBeating: (interval) ->
      window.setInterval =>
        @trigger 'beat'
      , interval
