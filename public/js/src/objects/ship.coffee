define [
  'views/ship'
  'objects/bullet'
], (ShipView, Bullet) ->
  class Ship
    world: null

    defaults:
      acceleration_limit: 10
      acceleration_step: 1
      coords: [ 100, 100 ]
      size: 40
      color: [ 0, 0, 0 ]
      resizing_step: 2
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
      @shield_directions = _.clone @moving_directions

      # number of bullets in queue
      @bullets_in_queue = 0

      # registry of bullets that a fired currently
      @bullets = []

      @initEvents()

    initEvents: ->
      @listenTo @world, 'tick', @_shiftOnTick
      @listenTo @world, 'tick', @_resizeOnTick

      @on 'control:shift', (data) ->
        @moving_directions[data.direction] = not data.to_stop
        @trigger 'stop' if data.to_stop and not @_isMoving()

      @on 'control:shield', (data) ->
        @_toggleShield not data.to_stop

      @on 'control:weapon', (data) ->
        # start/stop charging a gun
        @[if data.to_fire then 'stopListening' else 'listenTo'] @world, 'tick', @_queueBullet

        # fire all bullets, one at a time
        @listenTo @world, 'tick', @_shot if data.to_fire

      @on 'shot', ->
        @stopListening @world, 'tick', @_shot unless @bullets_in_queue > 0

      @on 'render', ->
        bullet.render() for bullet in @bullets when bullet

    destroy: (callback) ->
      @listenTo @world, 'tick', ->
        if @opacity > 0
          @opacity -= 0.01
          return

        @stopListening()
        callback()

    render: ->
      # draw both static and dynamic bodies
      @view.applyColor @color, @opacity
      @view.drawBody @coords
      @view.drawBody @coords, @size / Math.sqrt 2

      # draw a front arc for each moving direction
      @_renderArcs 0.5, 0.4, @moving_directions

      # draw shields (directions are set on turning shields on)
      @_renderArcs 0.8, 0.7, @shield_directions

      @view.showBulletsInQueue @coords, @bullets_in_queue

      @trigger 'render'

    changeColor: ->
      for i of @color
        random_sign = Math.round(Math.random() * 2) - 1
        @color[i] = Math.min 100, @color[i] + random_sign * 10

    _renderArcs: (size_coef, angle_coef, directions) ->
      radius = @size * size_coef
      angle = Math.PI * angle_coef

      @view.drawFrontArc @coords, radius, angle, direction for direction, is_moving of directions when is_moving

    _shiftOnTick: ->
      @_shift direction, is_moving for direction, is_moving of @moving_directions

    _shift: (direction, is_moving) ->
      if @_isFacingBound direction
        @acceleration_directions[direction] = 0
        return

      acceleration = @acceleration_directions[direction] + @options.acceleration_step * (if is_moving then 1 else -1)

      return if acceleration < 0 or acceleration > @options.acceleration_limit

      @acceleration_directions[direction] = acceleration

      coords = @coords
      axis = +(direction in [ 'up', 'down' ])
      is_positive = +(direction in [ 'right', 'down' ])

      coords[axis] += @acceleration_directions[direction] * (if is_positive then 1 else -1)

      @_move coords

    _move: (coords) ->
      @coords = coords
      @trigger 'move', coords: @coords

    _isMoving: ->
      return yes for direction, is_moving of @moving_directions when is_moving
      no

    _isFacingBound: (direction) ->
      @world.isObjectFacingBound @coords, @options.size, direction

    _toggleShield: (to_proceed) ->
      for direction of @shield_directions
        if not to_proceed
          @shield_directions[direction] = no
          continue

        continue if @shield_directions[direction]

        # a shield can be activated only while moving along current directions
        @shield_directions[direction] = @moving_directions[direction]

    _resizeOnTick: ->
      if not @_isMoving()
        if @size > @options.size
          @size -= @options.resizing_step * 2
      else if @size < @options.size * 4
        @size += @options.resizing_step

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
