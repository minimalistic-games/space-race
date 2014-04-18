class Ship
  constructor: (@id) ->
    @coords = [ 200, 200 ]

  move: (@coords) -> @

module.exports = Ship
