//MAXIMUM GAS PER TRANSACTION: 3141592 (PI)

indexof.indexOf.sendTransaction("I am cool", "cool", {from:eth.coinbase,gas:3141592, gasprice:50000000000});


Command to send monetary transaction:

web3.eth.sendTransaction({from: '0x036a03fc47084741f83938296a1c8ef67f6e34fa', 
to: '0xa8ade7feab1ece71446bed25fa0cf6745c19c3d5', value: web3.toWei(1, "ether")})
