var Web3 = require("web3");

var host = "http://localhost:8545"; // our private host "http://192.168.0.10:8545";

var web3 = new Web3(new Web3.providers.HttpProvider(host));

