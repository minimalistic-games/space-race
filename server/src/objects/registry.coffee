_ = require 'underscore'

class Registry
    constructor: (@objectType) ->
        @collection = {}

    create: ->
        id = @nextId()
        object = new @objectType id
        @collection[id] = object
        object

    nextId: ->
        ids = _.map _.keys(@collection), (id) ->
            parseInt id, 10
        if not ids.length then 1 else _.max(ids) + 1

    get: (id) -> @collection[id]

    all: -> @collection

    remove: (id) ->
        @collection = _.omit @collection, id.toString()
        @

module.exports = Registry
