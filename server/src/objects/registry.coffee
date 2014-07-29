module.exports = class Registry
  constructor: (@object_type) ->
    # using an object instead of array to avoid
    # storing "array holes" for removed items
    @_collection = {}
    @_next_id = 0

  create: ->
    object = new @object_type @_next_id
    @_collection[@_next_id] = object
    @_next_id += 1
    object

  get: (id) ->
    @_collection[id]

  all: ->
    @_collection

  remove: (id) ->
    delete @_collection[id]
    @
