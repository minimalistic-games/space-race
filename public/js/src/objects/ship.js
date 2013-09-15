define([
    'events',
    'views/ship'
], function(Events, ShipView) {
    "use strict";

    var Ship = function(ctx, bounds, options) {
        _.extend(this, Events);

        this.view = new ShipView(ctx);

        this.bounds = bounds;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.4,
            coords: [ 100, 100 ],
            size: 40,
            step: 4
        }, options);

        this.id = null;

        /*
         * coords of object's center
         */
        this.coords = this.options.coords;

        this.size = this.options.size;

        this.color = this.options.color;

        /*
         * time interval for performing moves, ms
         */
        this.interval = 20;

        this.moveIntervalDirections = { up: null, down: null, left: null, right: null };

        this.shieldDirections = { up: false, down: false, left: false, right: false };

        this.initEvents();

        var self = this;
        window.setInterval(function() {
            self.trigger('beat');
        }, this.interval);
    };

    Ship.prototype.render = function() {
        this.view
            .setColor(this.color, this.options.opacity)
            .drawBody(this.coords, this.options.size / Math.sqrt(2))
            .drawBody(this.coords, this.size / Math.sqrt(2));

        for (var moveDirection in this.moveIntervalDirections) {
            if (this.moveIntervalDirections[moveDirection]) {
                this.view.drawFrontArc(this.coords, this.size / 2, Math.PI * 0.4, moveDirection);
            }
        }

        for (var shieldDirection in this.shieldDirections) {
            if (this.shieldDirections[shieldDirection]) {
                this.view.drawFrontArc(this.coords, this.size * 0.8, Math.PI * 0.7, shieldDirection);
            }
        }

        return this;
    };

    Ship.prototype.move = function(coords) {
        this.coords = coords;

        this.trigger('move', { coords: this.coords });

        return this;
    };

    Ship.prototype.shift = function(axis, isPositive) {
        var coords = this.coords;
        coords[axis] += this.options.step * (isPositive ? 1 : -1);

        return this.move(coords);
    };

    Ship.prototype.isMoving = function() {
        for (var direction in this.moveIntervalDirections) {
            if (this.moveIntervalDirections[direction]) {
                return true;
            }
        }

        return false;
    };

    Ship.prototype.changeColor = function() {
        _.each(this.color, function(value, index) {
            var randomSign = Math.round(Math.random() * 2) - 1;
            this.color[index] = Math.min(100, this.color[index] + randomSign * 10);
        }, this);
    };

    Ship.prototype.isFacingBound = function(direction) {
        var radius = this.options.size / 2;

        switch (direction) {
            case 'left':
                return this.coords[0] <= radius + this.bounds.thickness;
            case 'right':
                return this.coords[0] >= this.bounds.width - radius - this.bounds.thickness;
            case 'up':
                return this.coords[1] <= radius + this.bounds.thickness;
            case 'down':
                return this.coords[1] >= this.bounds.height - radius - this.bounds.thickness;
        }
    };

    Ship.prototype.toggleShield = function(toProceed) {
        for (var direction in this.shieldDirections) {
            if (!toProceed) {
                this.shieldDirections[direction] = false;
                continue;
            }

            if (this.shieldDirections[direction]) {
                continue;
            }

            /*
             * A shield can be activated only while moving along current directions
             */
            this.shieldDirections[direction] = !!this.moveIntervalDirections[direction];
        }

        return this;
    };

    Ship.prototype.initEvents = function() {
        this.on('shift', function(data) {
            var direction = [
                [ 'left' , 'right' ],
                [ 'up' , 'down' ]
            ] [data.axis][+data.isPositive];

            if (data.toStop) {
                window.clearInterval(this.moveIntervalDirections[direction]);
                this.moveIntervalDirections[direction] = null;

                if (!this.isMoving()) {
                    this.trigger('stop');
                }

                return;
            }

            /*
             * skipping an event if ship is already moving in current direction
             */
            if (this.moveIntervalDirections[direction]) { return; }

            var self = this;
            this.moveIntervalDirections[direction] = window.setInterval(function() {
                /*
                 * skipping a move if ship is facing a bound in current direction
                 */
                if (!self.isFacingBound(direction)) {
                    self.shift(data.axis, data.isPositive);
                }
            }, this.interval);
        });

        this.on('beat', function() {
            if (!this.isMoving()) {
                if (this.size > this.options.size) {
                    this.size -= 2;
                }
            } else if (this.size < this.options.size * 4) {
                this.size += 4;
            }
        });

        this.on('shield', function(data) {
            this.toggleShield(!data.toStop);
        });

        return this;
    };

    return Ship;
});
