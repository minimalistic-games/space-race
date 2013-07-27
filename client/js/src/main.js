require.config({
    baseUrl: 'js/src',
    paths: {
        underscore: '../bower_components/underscore/underscore-min',
        socketio: '../bower_components/socket.io-client/lib/socket.io-client'
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
    var app = new App();
    app.init();

    /*
     * storing app reference for debug
     */
    window.app = app;
});
