var Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

exports.listAccounts = function(req,res) {
	accountList = web3.personal.listAccounts;	
res.send(accountList);
};

exports.blockNumber = function(req,res) {
	numberBlock = web3.eth.blockNumber;
	res.send(numberBlock);
};
