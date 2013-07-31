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
        this.id = window.localStorage.getItem(idStorageKey);

        this.socket.emit('identify', { id: this.id });

        var self = this;
        this.socket.on('register', function(data) {
            self.id = data.id;
            window.localStorage.setItem(idStorageKey, self.id);
        });

        return this;
    };

    return Identifiable;
});
