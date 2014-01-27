define [
], ->
  class Controllable
    constructor: ->
      _.extend @, Backbone.Events

      @dom_events =
        'keydown': @handleKey
        'keyup': @handleKey

      @attached_dom_events = {}

      @keys =
        up: 'Up'
        down: 'Down'
        left: 'Left'
        right: 'Right'
        space: 'U+0020'
        ctrl: 'Control'

    toggleDomEvents: (to_attach) ->
      for type, handler of @dom_events
        # storing binded event handlers
        # to be able to detach them by reference
        @attached_dom_events[type] = (e) => handler.call @, e if to_attach

        document[(if to_attach then 'add' else 'remove') + 'EventListener'] type, @attached_dom_events[type], false

    isValidKey: (key) ->
      @keys_values ?= _.values @keys
      key in @keys_values

    handleKey: (e) ->
      key = e.keyIdentifier
      return unless @isValidKey key

      if @keys.space is key
        return @trigger 'control:shield',
          to_stop: 'keyup' is e.type

      if @keys.ctrl is key
        return @trigger 'control:weapon',
          to_fire: 'keyup' is e.type

      @trigger 'control:shift',
        direction: _.invert(@keys)[key]
        to_stop: 'keyup' is e.type
