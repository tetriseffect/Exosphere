var Web3 = require("web3");

var host = "http://192.168.0.10:8545"; // our private host "http://192.168.0.10:8545";

var web3 = new Web3(new Web3.providers.HttpProvider(host));


// Source should be minified smart contract.  Use: https://kangax.github.io/html-minifier/
// Note: remmeber to remove comments before minifying

var source = 'contract Incrementer { address creator; int iteration; string whathappened; int customvalue; function Incrementer() { creator = msg.sender; iteration = 0; whathappened = "constructor executed"; } function increment(int howmuch, int _customvalue) { customvalue = _customvalue; if(howmuch == 0) { iteration = iteration + 1; whathappened = "howmuch was zero. Incremented by 1. customvalue also set."; } else { iteration = iteration + howmuch; whathappened = "howmuch was nonzero. Incremented by its value. customvalue also set."; } return; } function getCustomValue() constant returns (int) { return customvalue; } function getWhatHappened() constant returns (string) { return whathappened; } function getIteration() constant returns (int) { return iteration; } function kill() { if (msg.sender == creator) suicide(creator); } }';

// Compile and get reference to compiled instance
var compiled = web3.eth.compile.solidity(source);

// Extract ABI and code from compiled object
// Note: you must access contract using compiled.<contract_name>...
var abi = compiled.Incrementer.info.abiDefinition;
var code = compiled.Incrementer.code;

// Deploy to blockchain and access via greeter proxy object
var infoContract = web3.eth.contract(abi); 
var incrementer = infoContract.new({from: web3.eth.accounts[0], data:code, gas:1000000});

console.log(abi);
console.log(code);
