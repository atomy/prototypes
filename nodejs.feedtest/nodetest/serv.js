var io = require('socket.io').listen(8080);

io.sockets.on('connection', function (socket) {
  socket.on('test', function (data) {
      socket.emit('testSuccess');
      socket.broadcast.emit('test', { msg: data.msg, user: data.user });

      console.log(data);
  });
});