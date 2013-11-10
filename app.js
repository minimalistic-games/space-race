var _ = require('underscore'),
    server = require('./server/server'),
    io = require('socket.io').listen(server),
    Ship = require('./server/objects/ship'),
    Registry = require('./server/objects/registry');

var registry = new Registry(Ship);

io.sockets.on('connection', function(socket) {
    var id = null;

    socket.on('identify', function(data) {
        id = data.id;

        var ship = registry.get(id);

        if (!ship) {
            ship = registry.create();
            id = ship.id;
        }

        socket.emit('register', ship.toClientData());

        socket.broadcast.emit('create', ship.toClientData());

        _.each(
            _.without(registry.all(), ship),
            function(otherShip) {
                socket.emit('create', otherShip.toClientData());
            }
        );
    });

    socket.on('disconnect', function() {
        if (!id) { return; }

        registry.remove(id);

        socket.broadcast.emit('remove', { id: id });
    });

    socket.on('shift', function(data) {
        if (!id) { return; }

        socket.broadcast.emit('shift', _.extend(data, { id: id }));
    });

    socket.on('move', function(data) {
        if (!id) { return; }

        registry.get(id)
            .move(data.coords);
    });
});
