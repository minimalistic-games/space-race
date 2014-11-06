define [
  'objects/ship'
  'behaviors/controlled'
], (Ship, controlled) ->
  class ControlledShip extends Ship
    constructor: (world, options, @socket) ->
      super
      _.extend @, controlled

    init: (on_register_callback) ->
      @identify 'controlled_ship:id', (data) =>
        # sets "id", "coords" and "blocks"
        _.extend @, data

        @listenDom()
        @_passDomEvents()
        on_register_callback()

      # tell server about a shift
      @on 'control:shift', (data) =>
        @socket.emit 'shift', data

      # change color a bit
      @on 'stop', @changeColor

      # update server with current coords
      window.setInterval =>
        @socket.emit 'move', coords: @coords
      , 800

    identify: (id_storage_key, callback) ->
      is_int = (value) -> +value is parseInt value, 10

      id = window.localStorage.getItem id_storage_key
      throw new TypeError 'stored id must be null or integer' if id and not is_int id

      @socket.emit 'identify', id: id

      @socket.on 'register', (data) =>
        throw new TypeError 'retrieved id must be integer' unless is_int data.id
        window.localStorage.setItem id_storage_key, data.id
        callback data

    _passDomEvents: ->
      @on 'key', (key, is_down) ->
        if @keys.ctrl is key
          return @trigger 'control:weapon',
            to_fire: not is_down

        @trigger 'control:shift',
          direction: _.invert(@keys)[key]
          to_stop: not is_down
