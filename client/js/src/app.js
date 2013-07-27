define([
    'underscore',
    'socketio',
    'objects/ship'
], function(_, io, Ship) {
    var canvas = document.getElementById('canvas');

    if (!canvas.getContext) {
        document.body.innerText = canvas.innerHTML;
        return function() {};
    }

    /*
     * Global application object. Responsible for canvas handling.
     */
    var App = function() {
        this.ctx = canvas.getContext('2d');
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
        var ship = new Ship(this.ctx, {
            color: [ 50, 50, 250 ]
        });
        ship.render();

        window.ship = ship;

        return this;
    };

    return App;
});
