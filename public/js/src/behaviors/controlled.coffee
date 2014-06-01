define [
], ->
  # @see https://developer.mozilla.org/en/docs/Web/API/Event
  class Controlled

    # mapping for keys identifiers
    # note that keys are partially used for stating a direction of 'control:shift' event
    keys:
      up: 'Up'
      down: 'Down'
      left: 'Left'
      right: 'Right'
      ctrl: 'U+00A2'
      # space: 'U+0020'

    # caching storage for @keys values
    _keys_values: []

    # storage for binded event handlers
    # to be able to detach them by reference
    _attached_dom_events: {}

    constructor: ->
      _.extend @, Backbone.Events

      @_keys_values = _.values @keys

      @_dom_events =
        'keydown': @_handleKey
        'keyup': @_handleKey

    listenDom: ->
      @_toggleDomEvents yes

    stopDomListening: ->
      @_toggleDomEvents no

    _toggleDomEvents: (to_attach) ->
      for type, handler of @_dom_events
        if to_attach then @_attachDomEvent type, handler else @_detachDomEvent type

    _attachDomEvent: (type, handler) ->
      @_attached_dom_events[type] = handler.bind @
      document.addEventListener type, @_attached_dom_events[type]

    _detachDomEvent: (type) ->
      document.removeEventListener type, @_attached_dom_events[type]
      delete @_attached_dom_events[type]

    _handleKey: (e) ->
      if e.keyIdentifier in @_keys_values
        @trigger 'key', e.keyIdentifier, 'keydown' is e.type
