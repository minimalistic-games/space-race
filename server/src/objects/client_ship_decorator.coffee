_ = require 'underscore'

class ClientShipDecorator
  constructor: (@ship, @props...) ->

  toJSON: ->
    _.pick @ship, @props

module.exports = ClientShipDecorator
