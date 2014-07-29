module.exports = class Ship
  constructor: (@id) ->
    @coords = [200, 200]
    @blocks = []
    @is_active = yes

  move: (@coords) -> @

  generateBlocks: (level) ->
    @blocks = []

    for y in [-level..level]
      for x in [-level..level]
        @blocks.push [x, y] unless x is y is 0 or Math.ceil(Math.random() - 0.5)
