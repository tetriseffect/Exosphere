ORIGINAL ARTICLE: http://hackingdistributed.com/2016/06/16/scanning-live-ethereum-contracts-for-bugs/

SCANNING LIVE ETHEREUM CONTRACTS FOR THE "UNCHECKED-SEND" BUG

Smart contract programming in Ethereum is notoriously error-prone [1]. We've recently seen that several high-profile smart contracts, such as King of the Ether and The DAO-1.0, contained vulnerabilities caused by programming mistakes.

Smart-contract programmers have been warned about particular programming hazards that can crop up when contracts send messages to each other since March 2015, when the Ethereum Foundation commissioned a security report [6] from Least Authority about the Ethereum Virtual Machine. Multiple programming guides contain best-practice recommendations to avoid common pitfalls (in the official Ethereum docs [3], and in an independent guide from UMD [2]). While these hazards seem like they should be straightforward to recognize and to avoid, the consequences of even a single mistake are dire: money can get stuck, destroyed, or stolen.

Just how prevalent are the bugs that result from these hazards? Are there vulnerable yet live contracts out there on the Ethereum blockchain? In this post, we answer this question by analyzing contracts on the live Ethereum blockchain, with the aid of a new analysis tool we have developed.

To cut to the chase, it will turn out that the majority of Ethereum contracts indeed ignore the best-practice recommendations. Clearly, the Ethereum community has yet to solve this problem. At the end, we make some recommendations for how to remedy this situation.
What’s the "unchecked-send" bug?

To have a contract send Ether to some other address, the most straightforward way is to use the send keyword. This acts like a method that’s defined for every "address" object. For example, the following fragment of code might be found in a smart contract that implements a board game.

/*** Listing 1 ***/
if (gameHasEnded && !( prizePaidOut ) ) {
  winner.send(1000); // send a prize to the winner
  prizePaidOut = True;
}

The problem here is that the send method can fail. If it fails, then the winner does not get the money, yet prizePaidOut might be set to True.

There are actually two different cases where winner.send() can fail. We’ll care about the distinction between them later on in this post. The first case is if the winner address is a contract (rather than a user account), and the code for that contract throws an exception (e.g., if it uses too much gas). If this is the case, then perhaps the concern is moot since it’s the "winner's" own fault anyway. The second case is less obvious. The Ethereum Virtual Machine has a limited resource called the ‘callstack’, and this resource can be consumed by other contract code that was executed earlier in the transaction. If the callstack is already consumed by the time we reach the send instruction, then it will fail regardless of how the winner is defined. The winner’s prize would be destroyed through no fault of his own! A correctly engineered smart contract should protect the winner from this ‘callstack attack’.
How can this bug be avoided?

The Ethereum documentation contains a short remark warning about this potential hazard [3]:

    There are some dangers in using send: The transfer fails if the call stack depth is at 1024 (this can always be forced by the caller) and it also fails if the recipient runs out of gas. So in order to make safe Ether transfers, always check the return value of send or even better: Use a pattern where the recipient withdraws the money.

This contains two suggestions. The first is to check the return value of send to see if it completes successfully. If it doesn’t, then throw an exception so all the state is rolled back.

/*** Listing 2 ***/
if (gameHasEnded && !( prizePaidOut ) ) {
  if (winner.send(1000))
    prizePaidOut = True;
  else throw;
}

This is an adequate fix for the current example, but sometimes it isn't the correct solution. Suppose we modify our example so that when the game is over, both the winner and the loser get something back. The obvious application of the "official" solution would be the following:

/*** Listing 3 ***/
if (gameHasEnded && !( prizePaidOut ) ) {
  if (winner.send(1000) && loser.send(10))
    prizePaidOut = True;
  else throw;
}

However, this is a mistake, since it introduces an additional vulnerability. Whereas this code protects the winner from the callstack attack, it also makes the winner and loser vulnerable to each other. In this case, what we want is to prevent the callstack attack, but to continue executing if the send instructions fail for any other reason.

Therefore an even better best-practice (the one recommended in our “Programmer’s Guide to Ethereum and Serpent”, though it applies equally well to Solidity), is to directly check that the callstack resource is available. There is no built-in support for inspecting the callstack. Instead, we can define a macro, callStackIsEmpty(), which probes the callstack by making a test message that fails if and only if the callstack is empty.

