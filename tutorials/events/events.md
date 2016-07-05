#Dapps: listening for events in Solidity

####Recommended Reading

[Introduction to Events and Logs in Ethereum](https://media.consensys.net/2016/06/06/technical-introduction-to-events-and-logs-in-ethereum/)

**Sample Contract:**
```contract ExampleContract {
  event ReturnValue(address indexed _from, int256 _value);

  function foo(int256 _value) returns (int256) {
    ReturnValue(msg.sender, _value);
    return _value;
  }
}
```
**Event Listener**
```var exampleEvent = exampleContract.ReturnValue({_from: web3.eth.coinbase});
exampleEvent.watch(function(err, result) {
  if (err) {
    console.log(err)
    return;
  }
  console.log(result.args._value)
  // check that result.args._from is web3.eth.coinbase then
  // display result.args._value in the UI and call    
  // exampleEvent.stopWatching()
})
exampleContract.foo.sendTransaction(2, {from: web3.eth.coinbase})
```


####More examples:
```
Web3 = require('web3);
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"))

var myContract = contracts['myContract'].contract;
var events = myContract.allEvents();
events.watch(function(error, event){
    if (error) {
        console.log("Error: " + error);
    } else {
        console.log(event.event + ": " + JSON.stringify(event.args));
    }
});
```

####web3.eth.filter
```
// can be 'latest' or 'pending'
var filter = web3.eth.filter(filterString);
// OR object are log filter options
var filter = web3.eth.filter(options);

// watch for changes
filter.watch(function(error, result){
  if (!error)
    console.log(result);
});

// Additionally you can start watching right away, by passing a callback:
web3.eth.filter(options, function(error, result){
  if (!error)
    console.log(result);
});
```
#####Parameters

	1. `String|Object` - The string `"latest"` or `"pending"` to watch for changes in the latest block or pending transactions respectively. Or a filter options object as follows:
        * `fromBlock`: Number|String - The number of the earliest block (latest may be given to mean the most recent and pending currently mining, block). By default latest.
        * `toBlock`: Number|String - The number of the latest block (latest may be given to mean the most recent and pending currently mining, block). By default latest.
        * `address`: String - An address or a list of addresses to only get logs from particular account(s).
        * `topics`: Array of Strings - An array of values which must each appear in the log entries. The order is important, if you want to leave topics out use null, e.g. [null, '0x00...']. You can also pass another array for each topic with options for that topic e.g. [null, ['option1', 'option2']]

Returns

Object - A filter object with the following methods:
```
    filter.get(callback): Returns all of the log entries that fit the filter.
    filter.watch(callback): Watches for state changes that fit the filter and calls the callback. See this note for details.
    filter.stopWatching(): Stops the watch and uninstalls the filter in the node. Should always be called once it is done.
```
Watch callback return value

    String - When using the "latest" parameter, it returns the block hash of the last incoming block.
    String - When using the "pending" parameter, it returns a transaction hash of the last add pending transaction.
    Object - When using manual filter options, it returns a log object as follows:
        logIndex: Number - integer of the log index position in the block. null when its pending log.
        transactionIndex: Number - integer of the transactions index position log was created from. null when its pending log.
        transactionHash: String, 32 Bytes - hash of the transactions this log was created from. null when its pending log.
        blockHash: String, 32 Bytes - hash of the block where this log was in. null when its pending. null when its pending log.
        blockNumber: Number - the block number where this log was in. null when its pending. null when its pending log.
        address: String, 32 Bytes - address from which this log originated.
        data: String - contains one or more 32 Bytes non-indexed arguments of the log.
        topics: Array of Strings - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except if you declared the event with the anonymous specifier.)

Note For event filter return values see Contract Events
Example
```
var filter = web3.eth.filter('pending');

filter.watch(function (error, log) {
  console.log(log); //  {"address":"0x0000000000000000000000000000000000000000", "data":"0x0000000000000000000000000000000000000000000000000000000000000000", ...}
});

// get all past logs again.
var myResults = filter.get(function(error, logs){ ... });

...

// stops and uninstalls the filter
`filter.stopWatching();`

