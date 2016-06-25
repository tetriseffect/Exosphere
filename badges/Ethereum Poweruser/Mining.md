#Mining Guide

This is a complete as possible guide to all the issues related to mining on the Ethereum blockchain. The mining algorithm on Ethereum is memory-hard so you will need at least 1-2MB hard drive.

###GPU Mining
```
#Geth Ethminer
geth account new
geth --rpc --rpccorsdomain localhost 2>> geth.log & ethminer -G  // -G for GPU, -M for benchmark tail -f geth.log
```

geth account new
geth --rpc --rpccorsdomain localhost 2>> geth.log &
ethminer -G  // -G for GPU, -M for benchmark
tail -f geth.log

ethminer communicates with geth on port 8545 (the default RPC port in geth). You can change this by giving the --rpcport option to geth. Ethminer will find get on any port. Note that you need to set the CORS header with --rpccorsdomain localhost. You can also set port on ethminer with -F http://127.0.0.1:3301. Setting the ports is necessary if you want several instances mining on the same computer, although this is somewhat pointless. If you are testing on a private cluster, we recommend you use CPU mining instead.

Also note that you do not need to give geth the --mine option or start the miner in the console unless you want to do CPU mining on TOP of GPU mining.

If the default for ethminer does not work try to specify the OpenCL device with: `--opencl-device X` where X is 0, 1, 2, etc. When running ethminer with -M (benchmark), you should see something like:

Benchmarking on platform: { "platform": "NVIDIA CUDA", "device": "GeForce GTX 750 Ti", "version": "OpenCL 1.1 CUDA" }


Benchmarking on platform: { "platform": "Apple", "device": "Intel(R) Xeon(R) CPU E5-1620 v2 @ 3.70GHz", "version": "OpenCL 1.2 " }

To debug geth:

geth  --rpccorsdomain "localhost" --verbosity 6 2>> geth.log

To debug the miner:

make -DCMAKE_BUILD_TYPE=Debug -DETHASHCL=1 -DGUI=0
gdb --args ethminer -G -M

Note hashrate info is not available in geth when GPU mining. Check your hashrate with ethminer, miner.hashrate will always report 0. 


###CPU Mining
```
#using Console:
>miner.start(8)
true
>miner.stop()
true

geth account new

geth --mine
```
