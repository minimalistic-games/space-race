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
        this.coords = this.options.coords;

        this.size = this.options.size;

        this.color = this.options.color;

        this.direction = 'up';

        this.moveIntervalIds = { up: null, down: null, left: null, right: null };

        this.initEvents();
    };

    Ship.prototype.render = function() {
        var rectWidth = this.size / Math.sqrt(2),
            directionAngles = {
                right: 0,
                up: - Math.PI * 0.5,
                left: - Math.PI,
                down: - Math.PI * 1.5
            },
            frontAngle = Math.PI * 0.4 + this.size * this.size / 10000,
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

    Ship.prototype.changeColor = function() {
        _.each(this.color, function(value, index) {
            var randomSign = Math.round(Math.random() * 2) - 1;
            this.color[index] = Math.min(100, this.color[index] + randomSign * 40);
        }, this);
    };

    Ship.prototype.initEvents = function() {
        this.on('shift', function(data) {
            var direction = [
                [ 'left' , 'right' ],
                [ 'up' , 'down' ]
            ] [data.axis][+data.isPositive];

            if (data.toStop) {
                window.clearInterval(this.moveIntervalIds[direction]);
                this.moveIntervalIds[direction] = null;
                return;
            }

            this.direction = direction;

            /*
             * skipping an event if ship is already moving in current direction
             */
            if (this.moveIntervalIds[direction]) { return; }

            var self = this;
            this.moveIntervalIds[direction] = window.setInterval(function() {
                var coords = self.coords;
                coords[data.axis] += self.options.step * (data.isPositive ? 1 : -1);
                self.move(coords);
            }, 20);
        });

        this.on('render', function() {
            if (this.size > this.options.size) {
                this.size -= 2;
            }
        });

        this.on('move', function() {
            this.size += 4;
        });

        return this;
    };

    return Ship;
});