/*** Listing 4 ***/
if (gameHasEnded && !( prizePaidOut ) ) {
  if (callStackIsEmpty()) throw;
  winner.send(1000)
  loser.send(10)
  prizePaidOut = True;
}

The "even better" recommendation from the Ethereum documentation, to "Use a pattern where the recipient withdraws the money", is a bit cryptic, but bears explanation. The suggestion is to refactor your code so that the effects of a failed send are isolated to affect only one party at a time. An example of this approach is below. However, this advice is also an anti-pattern. It passes on responsibility for checking the callstack to the recipients themselves, making it likely for them to fall into the same trap as well.

/*** Listing 5 ***/
if (gameHasEnded && !( prizePaidOut ) ) {
  accounts[winner] += 1000
  accounts[loser] += 10
  prizePaidOut = True;
}
...
function withdraw(amount) {
  if (accounts[msg.sender] >= amount) {
     msg.sender.send(amount);
     accounts[msg.sender] -= amount;
  }
}

Many high-profile smart contracts are vulnerable

The "King of the Ether Throne" lottery game is the most well-known case of this bug [4] so far. This bug wasn't noticed until after a sum of 200 Ether (worth more than $2000 at today's price) failed to reach a rightful lottery winner. The relevant code in King of the Ether resembles that of Listing 2. Fortunately, in this case, the contract developer was able to use an unrelated function in the contract as a "manual override" to release the stuck funds. A less scrupulous administrator could have used the same function to steal the Ether!

Almost a year earlier (while Ethereum was in its “frontier” release), a popular lottery contract, EtherPot [9], also suffered from the same bug.

An earlier version of BTCRelay also exhibited this bug [7]. Although the hazard was noticed in an earlier security audit, the wrong fix was applied at first [8].
Detecting the "unchecked-send" bug on the live blockchain

How prevalent are these bugs? Are the warnings being heeded? Are the best-practices being followed?

We answer these questions empirically, by analyzing the Ethereum blockchain data, as well as the repository of Solidity code found on etherscrape.com. To do this, we develop a simple program analysis tool that inspects a blockchain contract, and uses heuristics to check whether either of the best-practice defensive techniques are being used.

Listing 2 shows off the first defensive technique, as recommended in the Ethereum docs, which is to check the return value of send and throw an exception. To detect the use of this technique, we use a coarse approximation: we simply look for whether the return value of send is ignored or not.

Listing 4 illustrates the second defensive technique, the one recommended in the UMD guide, which is to directly check whether the callstack is full by sending a test message. To detect this technique, we again use a coarse-grained approximation: we simply check whether or not a message is being sent in addition to the send instruction.

If neither of these heuristic indicators are present, then we infer that neither of the best-practice recommendations are being followed. We implement these heuristics by using simple pattern matching against the compiled EVM bytecode. More details on how we do this this are in an Appendix [12].
How many contracts are vulnerable?

We start by trying out our heuristics on the Etherscrape repository of Solidity source code. As of March 20, 2016, the Etherscrape repo contained 361 Solidity contract programs, 56 of which contained a send instruction. Of these contract programs, we’d infer that the majority (at least 36 of 56) do not use either of the defensive programming techniques.

Even if a contract doesn’t use either of the defensive techniques, it might or might not exhibit an actual vulnerability. We manually inspected the Solidity contracts to confirm if the vulnerability is present. For our purposes, we consider a contract vulnerable if its state can change even if the send instruction fails (therefore we would consider the code in Listing 5 vulnerable). We confirmed that the vulnerability is present in the vast majority, 32 out of 36 of these contracts.

Similarly, our heuristics don't guarantee that a defensive programming technique is actually being applied correctly. Take for instance "WeiFund," a decentralized open source crowdfunding DApp. This contract has two functions, refund() and payout(), that fool our heuristic. An excerpt from refund is shown below.

function refund(uint _campaignID, uint contributionID) public {
  ...
  receiver.send(donation.amountContributed);
  donation.refunded = true;
  ...
  if(c.config != address(0))
    WeiFundConfig(c.config).refund(_campaignID, donation.contributor, donation.amountContributed);
}

In this code, a message is sent to the address WeiFundConfig(c.config) in order to invoke a remote refund method, but only under certain conditions. If c.config is a null value, then the contract is indeed vulnerable to the callstack attack. Upon inspection, *not one of the Solidity programs that passed our heuristic check actually applied the recommended best-practice of testing the callstack directly.*

