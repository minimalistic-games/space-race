require.config({
    baseUrl: 'js/src',
    paths: {
        underscore: '../bower_components/underscore/underscore-min',
        backbone: '../bower_components/backbone/backbone',
        events: 'backbone-events/backbone-events'
    },
    shim: {
        underscore: {
            exports: '_'
        },
        backbone: {
            deps: [ 'underscore' ],
            exports: 'Backbone'
        },
        socketio: {
            exports: 'io'
        }
    }
});

require([
    'app'
], function (App) {
    "use strict";

    var app = new App();
    app.init();

    /*
     * storing app reference for debug
     */
    window.app = app;
});
