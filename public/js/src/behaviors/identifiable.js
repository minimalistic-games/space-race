define([
], function() {
    "use strict";

    var Identifiable = function(socket) {
        this.socket = socket;
    };

    /**
     * Sends the 'identify' message to server with current id (could be stored in localStorage)
     * Updates current id on 'register' message received
     *
     * @param string idStorageKey An id key for localStorage
     */
    Identifiable.prototype.identify = function(idStorageKey) {
        var id = window.localStorage.getItem(idStorageKey);

        if (id && id != parseInt(id, 10)) {
            throw new TypeError('stored id must be null or integer');
        }

        this.socket.emit('identify', { id: id });

        var self = this;
        this.socket.on('register', function(data) {
            if (data.id != parseInt(data.id, 10)) {
                throw new TypeError('retrieved id must be integer');
            }

            window.localStorage.setItem(idStorageKey, data.id);

            self.trigger('register', data);
        });

        return this;
    };

    return Identifiable;
});
