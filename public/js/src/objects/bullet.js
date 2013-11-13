define([
    'behaviors/beating'
], function(Beating) {
    "use strict";

    var Bullet = function(ctx, coords, direction, options) {
        this.ctx = ctx;
        this.coords = coords;
        this.direction = direction;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.6,
            radius: 8,
            step: 2,
            stepTreshold: 32
        }, options);

        this.radius = this.options.radius;
        this.step = this.options.step;
        this.opacity = this.options.opacity;

        _.extend(this, new Beating());

        this
            .initEvents()
            .runBeating(10);
    };

    Bullet.prototype.render = function() {
        this.ctx.fillStyle = 'rgba(' + this.options.color.join(',') + ',' + this.opacity + ')';

        this.ctx.beginPath();
        this.ctx.arc(
            this.coords[0],
            this.coords[1],
            this.radius,
            0,
            Math.PI * 2,
            true
        );
        this.ctx.fill();

        return this;
    };

    Bullet.prototype.shift = function() {
        var axis = +_.contains([ 'up', 'down' ], this.direction),
            isPositive = +_.contains([ 'right', 'down' ], this.direction);

        this.coords[axis] += this.step * (isPositive ? 1 : -1);

        return this;
    };

    Bullet.prototype.speadUp = function() {
        this.step *= 1.05;

        if (this.options.stepTreshold < this.step) {
            this.trigger('stepTreshold');
        }

        return this;
    };

    Bullet.prototype.slowDown = function() {
        this.step /= 2;

        if (this.options.step > this.step) {
            this.trigger('stop');
        }

        return this;
    };

    Bullet.prototype.blowUp = function() {
        this.radius *= 1.04;

        return this;
    };

    Bullet.prototype.fadeOut = function() {
        this.opacity -= 0.01;

        return this;
    };

    Bullet.prototype.initEvents = function() {
        this.on('beat', this.shift);
        this.on('beat', this.speadUp);
        this.on('beat', this.blowUp);
        this.on('beat', this.fadeOut);

        this.on('stepTreshold', function() {
            this.off('beat', this.speadUp);
            this.on('beat', this.slowDown);
        });

        this.on('stop', function() {
            this.off('beat', this.slowDown);
        });

        return this;
    };

    return Bullet;
});
