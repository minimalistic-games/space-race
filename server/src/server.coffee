express = require 'express'
app = express()
server = require('http').createServer app
config = require './config/server'

public_dir = __dirname + '/../../public'

app.use express.compress()
app.use express.logger()
app.use express.static public_dir

app.get '/', (req, res) ->
    res.sendfile public_dir + 'index.html'

server.listen config.port
console.log 'Listening on port ' + config.port

module.exports = server
