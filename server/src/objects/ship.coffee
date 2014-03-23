class Ship
  constructor: (@id) ->
    @coords = [ 200, 200 ]

  move: (@coords) -> @

  toClientData: ->
    id: @id
    coords: @coords

module.exports = Ship
