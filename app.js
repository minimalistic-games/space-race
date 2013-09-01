var _ = require('underscore'),
    express = require('express'),
    app = express(),
    server = require('http').createServer(app),
    io = require('socket.io').listen(server);

app.use(express.compress());

app.use(express.static(__dirname + '/public'));

app.use(express.logger());

app.get('/', function(req, res){
    res.sendfile(__dirname + '/public/index.html');
});

var Ship = function(id, coords) {
    this.id = id;
    this.coords = coords || [ 200, 200 ];
};

/*
 * ships registry { id: Ship }
 */
var ships = {};

io.sockets.on('connection', function(socket) {
    var id = null;

    socket.on('identify', function(data) {
        id = data.id || _.max(_.keys(ships)) + 1;

        var ship = new Ship(id, data.coords);

        ships[id] = ship;

        socket.emit('register', ship);

        socket.broadcast.emit('create', ship);

        _.each(ships, function(ship) {
            if (id != ship.id) {
                socket.emit('create', ship);
            }
        });
    });

    socket.on('disconnect', function() {
        delete ships[id];

        socket.broadcast.emit('remove', { id: id });
    });

    socket.on('shift', function(data) {
        socket.broadcast.emit('shift', data);
    });
});

server.listen(3000);
console.log('Listening on port 3000');
