define([
    'underscore',
    'objects/bounds',
    'objects/ship',
    'behaviors/controllable',
    'behaviors/identifiable'
], function(_, Bounds, Ship, Controllable, Identifiable) {
    "use strict";

    var canvas = document.getElementById('canvas');

    if (!canvas.getContext) {
        document.body.innerText = canvas.innerHTML;
        return function() {};
    }

    /**
     * Global application object
     */
    var App = function() {
        /*
         * canvas context
         */
        this.ctx = canvas.getContext('2d');

        /*
         * rendering objects registry
         */
        this.objects = {};

        /*
         * application state transport
         */
        this.socket = io.connect('http://' + window.location.host);
    };

    /**
     * Starts application
     */
    App.prototype.init = function() {
        this
            .addInitialObjects()
            .listenServer()
            .startDrawingLoop();

        return this;
    };

    /**
     * Creates one controlled ship and canvas bounds
     */
    App.prototype.addInitialObjects = function() {
        var bounds = new Bounds(this.ctx, {
            color: [ 100, 150, 200 ],
            thickness: 10
        });
        this.objects.bounds = bounds;

        var ship = new Ship(this.ctx, bounds, { color: [ 50, 50, 50 ] });
        _.extend(ship, new Controllable(), new Identifiable(this.socket));

        ship
            .toggleDomEvents(true)
            .identify('controlledShip:id')
            .on('register', function(data) {
                ship.id = data.id;
                ship.coords = data.coords;

                this.objects.controlledShip = ship;
            }, this)
            .on('shift', function(data) { this.socket.emit('shift', data); }, this)
            .on('stop', ship.changeColor)
            .on('move', function(data) { this.socket.emit('move', data); }, this);

        return this;
    };

    /**
     * Initializes event listeners
     */
    App.prototype.listenServer = function() {
        var self = this;

        /*
         * handling creation of other ships
         */
        this.socket.on('create', function(data) {
            var ship = new Ship(self.ctx, self.objects.bounds, {
                color: [ 100, 100, 100 ],
                coords: data.coords
            });

            ship.id = data.id;

            self.objects['ship:' + ship.id] = ship;
        });

        /*
         * removing disconnected ships
         */
        this.socket.on('remove', function(data) {
            delete self.objects['ship:' + data.id];
        });

        /*
         * handling shifts of other ships
         */
        this.socket.on('shift', function(data) {
            self.objects['ship:' + data.id].trigger('shift', data);
        });

        return this;
    };

    /**
     * Clears the whole canvas
     */
    App.prototype.clear = function() {
        this.ctx.clearRect(0, 0, canvas.width, canvas.height);

        return this;
    };

    /**
     * Redraws all registered objects after cleaning the canvas
     */
    App.prototype.startDrawingLoop = function() {
        var self = this,
            draw = function() {
                window.requestAnimationFrame(draw);

                self.clear();
                _.each(self.objects, function(object) {
                    object.render();
                });
            };

        window.requestAnimationFrame(draw);

        return this;
    };

    return App;
});
