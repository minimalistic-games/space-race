define([
], function() {
	var Ship = function(ctx, options) {
        this.ctx = ctx;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.4,
            coords: [ 100, 100 ],
            size: 20,
            step: 5
        }, options);

        this.coords = [ this.options.coords[0], this.options.coords[1] ];

        this.domEvents = {
            'keydown': this.handleKeyDown
        };
        this.toggleDomEvents(true);
    };

    Ship.prototype.destroy = function() {
        return this.toggleDomEvents(false);
    };

	Ship.prototype.toggleDomEvents = function(toAttach) {
        var self = this;
		_.each(this.domEvents, function(handler, type) {
			document[toAttach ? 'addEventListener' : 'removeEventListener'](type, function(e) {
                handler.call(self, e);
            }, false);
		});

        return this;
	};

    Ship.prototype.render = function() {
        var getRectCoord = function(coord, size) { return coord - size / 2; };

        this.ctx.fillStyle = 'rgba(' + this.options.color.join(',') + ',' + this.options.opacity + ')';
        this.ctx.fillRect(
            getRectCoord(this.coords[0], this.options.size),
            getRectCoord(this.coords[1], this.options.size),
            this.options.size,
            this.options.size
        );

        return this;
    };

	Ship.prototype.handleKeyDown = function(e) {
        var key = e.keyIdentifier;
        if (!_.contains([ 'Up', 'Right', 'Down', 'Left' ], key)) { return; }

        if ('Up' == key) {
            this.coords[1] = this.coords[1] - this.options.step;
        }

        this.render();
	};

	return Ship;
});
