var express = require('express'),
    app = express(),
    server = require('http').createServer(app),
    config = require('./config/server');

app.use(express.compress());
app.use(express.logger());
app.use(express.static(__dirname + '/../public'));

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/../public/index.html');
});

server.listen(config.port);
console.log('Listening on port ' + config.port);

module.exports = server;
