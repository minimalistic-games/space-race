define([
    'events',
], function(Events) {
    "use strict";

    var Bullet = function(ctx, coords, directions, options) {
        _.extend(this, Events);

        this.coords = this.coords;

        this.directions = this.directions;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.4,
            size: 40,
            movingStep: 4,
        }, options);

        this.size = this.options.size;

        this.color = this.options.color;

        console.log(directions);
        console.log(coords);
    };

    Bullet.prototype.render = function() {

    };

    return Bullet;
});
