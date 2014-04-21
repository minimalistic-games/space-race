define [
  'objects/world'
  'objects/bounds'
  'objects/ship'
  'behaviors/controllable'
  'behaviors/identifiable'
  'backbone'
], (World, Bounds, Ship, Controllable, Identifiable) ->
  class App
    # main container object
    world: null

    # objects to render
    objects: {}

    # application state transport
    socket: null

    constructor: (ctx) ->
      @world = new World
      @world.ctx = ctx

      bounds = new Bounds @world, color: [ 100, 150, 200 ]
      @world.bounds = bounds
      @objects.bounds = bounds

      @socket = io.connect 'http://' + window.location.host

    # Starts application
    init: ->
      @addControlledShip()
      @listenServer()
      @startDrawingLoop()
      @world.run()

    # Creates one controlled ship and canvas bounds
    addControlledShip: ->
      # @todo:
      #   derive a ControlledShip class from Ship
      #   configure it with socket
      #   and move all the listeners there
      ship = new Ship @world, color: [ 50, 50, 50 ]
      _.extend ship, new Controllable, new Identifiable @socket

      ship.toggleDomEvents yes
      ship.identify 'controlledShip:id'
      @initControlledShipListeners ship

    # Subscribes controlled ship to custom events
    initControlledShipListeners: (ship) ->
      # append to the list of renderable objects
      ship.once 'register', (data) =>
        ship.id = data.id
        ship.coords = data.coords
        @objects.controlled_ship = ship

      # tell server about a shift
      ship.on 'control:shift', (data) =>
        @socket.emit 'shift', data

      # change color a bit
      ship.on 'stop', ship.changeColor

      # tell server about a move
      ship.on 'move', (data) =>
        @socket.emit 'move', data

    # Subscribes to server events
    listenServer: ->
      # create another ship
      @socket.on 'create', (data) =>
        ship = new Ship @world,
          color: [ 100, 100, 100 ]
          coords: data.coords
        ship.id = data.id

        @registerShip ship

      # remove disconnected ship
      @socket.on 'remove', (data) =>
        ship = @getRegisteredShip data.id
        ship.destroy()
        @unregisterShipById data.id

      # shift another ship
      @socket.on 'shift', (data) =>
        ship = @getRegisteredShip data.id
        ship.trigger 'control:shift', data

    # @todo: introduce a registry class
    getRegisteredShip: (id) ->
      @objects['ship:' + id]

    registerShip: (ship) ->
      @objects['ship:' + ship.id] = ship

    unregisterShipById: (id) ->
      delete @objects['ship:' + id]

    # Redraws all registered objects after cleaning the canvas
    startDrawingLoop: ->
      clear = =>
        @world.ctx.clearRect 0, 0, canvas.width, canvas.height

      draw = =>
        window.requestAnimationFrame draw
        clear()
        object.render() for name, object of @objects

      window.requestAnimationFrame draw
