var Web3 = require("web3");

var host = "http://localhost:8545"; // our private host "http://192.168.0.10:8545";

var web3 = new Web3(new Web3.providers.HttpProvider(host));


// Source should be minified smart contract.  Use: https://kangax.github.io/html-minifier/
// Note: remmeber to remove comments before minifying

var source = "contract Greeter { address creator; string greeting; function Greeter(string _greeting) public { creator = msg.sender; greeting = _greeting; } function greet() constant returns (string) { return greeting; } function getBlockNumber() constant returns (uint) { return block.number; } function setGreeting(string _newgreeting) { greeting = _newgreeting; } function kill() { if (msg.sender == creator) suicide(creator); } }";

// Compile and get reference to compiled instance
var compiled = web3.eth.compile.solidity(source);

// Extract ABI and code from compiled object
// Note: you must access contract using compiled.<contract_name>...
var abi = compiled.Greeter.info.abiDefinition;
var code = compiled.Greeter.code;

// Deploy to blockchain and access via greeter proxy object
var infoContract = web3.eth.contract(abi); 
var greeter = infoContract.new({from: web3.eth.accounts[0], data:code, gas:1000000});

