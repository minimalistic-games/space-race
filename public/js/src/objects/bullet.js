define([
], function() {
    "use strict";

    var Bullet = function(ctx, coords, direction, options) {
        _.extend(this, Backbone.Events);

        this.coords = coords;
        this.direction = direction;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.4,
            size: 40,
            movingStep: 4,
        }, options);

        this.size = this.options.size;
        this.color = this.options.color;

        /*
         * time to live [ms]
         */
        this.ttl = 2000;
    };

    Bullet.prototype.render = function() {

    };

    return Bullet;
});
