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
     * Global application object. Responsible for canvas handling.
     */
    var App = function() {
        /*
         * canvas context
         */
        this.ctx = canvas.getContext('2d');

        /*
         * global objects registry
         */
        this.objects = {};
    };

    /*
     * Clears the whole canvas
     */
    App.prototype.clear = function() {
        this.ctx.clearRect(0, 0, canvas.width, canvas.height);

        return this;
    };

    /*
     * Starts application
     */
    App.prototype.init = function() {
        this.objects = {
            ship1: new Ship(this.ctx, {
                color: [ 50, 50, 250 ]
            }),
            ship2: new Ship(this.ctx, {
                color: [ 250, 50, 50 ],
                coords: [ 150, 150 ],
                step: 1,
                size: 40
            })
        };

        var self = this,
            draw = function() {
                window.requestAnimationFrame(draw);

                self.clear();
                _.each(self.objects, function(object) {
                    object.render();
                });
            };


        window.requestAnimationFrame(draw);

        var socket = io.connect('http://' + window.location.host);
        this.objects.ship1.setSocket(socket);

        return this;
    };

    return App;
});
