var Ship = function(id) {
    this.id = id;
    this.coords = [ 200, 200 ];
};

Ship.prototype.move = function(coords) {
    this.coords = coords;

    return this;
};

Ship.prototype.toClientData = function() {
    return {
        id: this.id,
        coords: this.coords
    };
};

module.exports = Ship;
