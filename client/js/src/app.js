define([
    'underscore',
    'socketio'
], function(_, io) {
    var canvas = document.getElementById('canvas');

    if (!canvas.getContext) {
        document.body.innerText = canvas.innerHTML;
        return function() {};
    }

    var App = function() {
        this.ctx = canvas.getContext('2d');
    };

    App.prototype.clear = function() {
        this.ctx.clearRect(0, 0, canvas.width, canvas.height);
    };

    return App;
});