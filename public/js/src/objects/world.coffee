define [
  'objects/bounds'
  'objects/star'
], (Bounds, Star) ->
  class World
    ctx: null
    bounds: null
    _time_step: 10 # [ms]

    constructor: ->
      _.extend(@, Backbone.Events)

    run: ->
      window.setInterval (=> @trigger 'tick'), @_time_step

    isObjectFacingBound: (coords, size, direction) ->
      throw new Error 'Bounds must be defined' unless @bounds instanceof Bounds

      limit = size / 2 + @bounds.thickness

      distances =
        left: coords[0]
        right: @bounds.width - coords[0]
        up: coords[1]
        down: @bounds.height - coords[1]

      distances[direction] < limit

    generateStars: (amount) ->
      random_coord = (coord) =>
        center = @bounds[if coord is 0 then 'width' else 'height'] / 2
        center - Math.round(center * (Math.random() - 0.5))

      random_color = ->
        Math.round 255 * Math.random()

      random_radius = ->
        10 + Math.round 400 * Math.random()

      _.times amount, =>
        new Star @,
          coords: _.times(2, (i) -> random_coord i)
          color: _.times(3, random_color)
          radius: random_radius()
