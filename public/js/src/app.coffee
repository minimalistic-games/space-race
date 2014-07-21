define [
  'objects/world'
  'objects/bounds'
  'objects/ship'
  'objects/controlled_ship'
  'backbone'
], (World, Bounds, Ship, ControlledShip, Identified) ->
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

      bounds = new Bounds @world, color: [100, 150, 200]
      @world.bounds = bounds
      @objects.bounds = bounds

      _.each (@world.generateStars 10), (star, index) =>
        @objects["star:#{index}"] = star

      @socket = io.connect "http://#{window.location.host}"

    init: ->
      @addControlledShip()
      @listenServer()
      @startDrawingLoop()
      @world.run()

    addControlledShip: ->
      ship = new ControlledShip @world, color: [50, 50, 50], @socket
      ship.init => @objects.controlled_ship = ship

    listenServer: ->
      # create another ship
      @socket.on 'create', (data) =>
        ship = new Ship @world,
          color: [100, 100, 100]
          coords: data.coords
          blocks: data.blocks
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
