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
            .initEvents()
            .startDrawingLoop();

        return this;
    };

    /**
     * Creates one controlled ship
     */
    App.prototype.addInitialObjects = function() {
        var bounds = new Bounds(this.ctx, { color: [ 100, 150, 200 ], width: 10 }),
            ship = new Ship(this.ctx, { color: [ 50, 50, 250 ] }),
            controllable = new Controllable(),
            identifiable = new Identifiable(this.socket);

        _.extend(ship, controllable, identifiable);

        ship
            .toggleDomEvents(true)
            .identify('controlledShip:id');

        this.objects = {
            bounds: bounds,
            controlledShip: ship
        };

        return this;
    };

    /**
     * Initializes event listeners
     */
    App.prototype.initEvents = function() {
        var self = this;

        this.objects.controlledShip.on('shift', function(data) {
            this.socket.emit('shift', _.extend(data, { id: this.id }));
        }, this.objects.controlledShip);

        this.socket.on('create', function(data) {
            var ship = new Ship(self.ctx, {
                color: [ 200, 100, 100 ]
            });

            ship.id = data.id;

            self.objects['ship:' + ship.id] = ship;
        });

        this.socket.on('remove', function(data) {
            delete self.objects['ship:' + data.id];
        });

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
