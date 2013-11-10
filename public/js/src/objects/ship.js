define([
    'events',
    'views/ship',
    'objects/bullet'
], function(Events, ShipView, Bullet) {
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
            movingStep: 4,
            resizingStep: 2
        }, options);

        this.id = null;

        /*
         * coords of object's center
         */
        this.coords = this.options.coords;

        /*
         * diameter [px]
         */
        this.size = this.options.size;

        /*
         * [ red, green, blue ]
         */
        this.color = this.options.color;

        /*
         * time interval for running inner events [ms]
         */
        this.interval = 10;

        this.moveIntervalDirections = { up: null, down: null, left: null, right: null };

        this.shieldDirections = { up: false, down: false, left: false, right: false };

        this.bulletsLimit = 100;

        /*
         * number of bullets in queue
         * ship can't produce more bullets than this.bulletsLimit
         */
        this.bulletsInQueue = 0;

        /*
         * registry of bullets that a fired currently
         */
        this.bullets = [];

        this
            .initEvents()
            .runBeating();
    };

    Ship.prototype.render = function() {
        /*
         * draw both static and dynamic bodies
         */
        this.view
            .applyColor(this.color, this.options.opacity)
            .drawBody(this.coords, this.options.size / Math.sqrt(2))
            .drawBody(this.coords, this.size / Math.sqrt(2));

        /*
         * draw a front arc for each moving direction
         */
        for (var moveDirection in this.moveIntervalDirections) {
            if (this.moveIntervalDirections[moveDirection]) {
                this.view.drawFrontArc(this.coords, this.size / 2, Math.PI * 0.4, moveDirection);
            }
        }

        /*
         * draw shields (directions are set on turning shields on)
         */
        for (var shieldDirection in this.shieldDirections) {
            if (this.shieldDirections[shieldDirection]) {
                this.view.drawFrontArc(this.coords, this.size * 0.8, Math.PI * 0.7, shieldDirection);
            }
        }

        this.view.showBulletsInQueue(this.coords, this.bulletsInQueue);

        return this.trigger('render');
    };

    Ship.prototype.runBeating = function() {
        var self = this;
        window.setInterval(function() {
            self.trigger('beat');
        }, this.interval);

        return this;
    };

    Ship.prototype.move = function(coords) {
        this.coords = coords;

        return this.trigger('move', { coords: this.coords });
    };

    Ship.prototype.shift = function(axis, isPositive) {
        var coords = this.coords;
        coords[axis] += this.options.movingStep * (isPositive ? 1 : -1);

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

        return this;
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

    Ship.prototype.resize = function() {
        if (!this.isMoving()) {
            if (this.size > this.options.size) {
                this.size -= this.options.resizingStep * 2;
            }
        } else if (this.size < this.options.size * 4) {
            this.size += this.options.resizingStep;
        }

        return this;
    };

    Ship.prototype.queueBullet = function() {
        if (this.bulletsInQueue < this.bulletsLimit) {
            this.bulletsInQueue++;
        }

        return this;
    };

    Ship.prototype.shot = function() {
        for (var direction in this.moveIntervalDirections) {
            if (!this.moveIntervalDirections[direction]) { continue; }

            if (!this.bulletsInQueue) { continue; }

            this.bulletsInQueue--;
            this.bullets.push(new Bullet(this.view.ctx, this.coords, direction));
        }

        return this.trigger('shot');
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

        this.on('beat', this.resize);

        this.on('shield', function(data) {
            this.toggleShield(!data.toStop);
        });

        this.on('weapon', function(data) {
            /*
             * start/stop charging a gun
             */
            this[data.toFire ? 'off' : 'on']('beat', this.queueBullet);

            if (data.toFire) {
                /*
                 * fire all bullets, one at a time
                 */
                this.on('beat', this.shot);
                // console.log('fire starts');
            }
        });

        this.on('shot', function() {
            if (this.bulletsInQueue <= 0) {
                this.off('beat', this.shot);
                // console.log('fire stops');
            }
        });

        this.on('render', function() {
            _.each(this.bullets, function(bullet) {
                bullet.render();
            });
        });

        return this;
    };

    return Ship;
});
