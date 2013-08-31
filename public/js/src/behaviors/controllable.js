define([
    'events'
], function(Events) {
    "use strict";

    var Controllable = function() {
        _.extend(this, Events);

        this.domEvents = {
            'keydown': this.handleKey,
            'keyup': this.handleKey
        };
        this.attachedDomEvents = {};
    };

    Controllable.prototype.destroy = function() {
        return this.toggleDomEvents(false);
    };

    Controllable.prototype.toggleDomEvents = function(toAttach) {
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

    Controllable.prototype.handleKey = function(e) {
        var key = e.keyIdentifier;
        if (!_.contains([ 'Up', 'Right', 'Down', 'Left' ], key)) { return; }

        this.trigger('shift', {
            axis: +_.contains([ 'Up', 'Down' ], key),
            isPositive: _.contains([ 'Down', 'Right' ], key),
            toStop: 'keyup' == e.type
        });

        return this;
    };

    return Controllable;
});
