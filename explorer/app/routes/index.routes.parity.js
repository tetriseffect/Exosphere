module.exports = function(app) {
	var parity = require('../controllers/index.controllers.parity.js');
	
	app.get('/', function(req,res) {
	res.send(parity.blockNumber);
	res.send(parity.listAccounts);
});
};
