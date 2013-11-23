define [
], ->
  class Identifiable
    constructor: (@socket) ->

    isInt: (value) ->
      +value is parseInt value, 10

    # Sends the 'identify' message to server containing id
    # Updates id on receiving the 'register' message
    #
    # @param string id_storage_key An id key for localStorage
    identify: (id_storage_key) ->
      id = window.localStorage.getItem id_storage_key
      throw new TypeError 'stored id must be null or integer' if id and not @isInt id

      @socket.emit 'identify',
        id: id

      @socket.on 'register', (data) =>
        throw new TypeError 'retrieved id must be integer' unless @isInt data.id
        window.localStorage.setItem id_storage_key, data.id
        @trigger 'register', data
