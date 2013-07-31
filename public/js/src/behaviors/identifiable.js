define([
], function() {
    "use strict";

    var Ship = function(socket) {
        this.socket = socket;
    };

    Ship.prototype.identify = function(idStorageKey) {
        this.id = window.localStorage.getItem(idStorageKey);

        this.socket.emit('identify', { id: this.id });

        var self = this;
        this.socket.on('register', function(data) {
            self.id = data.id;
            window.localStorage.setItem(idStorageKey, self.id);
        });

        return this;
    };

    return Ship;
});
