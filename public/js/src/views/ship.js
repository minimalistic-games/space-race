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

        this.color = [ 0, 0, 0 ];
        this.opacity = 1;

        this.preset();
    };

    ShipView.prototype.preset = function() {
        this.ctx.textAlign = 'end';
        this.ctx.font = "12px sans-serif";

        return this;
    };

    ShipView.prototype.applyColor = function(color, opacity) {
        this.color = color;
        this.opacity = opacity;

        this.ctx.fillStyle = 'rgba(' + color.join(',') + ',' + opacity + ')';

        return this;
    };

    ShipView.prototype.text = function(coords, text) {
        this.ctx.fillText(text, coords[0] + 10, coords[1] + 10);

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

    ShipView.prototype.showBulletsInQueue = function(coords, number) {
        var color = this.color,
            opacity = this.opacity;

        this
            .applyColor([ 255, 255, 255 ], 0.4)
            .text(coords, number || '')
            .applyColor(color, opacity);

        return this;
    };

    return ShipView;
});
