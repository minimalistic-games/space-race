define([
    'underscore',
    'objects/ship'
], function(_, Ship) {
    "use strict";

    var canvas = document.getElementById('canvas');

    if (!canvas.getContext) {
        document.body.innerText = canvas.innerHTML;
        return function() {};
    }

    /*
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

    /*
     * Starts application
     */
    App.prototype.init = function() {
        this
            .addInitialObjects()
            .startDrawingLoop();

        return this;
    };

    /*
     * Creates one controlled ship
     */
    App.prototype.addInitialObjects = function() {
        var ship = new Ship(this.ctx, {
            color: [ 50, 50, 250 ]
        });

        ship
            .setSocket(this.socket)
            .identify();

        this.objects.controlledShip = ship;

        return this;
    };

    /*
     * Clears the whole canvas
     */
    App.prototype.clear = function() {
        this.ctx.clearRect(0, 0, canvas.width, canvas.height);

        return this;
    };

    /*
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
