

module.exports = function(app) {
	var parity = require('../controllers/index.controllers.parity.js');
	
	app.use('/', function(req,res) {
	res.render("index");	
});
}
