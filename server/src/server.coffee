path = require 'path'
jade = require 'jade'
logger = require 'morgan'
compress = require 'compression'
express = require 'express'
app = express()
server = require('http').createServer app
config = require './config/server'

public_dir = path.join __dirname, '../../public'

app.use compress()
app.use logger 'dev'
app.use express.static public_dir

app.get '/', (req, res) ->
  res.send jade.renderFile path.join public_dir, 'index.jade'

server.listen config.port
console.log "Listening on port #{config.port}"

module.exports = server
