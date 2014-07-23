class Ship
  constructor: (@id) ->
    @coords = [200, 200]
    @blocks = []
    @is_active = yes

  move: (@coords) -> @

  generateBlocks: (level) ->
    @blocks = []

    for row in [-level..level]
      for col in [-level..level]
        @blocks.push [row, col] unless row is col is 0 or Math.ceil(Math.random() - 0.5)

module.exports = Ship
