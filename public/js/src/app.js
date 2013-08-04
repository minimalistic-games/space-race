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
            .startDrawingLoop();

        return this;
    };

    /**
     * Creates one controlled ship
     */
    App.prototype.addInitialObjects = function() {
        var bounds = new Bounds(this.ctx, { color: [ 100, 150, 200 ], width: 10 }),
            ship = new Ship(this.ctx, { color: [ 50, 50, 250 ], size: 40 }),
            controllable = new Controllable(),
            identifiable = new Identifiable(this.socket);

        _.extend(ship, controllable, identifiable);

        ship
            .toggleDomEvents(true)
            .identify('controlledShip:id')
            .on('move', function(data) {
                this.socket.emit('move', {
                    id: this.id,
                    coords: data.coords
                });
            }, ship);

        this.objects.bounds = bounds;

        this.objects.controlledShip = ship;

        this.objects.uncontrolledShip = new Ship(this.ctx, {
            coords: [ 200, 200 ],
            color: [ 200, 100, 100 ],
            size: 20
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
