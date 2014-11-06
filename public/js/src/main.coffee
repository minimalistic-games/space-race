require.config
  baseUrl: 'js/build'
  paths:
    jquery: 'jquery_mock' # a hack against backbone dependency
    underscore: '../bower_components/underscore/underscore'
    backbone: '../bower_components/backbone/backbone' # just to utilize Backbone.Events

require [
  'app'
  'underscore'
  'backbone'
], (App) ->
  canvas = document.getElementById 'canvas'

  unless canvas.getContext
    document.body.innerText = canvas.innerHTML
    return ->

  app = new App canvas.getContext '2d'
  app.init()

  # storing app reference for debug
  window.app = app
