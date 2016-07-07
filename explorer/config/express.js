var express = require('express');
var path = require('path');
var app = express();
var router = express.Router();
module.exports = function() {

app.set('views', path.join(__dirname, 'views');
app.set('view engine','jade');

app.use(router);
app.use(express.static(path.join(__dirname, 'public')));

require('../app/routes/index.routes.parity.js')(app);
return app;
};
