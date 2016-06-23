#Ethereum Superuser

###Introduction

This is a course for mastering the available tools for Ethereum.

###Install Solidity

Do `sudo apt-get install solc` to install Solidity. This will be stored in `usr/bin/solc`.

Also add to PATH:

```
solc=$PATH:/usr/bin/solc
```
And test it with `which solc` to check it has been added to $PATH.

###Start Morden Block Synchronization

In one window, get the Morden testnet blockchain to sync:

`geth --testnet --fast`     

Now open another window and connect to Digital Ocean:

1. user@[ip-address]
2. [password]

###Attach Javascript Console

Run this command to succcessfully connect to attach the javascript console to the running instance, while also connecting the the RPC apis:

geth --rpc --rpcaddr localhost --rpcapi "eth,net,web3,admin" attach ipc:/home/[user]/.ethereum/testnet/geth.ipc

###Set the Solidity Compiler

First thing to do is set the Solidity compiler. To set it, implement the following command:

`admin.setSolc("/usr/bin/solc")`

Which outputs the following response: 

```
"solc, the solidity compiler commandline interface\nVersion: 0.3.5-0/RelWithDebInfo-Linux/g++/Interpreter\n\npath: /usr/bin/solc"
```

###Try Out RPC API's

Next try out a few commands to make sure everything is working, using the various apis:

`admin peers` to see the closest connections, represented in JSON format.

`eth.accounts` to see the account displayed, which is:

`0xb3970f2bd5f6249e4e472196f0de4103276ead43`

`eth.getCompilers();

###Check Balance

To make sure the chain is fully synced, run `eth.getBlock("latest").number`. This will display the latest number (e.g. 1185239) that has been synced. Then go to https://testnet.etherscan.io/ to check that that the number matches and is the latest. If the chain isn't synced, then the real balance won't show.

If it is synced to the latest, run:

```
web3.fromWei(web3.eth.getBalance('0xb3970f2bd5f6249e4e472196f0de4103276ead43'),'ether').toString(10)
```

Implement a Greeter contract: 

```
> var greeterSource = 'contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }'


> var greeterCompiled = web3.eth.compile.solidity(greeterSource)

> greeterCompiled
{
  greeter: {
    code: "0x606060405260405161023e38038061023e8339810160405280510160008054600160a060020a031916331790558060016000509080519060200190828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10609f57805160ff19168380011785555b50608e9291505b8082111560cc57600081558301607d565b50505061016e806100d06000396000f35b828001600101855582156076579182015b82811115607657825182600050559160200191906001019060b0565b509056606060405260e060020a600035046341c0e1b58114610026578063cfae321714610068575b005b6100246000543373ffffffffffffffffffffffffffffffffffffffff908116911614156101375760005473ffffffffffffffffffffffffffffffffffffffff16ff5b6100c9600060609081526001805460a06020601f6002600019610100868816150201909416939093049283018190040281016040526080828152929190828280156101645780601f1061013957610100808354040283529160200191610164565b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600f02600301f150905090810190601f1680156101295780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b565b820191906000526020600020905b81548152906001019060200180831161014757829003601f168201915b505050505090509056",
    info: {
      abiDefinition: [{...}, {...}, {...}],
      compilerOptions: "--bin --abi --userdoc --devdoc --add-std --optimize -o /tmp/solc163112865",
      compilerVersion: "0.3.1",
      developerDoc: {
        methods: {}
      },
      language: "Solidity",
      languageVersion: "0.3.1",
      source: "contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }",
      userDoc: {
        methods: {}
      }
    }
  },
  mortal: {
    code: "0x606060405260008054600160a060020a03191633179055605c8060226000396000f3606060405260e060020a600035046341c0e1b58114601a575b005b60186000543373ffffffffffffffffffffffffffffffffffffffff90811691161415605a5760005473ffffffffffffffffffffffffffffffffffffffff16ff5b56",
    info: {
      abiDefinition: [{...}, {...}],
      compilerOptions: "--bin --abi --userdoc --devdoc --add-std --optimize -o /tmp/solc163112865",
      compilerVersion: "0.3.1",
      developerDoc: {
        methods: {}
      },
      language: "Solidity",
      languageVersion: "0.3.1",
      source: "contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }",
      userDoc: {
        methods: {}
      }
    }
  }
}
```



