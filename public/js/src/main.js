require.config({
    baseUrl: 'js/src',
    paths: {
        underscore: '../bower_components/underscore/underscore-min'
    },
    shim: {
        underscore: {
            exports: '_'
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
