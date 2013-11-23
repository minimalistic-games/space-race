define [
  'objects/bounds'
  'objects/ship'
  'behaviors/controllable'
  'behaviors/identifiable'
  'backbone'
], (Bounds, Ship, Controllable, Identifiable) ->
  class App
    constructor: (@ctx)->
      # objects to render
      @objects = {}

      # application state transport
      @socket = io.connect 'http://' + window.location.host

    # Starts application
    init: ->
      @addInitialObjects()
      @listenServer()
      @startDrawingLoop()

    # Creates one controlled ship and canvas bounds
    addInitialObjects: ->
      @objects.bounds = new Bounds @ctx,
        color: [ 100, 150, 200 ]
        thickness: 10

      ship = new Ship @ctx, @objects.bounds,
        color: [ 50, 50, 50 ]
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
        ship = new Ship @ctx, @objects.bounds,
          color: [ 100, 100, 100 ]
          coords: data.coords
        ship.id = data.id

        @objects['ship:' + ship.id] = ship

      # remove disconnected ship
      @socket.on 'remove', (data) =>
        ship = @objects['ship:' + data.id]
        ship.destroy()

        window.setTimeout ->
          delete @objects['ship:' + data.id]
        , 1000

      # shift another ship
      @socket.on 'shift', (data) =>
        @objects['ship:' + data.id].trigger 'control:shift', data

    # Redraws all registered objects after cleaning the canvas
    startDrawingLoop: ->
      clear = =>
        @ctx.clearRect 0, 0, canvas.width, canvas.height

      draw = =>
        window.requestAnimationFrame draw
        clear()
        object.render() for object in @objects

      window.requestAnimationFrame draw
