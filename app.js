var express = require('express'),
    app = express(),
    server = require('http').createServer(app),
    io = require('socket.io').listen(server);


app.use(express.compress());

app.use(express.static(__dirname + '/public'));

app.use(express.logger());

app.get('/', function(req, res){
    res.sendfile(__dirname + '/public/index.html');
});

io.sockets.on('connection', function (socket) {
    socket.emit('news', { hello: 'world' });
    socket.on('my other event', function (data) {
        console.log(data);
    });
});

server.listen(3000);
console.log('Listening on port 3000');
