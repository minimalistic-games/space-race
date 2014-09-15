define [
], ->
  # @see https://developer.mozilla.org/en/docs/Web/API/Event
  # @see http://unixpapa.com/js/key.html
  class Controlled
    keys:
      left: 37
      up: 38
      right: 39
      down: 40
      ctrl: 17

    _keys_codes: []

    # storage for bound event handlers
    # (to be able to detach them by reference)
    _attached_dom_events: {}

    constructor: ->
      _.extend @, Backbone.Events

      @_keys_codes = _.values @keys

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
      if e.keyCode in @_keys_codes
        @trigger 'key', e.keyCode, 'keydown' is e.type
