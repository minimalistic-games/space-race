define([
], function() {
    "use strict";

    var Ship = function(ctx, options) {
        this.ctx = ctx;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.4,
            coords: [ 100, 100 ],
            size: 20,
            step: 5
        }, options);

        this.id = null;

        /*
         * coords of object's center
         */
        this.coords = [ this.options.coords[0], this.options.coords[1] ];

        this.size = this.options.size;

        this.direction = 'Up';
    };

    Ship.prototype.render = function() {
        var getRectCoord = function(coord, size) { return coord - size / 2; },
            directionAngles = {
                Right: 0,
                Up: - Math.PI * 0.5,
                Left: - Math.PI,
                Down: - Math.PI * 1.5
            },
            arcStartAngle = Math.PI * 0.2;

        this.ctx.fillStyle = 'rgba(' + this.options.color.join(',') + ',' + this.options.opacity + ')';

        this.ctx.fillRect(
            getRectCoord(this.coords[0], this.size),
            getRectCoord(this.coords[1], this.size),
            this.size,
            this.size
        );

        this.ctx.beginPath();
        this.ctx.arc(
            this.coords[0],
            this.coords[1],
            this.size,
            arcStartAngle + directionAngles[this.direction],
            - arcStartAngle + directionAngles[this.direction],
            true
        );
        this.ctx.fill();

        return this;
    };

    Ship.prototype.initEvents = function() {
        var shiftCoord = function(coord, step, isPositive) {
            return isPositive ? coord + step : coord - step;
        };

        this.on('shift', function(data) {
            this.direction = [ [ 'Left' , 'Right' ], [ 'Up' , 'Down' ] ] [data.axis][+data.isPositive];
            this.coords[data.axis] = shiftCoord(this.coords[data.axis], this.options.step, data.isPositive);

            this.trigger('move', { coords: this.coords });
        });

        return this;
    };

    return Ship;
});
