define [
  'views/ship'
  'objects/bullet'
], (ShipView, Bullet) ->
  class Ship
    world: null

    defaults:
      coords: [ 100, 100 ]
      size: 40
      color: [ 0, 0, 0 ]
      acceleration_limit: 20
      acceleration_step: 0.4
      bullets_limit: 100

    constructor: (@world, options) ->
      _.extend @, Backbone.Events

      @options = _.extend @defaults, options

      # a helper object to delegate partial rendering
      @view = new ShipView @world.ctx, @options.size

      @id = null

      # coords of object's center
      @coords = @options.coords

      # diameter [px]
      @size = @options.size

      # [ red, green, blue ]
      @color = @options.color

      @opacity = 0.4

      @moving_directions = up: no, down: no, left: no, right: no
      @acceleration_directions = up: 0, down: 0, left: 0, right: 0

      # e.g. [
      #   [ 0, 1 ]
      #   [ 1, -1 ]
      #   [ -1, 0 ]
      #   [ 1, 1 ]
      # ]
      @blocks = _.times 4, ->
                  _.times 2, ->
                    Math.floor(Math.floor(Math.random() * 10) / 5) * 2 - 1

      # number of bullets in queue
      @bullets_in_queue = 0

      # registry of bullets that a fired currently
      @bullets = []

      @initEvents()

    initEvents: ->
      @listenTo @world, 'tick', @_shiftOnTick

      @on 'control:shift', (data) ->
        @moving_directions[data.direction] = not data.to_stop
        @trigger 'stop' if data.to_stop and not @_isMoving()

      @on 'control:weapon', (data) ->
        # start/stop charging a gun
        @[if data.to_fire then 'stopListening' else 'listenTo'] @world, 'tick', @_queueBullet

        # fire all bullets, one at a time
        @listenTo @world, 'tick', @_shot if data.to_fire

      @on 'shot', ->
        @stopListening @world, 'tick', @_shot unless @bullets_in_queue > 0

      @on 'render', ->
        bullet.render() for bullet in @bullets when bullet

    destroy: ->
      @stopListening()

    render: ->
      @view.applyColor @color, @opacity
      @view.drawBody @coords

      _.each @blocks, @_renderBlock.bind @

      @view.text @id, @coords, -12
      @view.text @bullets_in_queue or '', @coords, 12, 'end', 'bottom'

      @trigger 'render'

    changeColor: ->
      for i of @color
        random_sign = Math.round(Math.random() * 2) - 1
        @color[i] = Math.min 100, @color[i] + random_sign * 10

    _renderBlock: (normalized_coords) ->
      coords = _.map normalized_coords, (normalized_coord, axis) =>
        normalized_coord * @size + @coords[axis] + @_getBlockOffset axis

      @view.applyColor @color, @opacity * 0.6
      @view.drawBody coords, @size - 10

    _getBlockOffset: (axis) ->
      10 * (@acceleration_directions[[ 'right', 'down' ][axis]] - @acceleration_directions[[ 'left', 'up' ][axis]])

    _shiftOnTick: ->
      @_shift direction, is_moving for direction, is_moving of @moving_directions

    _shift: (direction, is_moving) ->
      if @_isFacingBound direction
        @acceleration_directions[direction] = 0
        return

      acceleration = @acceleration_directions[direction] + @options.acceleration_step * (if is_moving then 1 else -1)

      return if acceleration < 0

      @acceleration_directions[direction] = acceleration if acceleration < @options.acceleration_limit

      axis = +(direction in [ 'up', 'down' ])
      is_positive = +(direction in [ 'right', 'down' ])

      @coords[axis] += @acceleration_directions[direction] * (if is_positive then 1 else -1)

    _isMoving: ->
      return yes for direction, is_moving of @moving_directions when is_moving
      no

    _isFacingBound: (direction) ->
      @world.isObjectFacingBound @coords, @options.size, direction

    _queueBullet: ->
      @bullets_in_queue += 1 if @bullets_in_queue < @options.bullets_limit

    _shot: ->
      for direction, is_moving of @moving_directions when is_moving and @bullets_in_queue
        @bullets_in_queue -= 1
        @_createBullet direction

      @trigger 'shot'

    _createBullet: (direction) ->
      bullet = new Bullet @world, _.clone(@coords), direction, color: @color

      @bullets.push bullet

      bullet.on 'stop', =>
        @bullets.shift()
