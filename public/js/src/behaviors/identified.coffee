define [
], ->
  is_int = (value) ->
    +value is parseInt value, 10

  class Identified
    constructor: (@socket) ->

    # Sends the 'identify' message to server containing id
    # Updates id on receiving the 'register' message
    #
    # @param {String}   id_storage_key    localStorage key for id
    identify: (id_storage_key) ->
      id = window.localStorage.getItem id_storage_key
      throw new TypeError 'stored id must be null or integer' if id and not is_int id

      @socket.emit 'identify', id: id

      @socket.on 'register', (data) =>
        throw new TypeError 'retrieved id must be integer' unless is_int data.id
        window.localStorage.setItem id_storage_key, data.id
        @trigger 'register', data
