require.config({
    baseUrl: 'js/src',
    paths: {
        underscore: '../bower_components/underscore/underscore-min',
        events: 'backbone-events/backbone-events'
    },
    shim: {
        underscore: {
            exports: '_'
        },
        events: {
            deps: [ 'underscore' ],
            exports: 'Events'
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
