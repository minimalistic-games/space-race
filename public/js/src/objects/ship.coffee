define [
  'views/ship'
  'objects/bullet'
], (ShipView, Bullet) ->
  class Ship
    world: null

    defaults:
      coords: [100, 100]
      size: 40
      color: [0, 0, 0]
      speed_limit: 20
      acceleration: 0.4
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

      # [red, green, blue]
      @color = @options.color

      @opacity = 0.4

      @to_speed_up = up: no, down: no, left: no, right: no
      @speed = up: 0, down: 0, left: 0, right: 0

      @blocks = @options.blocks

      # number of bullets in queue
      @bullets_in_queue = 0

      # registry of bullets that a fired currently
      @bullets = []

      @initEvents()

    initEvents: ->
      @listenTo @world, 'tick', @_shiftOnTick

      @on 'control:shift', (data) ->
        @to_speed_up[data.direction] = not data.to_stop
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
      10 * (@speed[['right', 'down'][axis]] -
            @speed[['left', 'up'][axis]])

    _shiftOnTick: ->
      @_shift direction, to_speed_up for direction, to_speed_up of @to_speed_up

    _shift: (direction, to_speed_up) ->
      if @_isFacingBound direction
        @speed[direction] = 0
        return

      speed = @speed[direction] + @options.acceleration * (if to_speed_up then 1 else -1)

      return if speed < 0

      @speed[direction] = speed if speed < @options.speed_limit

      axis = +(direction in ['up', 'down'])
      is_positive = +(direction in ['right', 'down'])

      @coords[axis] += @speed[direction] * (if is_positive then 1 else -1)

    _isMoving: ->
      return yes for direction, to_speed_up of @to_speed_up when to_speed_up
      no

    _isFacingBound: (direction) ->
      @world.isObjectFacingBound @coords, @options.size, direction

    _queueBullet: ->
      @bullets_in_queue += 1 if @bullets_in_queue < @options.bullets_limit

    _shot: ->
      for direction, to_speed_up of @to_speed_up when to_speed_up and @bullets_in_queue
        @bullets_in_queue -= 1
        @_createBullet direction

      @trigger 'shot'

    _createBullet: (direction) ->
      bullet = new Bullet @world, _.clone(@coords), direction, color: @color

      @bullets.push bullet

      bullet.on 'stop', =>
        @bullets.shift()
