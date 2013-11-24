require.config
  baseUrl: 'js/lib'
  paths:
    underscore: '../bower_components/underscore/underscore-min'
    backbone: '../bower_components/backbone/backbone'
  shim:
    underscore:
      exports: '_'
    backbone:
      deps: [ 'underscore' ]
      exports: 'Backbone'
    socketio:
      exports: 'io'

require [
  'app'
], (App) ->
  canvas = document.getElementById 'canvas'

  unless canvas.getContext
    document.body.innerText = canvas.innerHTML
    return ->

  app = new App canvas.getContext '2d'
  app.init()

  # storing app reference for debug
  window.app = app
