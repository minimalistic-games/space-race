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

        this.id = window.localStorage.getItem('ship:id');

        /*
         * coords of object's center
         */
        this.coords = [ this.options.coords[0], this.options.coords[1] ];

        this.size = this.options.size;

        this.direction = 'Up';

        this.socket = null;

        this.domEvents = {
            'keydown': this.handleKeyDown
        };
        this.attachedDomEvents = {};

        this.toggleDomEvents(true);
    };

    Ship.prototype.destroy = function() {
        return this.toggleDomEvents(false);
    };

	Ship.prototype.toggleDomEvents = function(toAttach) {
        var self = this;
		_.each(this.domEvents, function(handler, type) {
            /*
             * storing binded event handlers to be able to detach them by reference
             */
            if (toAttach) {
                self.attachedDomEvents[type] = function(e) { return handler.call(self, e); };
            }

			document[toAttach ? 'addEventListener' : 'removeEventListener'](type, self.attachedDomEvents[type], false);
		});

        return this;
	};

    Ship.prototype.setSocket = function(socket) {
        this.socket = socket;

        return this;
    };

    Ship.prototype.identify = function() {
        var self = this;

        this.socket.emit('identify', { id: self.id });

        this.socket.on('register', function(data) {
            self.id = data.id;

            window.localStorage.setItem('ship:id', self.id);
        });

        return this;
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
        // this.ctx.stroke();
        this.ctx.fill();

        return this;
    };

	Ship.prototype.handleKeyDown = function(e) {
        var key = e.keyIdentifier;
        if (!_.contains([ 'Up', 'Right', 'Down', 'Left' ], key)) { return; }

        var axis = +_.contains([ 'Up', 'Down' ], key),
            shiftCoord = function(coord, step, isPositive) {
                return isPositive ? coord + step : coord - step;
            };

        this.direction = key;

        this.coords[axis] = shiftCoord(this.coords[axis], this.options.step, _.contains([ 'Down', 'Right' ], key));

        if (this.socket) {
            this.socket.emit('move', {
                id: this.id,
                coords: this.coords
            });
        }

        return this;
	};

	return Ship;
});
