var _ = require('underscore');

var Registry = function(objectType) {
    this.objectType = objectType;
    this.collection = {};
};

Registry.prototype.create = function() {
    var id = this.nextId(),
        object = new this.objectType(id);

    this.collection[id] = object;

    return object;
};

Registry.prototype.nextId = function() {
    var ids = _.map(
        _.keys(this.collection),
        function(id) { return parseInt(id, 10); }
    );

    return !ids.length ? 1 : _.max(ids) + 1;
};

Registry.prototype.get = function(id) {
    return this.collection[id];
};

Registry.prototype.all = function() {
    return this.collection;
};

Registry.prototype.remove = function(id) {
    this.collection = _.omit(this.collection, id.toString());

    return this;
};

module.exports = Registry;
