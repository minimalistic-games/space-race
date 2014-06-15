class Ship
  block_levels_from_center: 1

  constructor: (@id) ->
    @coords = [200, 200]
    @is_active = yes
    @blocks = @_initBlocks()

  move: (@coords) -> @

  # e.g. @block_levels_from_center = 1
  #
  # [                [
  #   [0 0 1]          [0, 1]
  #   [1 * 0]  =>      [1, -1]
  #   [0 1 1]          [-1, 0]
  # ]                  [1, 1]
  #                  ]
  #
  _initBlocks: ->
    blocks = []
    levels = @block_levels_from_center

    for row in [-levels..levels]
      for col in [-levels..levels]
        blocks.push [row, col] unless row is 0 and col is 0 or Math.ceil(Math.random() - 0.5)

    blocks

module.exports = Ship
