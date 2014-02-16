define [
], ->
  # @see https://developer.mozilla.org/en/docs/Web/API/Event
  class Controllable

    # mapping for keys identifiers
    # note that keys are partially used for stating a direction of 'control:shift' event
    _keys:
      up: 'Up'
      down: 'Down'
      left: 'Left'
      right: 'Right'
      space: 'U+0020'
      ctrl: 'Control'

    # caching storage for @_keys values
    _keys_values: []

    # storage for binded event handlers
    # to be able to detach them by reference
    _attached_dom_events: {}

    constructor: ->
      _.extend @, Backbone.Events

      @_keys_values = _.values @_keys

      @_dom_events =
        'keydown': @_handleKey
        'keyup': @_handleKey

    toggleDomEvents: (to_attach) ->
      for type, handler of @_dom_events
        if to_attach then @_attachDomEvent type, handler else @_detachDomEvent type

    _attachDomEvent: (type, handler) ->
      @_attached_dom_events[type] = handler.bind @
      document.addEventListener type, @_attached_dom_events[type]

    _detachDomEvent: (type) ->
      document.removeEventListener type, @_attached_dom_events[type]
      delete @_attached_dom_events[type]

    # triggers an inner event based on keys mapping
    _handleKey: (e) ->
      key = e.keyIdentifier
      return unless @_isValidKey key

      is_keyup = 'keyup' is e.type

      if @_keys.space is key
        return @trigger 'control:shield',
          to_stop: is_keyup

      if @_keys.ctrl is key
        return @trigger 'control:weapon',
          to_fire: is_keyup

      @trigger 'control:shift',
        direction: _.invert(@_keys)[key]
        to_stop: is_keyup

    _isValidKey: (key) ->
      key in @_keys_values
