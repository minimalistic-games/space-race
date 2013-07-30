var express = require('express'),
    app = express(),
    server = require('http').createServer(app),
    io = require('socket.io').listen(server);

app.use(express.compress());

app.use(express.static(__dirname + '/public'));

app.use(express.logger());

app.get('/', function(req, res){
    res.sendfile(__dirname + '/public/index.html');
});

var idCounter = 1;

io.sockets.on('connection', function (socket) {
    socket.on('identify', function (data) {
        socket.emit('register', {
            id: data.id ? data.id : idCounter++
        });
    });

    socket.on('move', function (data) {
        console.log(data);
    });
});

server.listen(3000);
console.log('Listening on port 3000');
