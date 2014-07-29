_ = require 'underscore'

module.exports = class ClientShipDecorator
  constructor: (@ship, @props...) ->

  toJSON: ->
    _.pick @ship, @props
