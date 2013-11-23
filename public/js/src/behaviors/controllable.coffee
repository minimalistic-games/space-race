define [
], ->
  class Controllable
    constructor: ->
      _.extend @, Backbone.Events

      @domEvents =
        'keydown': @handleKey
        'keyup': @handleKey

      @attachedDomEvents = {}

      @keys =
        up: 'Up'
        down: 'Down'
        left: 'Left'
        right: 'Right'
        space: 'U+0020'
        ctrl: 'Control'

    toggleDomEvents: (toAttach) ->
      for type, handler of @domEvents
        # storing binded event handlers
        # to be able to detach them by reference
        if toAttach
          @attachedDomEvents[type] = (e) -> handler.call @, e

        document[(if toAttach then 'add' else 'remove') + 'EventListener'] type, @attachedDomEvents[type], false

    handleKey: (e)->
      key = e.keyIdentifier
      return unless key in @keys

      if @keys.space is key
        return @trigger 'control:shield',
          to_stop: 'keyup' is e.type

      if @keys.ctrl is key
        return @trigger 'control:weapon',
          to_fire: 'keyup' is e.type

      @trigger 'control:shift',
        direction: _.invert(@keys)[key]
        to_stop: 'keyup' == e.type
