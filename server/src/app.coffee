_ = require 'underscore'
server = require './server'
io = require('socket.io').listen server
Ship = require './objects/ship'
Registry = require './objects/registry'

registry = new Registry Ship

io.sockets.on 'connection', (socket) ->
  id = null

  socket.on 'identify', (data) ->
    id = data.id
    ship = registry.get id

    if not ship
      ship = registry.create()
      id = ship.id

    socket.emit 'register', ship.toClientData()
    socket.broadcast.emit 'create', ship.toClientData()

    _.each _.without(registry.all(), ship), (other_ship) ->
      socket.emit 'create', other_ship.toClientData()

  socket.on 'disconnect', ->
    return unless id
    registry.remove id
    socket.broadcast.emit 'remove', id: id

  socket.on 'shift', (data) ->
    return unless id
    socket.broadcast.emit 'shift', _.extend data, id: id

  socket.on 'move', (data) ->
    return unless id
    ship = registry.get id
    ship.move data.coords
