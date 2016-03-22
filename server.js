var express = require('express');
var session = require('express-session');
var MySQLStore = require('express-mysql-session');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var favicon = require('serve-favicon');
var multer = require('multer');
var flash = require('connect-flash');
var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var mysql = require('mysql');
var async = require('async');
var React = require('react');
var Router = require('react-router');
var path = require('path-extra');
var sqlHandler = require('./app/scripts/sqlHandler');
var cookieParse = require('cookie').parse;

app.use(favicon(path.join(__dirname, 'assets','blackbooks.ico')));
app.set('port', process.env.PORT || 3000);
app.use(express.static(path.join(__dirname, 'assets')));
//app.use(bodyParser());
app.use(cookieParser('BlackBooks'));

var options = {
    host: 'localhost',
    port: 3306,
    user: 'Rui',
    password: '233',
    database: 'BlackBooks',
    useConnectionPooling: true
};

app.use(session({
  store: new MySQLStore(options),
  resave: false,
  saveUninitialized: false,
  cookie: { secure: true },
  secret: 'BlackBooks'
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(function (req, res, next) {
  if (!req.session) {
    return next(new Error('oh no')) // handle error
  }
  //console.log('next,log,cookie', req.session.cookie);
  next() // otherwise continue
})

app.get('/', function(req, res){
  if (req.session === undefined) {
    req.session.regenerate(function(err){
      console.log(err);
    });
  }
  console.log(req.session);
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.use(function (req, res, next) {
  if (!req.session) {
    return next(new Error('oh no')) // handle error
  }
  next() // otherwise continue
})


io.on('connection', function(socket) {
  console.log('a user connected');

  if(socket.name !== undefined) {
    console.log('socket.name', socket.name);
  } else {
    console.log('no socket name');
  }

  socket.on('signin', function(obj) {
    var username = obj.username,
        password = obj.password,
        tasks = [0],
        sqls = ['select * from BlackBooks.users;'],
        types = ['', '管理员', '用户'];
    sqlHandler.doWork(tasks, sqls, (function(resoult) {
      console.log(resoult);
      for (var i = 0; i < resoult[0].length; i++) {
        if (resoult[0][i].username === username) {
          if (resoult[0][i].pw === password) {
            io.emit('signin_return', {res: 1, level: resoult[0][i].level});
            socket.name = resoult[0][i].username;
            socket.password = resoult[0][i].pw;
            socket.usertype = types[resoult[0][i].level];
          } else {
            io.emit('signin_return', {res: 0, level: null});
          }
        } else {
          if (i === resoult[0].length - 1) {
            io.emit('signin_return', {res: -1, level: null});
          }
        }
      }
    }));
  });

  socket.on('logout', function() {
    socket.name = '';
    socket.password = '';
    socket.usertype = '';
  })
  socket.on('connected', function(req) {
    var username = req[0],
        password = req[1],
        usertype = req[2];
    if (usertype === 1) {
      usertype = 'Admin';
    } else {
      usertype = 'User';
    }
    console.log('connected ' + usertype + ': ', username);
    io.emit('welcome', 'welcome!  ' + usertype + ': ' + username);
    console.log('done socketname', socket.name);
  });

  socket.on('sql request', function(arr) {
    console.log('get sql request: ', arr);
    var tasks, sqls;
    tasks = arr[0];
    sqls = arr[1];
    sqlHandler.doWork(tasks, sqls, (function(resoult) {
      //console.log('done: ', resoult);
      console.log('sql posting data...');
      io.emit('sql post', resoult);
    }));

  });

  socket.on('disconnect', function() {
    console.log(socket.usertype + ' :', socket.name, 'disconnect');
  });

});


var server = http.listen(app.get('port'), function() {
  console.log('start at port:' + server.address().port);
});
