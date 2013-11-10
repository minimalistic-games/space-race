define([
], function() {
    "use strict";

    var Beating = function() {
        _.extend(this, Backbone.Events);
    };

    Beating.prototype.runBeating = function(interval) {
        var self = this;
        window.setInterval(function() {
            self.trigger('beat');
        }, interval);

        return this;
    };

    return Beating;
});
