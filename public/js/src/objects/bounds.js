define([
    'events'
], function(Events) {
    "use strict";

    var Bounds = function(ctx, options) {
        _.extend(this, Events);

        this.ctx = ctx;

        this.options = _.extend({
            color: [ 0, 0, 0 ],
            opacity: 0.4,
            width: 2
        }, options);

        this.width = this.ctx.canvas.width;
        this.height = this.ctx.canvas.height;
    };

    Bounds.prototype.render = function() {
        this.ctx.strokeStyle = 'rgba(' + this.options.color.join(',') + ',' + this.options.opacity + ')';

        this.ctx.lineWidth = this.options.width;
        this.ctx.strokeRect(0, 0, this.width, this.height);

        return this;
    };

    return Bounds;
});