We next turn our attention to the compiled contracts on the live Ethereum blockchain. We looked at a snapshot of the blockchain from March 20th, 2016 (blockchain timestamp: 1184243). This snapshot contains 13645 blockchain contracts in total that appear to be generated by the Solidity compiler, of which only 1618 (11.8%) included the send() instruction. Of these, the vast majority do not appear to use either of the defensive programming techniques.

For completeness, we include the full breakdown of contracts we looked at in Appendix B [14] and Appendix C [15].

Total contracts
    known to Etherscrape as of 03/20/16*

	Contracts that use send 	Vulnerable 	Failed send is benign 	Might check the return value 	Might check the call stack
Solidity Source 	361 	56 	32 	4 	11 	9
Blockchain contract 	13645 	1618 	1498** 	30 	90

* 2016-03-20 12:42:04 (blockchain timestamp: 1184243)

** We are only able to confirm the vulnerability by manually inspecting the high level Solidity code, therefore we cannot provide this breakdown for all blockchain contracts.
What about the recursive race problem in TheDAO?

The most exciting smart contract these days, TheDAO [11], suffers from an entirely separate kind of bug, which is that it is not "reentrancy-safe" [13]. This is another (related, but distinct) kind of programming hazard that was also anticipated in the earlier Least Authority security audits [6], but is still likely made by many contracts today. Future work would be to make a tool that can detect this kind of bug as well.
Where did it all go wrong?

We don't expect smart-contract programming to be entirely easy, at least not yet. However, it's surprising that this particular form of bug is so prevalent, given that it was reported so early on in the development of the Ethereum ecosystem.

The 2015 Least Authority report [6] contained this recommendation to the Ethereum developers:

    The programming examples provided in the documentation so far are inadequate to convey best-practices for writing safe contracts and coping with the gas mechanism. Introductory C++ textbooks frequently omit error checking for the sake of readability, and have resulted in countless security bugs. Ethereum's examples must teach better habits.

    Recommendation: provide many more examples of thorough defensive contract programming.

We're aware of only one official response to this, which is to add the warning in the official Solidity documentation mentioned earlier, [3] repeated below:

    There are some dangers in using send: The transfer fails if the call stack depth is at 1024 (this can always be forced by the caller) and it also fails if the recipient runs out of gas. So in order to make safe Ether transfers, always check the return value of send or even better: Use a pattern where the recipient withdraws the money.

We think that this remark is insufficient documentation of the problem. It offers only an incomplete mitigation, and describes only one variation of the hazard, potentially misleading the reader about its extent.

    Update: The inadequacy of the Solidity documentation has also been illustrated in excellent detail by Peter Vessenes. [16]

Furthermore, the warning doesn't seem often to be heeded anyway. Therefore we believe that additional preventative steps should be taken.
How can Etherscrape help?

We believe that using static analysis tools, even crude ones like the one in this post, can help improve the quality of smart contracts.

At Etherscrape, we are integrating analysis tools like this into our public web service, and we'll add a link to the tool's page when it's ready. This will make it easier to review smart contract code, by highlighting the places where errors are likely to occur. We envision that users of such smart contract (like potential investors in TheDAO or its proposals) could easily use such tools as a sanity check before depositing their money. Even non-technical investors could hold developers accountable for explaining how they responded to the concerns highlighted in the code.

Etherscrape also helps by analyzing the public blockchain and monitoring the prevalence of this bug, which can help when deciding how much funding to allocate towards research and development of static analysis tools, for example.

Additionally, compilers like solc could integrate such analyses, providing a warning to the programmer when the bug seems likely.
References

    [1] Step-by-step Towards Creating a Safe Smart Contract
    [2] UMD Programmer's Guide to Ethereum and Serpent (Section 5.14)
    [3] Official Ethereum Solidity Docs
    [4] King of the Ether: Post-Mortem Investigation
    [5] Swende on Contract Security
    [6] Least Authority audit of Ethereum
    [7] BTC Relay Audit 1
    [8] BTC Relay Audit 2
    [9] EtherPot Security Bug Report
    [10] Reentrant Contracts
    [11] The DAO (Decentralized Autonomous Organization)
    [12] Appendix A: Details on how we analyze the blockchain
    [13] A Call for a Temporary Moratorium on The DAO
    [14] Appendix B: Vulnerable Solidity Contracts
    [15] Appendix C: Vulnerable Blockchain Contracts
    [16] Ethereum Griefing Wallets: Send w/Throw Is Dangerous


