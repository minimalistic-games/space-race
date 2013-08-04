define([
    'events'
], function(Events) {
    "use strict";

    var Ship = function(ctx, options) {
        _.extend(this, Events);

        this.ctx = ctx;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.4,
            coords: [ 100, 100 ],
            size: 20,
            step: 4
        }, options);

        this.id = null;

        /*
         * coords of object's center
         */
        this.coords = [ this.options.coords[0], this.options.coords[1] ];

        this.size = this.options.size;

        this.color = this.options.color;

        this.direction = 'Up';

        this.initEvents();
    };

    Ship.prototype.render = function() {
        var rectWidth = this.options.size / Math.sqrt(2),
            directionAngles = {
                Right: 0,
                Up: - Math.PI * 0.5,
                Left: - Math.PI,
                Down: - Math.PI * 1.5
            },
            frontAngle = Math.PI * 0.5 + this.size * this.size / 10000,
            getRectCoord = function(coord, size) { return coord - size / 2; };

        this.ctx.fillStyle = 'rgba(' + this.color.join(',') + ',' + this.options.opacity + ')';

        this.ctx.fillRect(
            getRectCoord(this.coords[0], rectWidth),
            getRectCoord(this.coords[1], rectWidth),
            rectWidth,
            rectWidth
        );

        this.ctx.beginPath();
        this.ctx.arc(
            this.coords[0],
            this.coords[1],
            this.size / 2,
            frontAngle / 2 + directionAngles[this.direction],
            - frontAngle / 2 + directionAngles[this.direction],
            true
        );
        this.ctx.fill();

        this.trigger('render');

        return this;
    };

    Ship.prototype.move = function(coords) {
        this.coords = coords;

        this.trigger('move', { coords: this.coords });

        return this;
    };

    Ship.prototype.initEvents = function() {
        var resizingStep = 2,
            shiftCoord = function(coord, step, isPositive) {
                return isPositive ? coord + step : coord - step;
            };

        this.on('shift', function(data) {
            var coords = this.coords;
            coords[data.axis] = shiftCoord(coords[data.axis], this.options.step, data.isPositive);
            this.move(coords);

            this.direction = [ [ 'Left' , 'Right' ], [ 'Up' , 'Down' ] ] [data.axis][+data.isPositive];
        });

        this.on('render', function() {
            if (this.size > this.options.size) {
                this.size -= resizingStep;
            }
        });

        this.on('move', function() {
            this.size += resizingStep * 4;
        });

        this.on('stop', function() {
            _.each(this.color, function(value, index) {
                var randomSign = Math.round(Math.random() * 2) - 1;
                this.color[index] = Math.min(100, this.color[index] + randomSign * 40);
            }, this);
        });

        return this;
    };

    return Ship;
});
