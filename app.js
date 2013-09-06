var _ = require('underscore'),
    express = require('express'),
    app = express(),
    server = require('http').createServer(app),
    io = require('socket.io').listen(server);

app.use(express.compress());

app.use(express.static(__dirname + '/public'));

app.use(express.logger());

app.get('/', function(req, res) {
    res.sendfile(__dirname + '/public/index.html');
});

var Ship = function(id) {
    this.id = id;

    this.coords = [ 200, 200 ];
    this.isActive = true;
};

Ship.prototype.move = function(coords) {
    this.coords = coords;

    return this;
}

Ship.prototype.toClientData = function() {
    return {
        id: this.id,
        coords: this.coords
    };
};

/*
 * ships registry { id: Ship }
 */
var ships = {};

io.sockets.on('connection', function(socket) {
    var id = null;

    socket.on('identify', function(data) {
        id = data.id || _.max(_.keys(ships)) + 1;

        var ship = ships[id];

        if (!ship) {
            ship = new Ship(id);
            ships[id] = ship;
        }

        ship.isActive = true;

        socket.emit('register', ship.toClientData());

        socket.broadcast.emit('create', ship.toClientData());

        _.each(ships, function(ship) {
            if (id != ship.id && ship.isActive) {
                socket.emit('create', ship.toClientData());
            }
        });
    });

    socket.on('disconnect', function() {
        ships[id].isActive = false;

        socket.broadcast.emit('remove', { id: id });
    });

    socket.on('shift', function(data) {
        socket.broadcast.emit('shift', _.extend(data, { id: id }));
    });

    socket.on('move', function(data) {
        ships[id].move(data.coords);
    });
});

server.listen(3000);
console.log('Listening on port 3000');
