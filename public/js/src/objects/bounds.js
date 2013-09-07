define([
], function() {
    "use strict";

    var Bounds = function(ctx, options) {
        this.ctx = ctx;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.4,
            thickness: 2
        }, options);

        this.width = this.ctx.canvas.width;
        this.height = this.ctx.canvas.height;

        this.thickness = this.options.thickness;
    };

    Bounds.prototype.render = function() {
        this.ctx.strokeStyle = 'rgba(' + this.options.color.join(',') + ',' + this.options.opacity + ')';

        this.ctx.lineWidth = this.thickness;
        this.ctx.strokeRect(
            this.thickness/2,
            this.thickness/2,
            this.width - this.thickness,
            this.height - this.thickness
        );

        return this;
    };

    return Bounds;
});
