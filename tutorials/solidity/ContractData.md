#How Contracts Store Data

###Data Location

There are three locations where contract data is stored: storage, memory and calldata. Storage, as the name implies, is a vault where state variables are kept over the long term. Memory on the other hand is temporary, and is used to store function input and output parameters. Calldata is similar to memory, except it is used for storing function arguments.

It is very important for contract developers to understand how data location affects the behaviour of variables. When a state variable is assigned to a local storage variable, the local variable acts as a pointer but does not create an independent copy. For example:

```
bytes32 x = “Doug”;
bytes32 y = x;
```

Here, `x` is a state variable which is kept in storage long term. `y` merely points to x (“Doug”) but doesn't create an independent copy. Why does this matter? Because everything you do in Ethereum costs gas. Creating independent copies takes more computation, and is therefore more expensive.

On the other hand, assignments between storage and memory

As we know, state variables are kept in long term storage. 


with between for

