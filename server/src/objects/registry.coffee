class Registry
  constructor: (@object_type) ->
    @collection = []

  create: ->
    id = @collection.length
    object = new @object_type id
    @collection[id] = object
    object

  get: (id) ->
    @collection[id]

  all: ->
    @collection

  remove: (id) ->
    delete @collection[id]
    @

module.exports = Registry
