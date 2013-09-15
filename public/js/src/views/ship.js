define([
], function() {
    "use strict";

    var ShipView = function(ctx) {
        this.ctx = ctx;

        this.directionAngles = {
            right: 0,
            up: - Math.PI * 0.5,
            left: - Math.PI,
            down: - Math.PI * 1.5
        };
    };

    ShipView.prototype.setColor = function(color, opacity) {
        this.ctx.fillStyle = 'rgba(' + color.join(',') + ',' + opacity + ')';

        return this;
    };

    ShipView.prototype.getRectCoord = function(coord, size) {
        return coord - size / 2;
    };

    ShipView.prototype.drawBody = function(coords, width) {
        this.ctx.fillRect(
            this.getRectCoord(coords[0], width),
            this.getRectCoord(coords[1], width),
            width,
            width
        );

        return this;
    };

    ShipView.prototype.drawFrontArc = function(coords, radius, angle, direction) {
        this.ctx.beginPath();
        this.ctx.arc(
            coords[0],
            coords[1],
            radius,
            angle / 2 + this.directionAngles[direction],
            - angle / 2 + this.directionAngles[direction],
            true
        );
        this.ctx.fill();

        return this;
    };

    return ShipView;
});
