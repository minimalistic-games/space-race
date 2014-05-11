define [
  'objects/ship'
  'behaviors/controlled'
  'behaviors/identified'
], (Ship, Controlled, Identified) ->
  class ControlledShip extends Ship
    constructor: (world, options, @socket) ->
      super world, options
      _.extend @, new Controlled, new Identified @socket

    init: (on_register_callback) ->
      @identify 'controlled_ship:id'

      # append to the list of renderable objects
      @once 'register', (data) =>
        @id = data.id
        @coords = data.coords
        @listenDom()
        @_passDomEvents()

        on_register_callback()

      # tell server about a shift
      @on 'control:shift', (data) =>
        @socket.emit 'shift', data

      # change color a bit
      @on 'stop', @changeColor

      # tell server about a move
      @on 'move', (data) =>
        @socket.emit 'move', data

    _passDomEvents: ->
      @on 'key', (key, is_down) ->
        if @keys.space is key
          return @trigger 'control:shield',
            to_stop: not is_down

        if @keys.ctrl is key
          return @trigger 'control:weapon',
            to_fire: not is_down

        @trigger 'control:shift',
          direction: _.invert(@keys)[key]
          to_stop: not is_down
