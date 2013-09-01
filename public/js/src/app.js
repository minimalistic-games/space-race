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
     * Creates one controlled ship and canvas bounds
     */
    App.prototype.addInitialObjects = function() {
        var ship = new Ship(this.ctx, { color: [ 50, 50, 250 ] });

        _.extend(ship, new Controllable(), new Identifiable(this.socket));

        ship
            .toggleDomEvents(true)
            .identify('controlledShip:id')
            .on('register', function(data) {
                ship.id = data.id;
                ship.coords = data.coords;

                this.objects.controlledShip = ship;
            }, this)
            .on('shift', function(data) {
                /*
                 * notifying server about shifting
                 * using NOT "move" but "shift", because only "shift" event comes with comprehensive data
                 */
                this.socket.emit('shift', _.extend(data, { id: ship.id }));
            }, this)
            .on('shift', function(data) {
                if (data.toStop) {
                    ship.changeColor();
                }
            });

        this.objects.bounds = new Bounds(this.ctx, {
            color: [ 100, 150, 200 ],
            width: 10
        });

        return this;
    };

    /**
     * Initializes event listeners
     */
    App.prototype.initEvents = function() {
        var self = this;

        /*
         * handling creation of other ships
         */
        this.socket.on('create', function(data) {
            var ship = new Ship(self.ctx, {
                color: [ 200, 100, 100 ],
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
