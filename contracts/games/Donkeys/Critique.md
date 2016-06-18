
ETHEREUM CONTRACTS ARE GOING TO BE CANDY FOR HACKERS

18 May 2016 on ethereum, security, smart contracts
Smart Contracts and Programming Defects

Ethereum promises that contracts will 'live forever' in the default case. And, in fact, unless the contract contains a suicide clause, they are not destroyable.

This is a double-edged sword. On the one hand, the default suicide mode for a contract is to return all funds embedded in the contract to the owner; it's clearly unworkable to have a "zero trust" system in which the owner of a contract can at will claim all money.

So, it's good to let people reason about the contract longevity. On the other hand, I have been reviewing some Ethereum contracts recently, and the code quality is somewhere between "optimistic as to required quality" and "terrible" for code that is supposed to run forever.

Dan Mayer cites research showing industry average bugs per 1000 lines of code at 15-50 and Microsoft released code at 0.5 per 1000, and 0(!) defects in 500,000 lines of code for NASA, with a very expensive and time consuming process.
Ethereum Smart Contract Bugs per Line of Code exceeds 100 per 1000

My review of Ethereum Smart Contracts available for inspection at dapps.ethercasts.com shows a likely error rate of something like 100 per 1000, maybe higher.
Bug Definitions

I categorize bugs into three categories:

    Security flaws: loss of money or control possible for users or owners.
    Doesn't do what it claims, either in the description or code comments.
    Wastes gas / is inefficient.

Before starting this quick review, I would have expected to see a fair amount of 3, and a bit of 2. I have been surprised to see some significant instances of 1, often combined with 2.

This raises a sort of rhetorical question for me; if contracts are immutable and permanent, and error rates do not approach zero, what are people signing up for?

I have a few suggestions in a later post.
A sample contract with some flaws

Ethstick is a kind of pyramid scheme which incentivizes participants (donkeys) to keep depositing money to get the payout (carrot). As each payment comes in, a "lucky donkey" is chosen for payout; the lucky one is chosen from a list of eligible donkeys.

Payouts vary between 1.1x and 1.2x, adjustable by the owner of the contract. (Termed the "pig" in the code). The pig/owner can sell the contract on and transfer it to a new owner, a common pattern for contracts intended to be micro-businesses.

You can review the code for contract 0xbA6284cA128d72B25f1353FadD06Aa145D9095Af at etherscan.io.
Randomness

A 10 minute check turns up a couple major issues. First, the random function relies only on the following numbers:

    A custom integer used as a random factor, hardcoded into the contract.
    The prior block's hash.
    The length of the list of eligible donkeys

This random number is used to choose which of the donkeys is paid out. Ethereum blocks come about every 45 seconds; therefore, there is plenty of time for an attacker to calculate out if they would be the paid-out donkey and only trigger the contract with a payment if they are the recipient.

This qualifies as a severe bug to my mind. It is not mitigated by the contract's popularity -- more people playing increase your chances of being lucky -- but when the contract is not used often, there is a guaranteed way to prod it and get paid out.

It's not even easily mitigable using the block hash the transaction is mined in: an attacking miner or pool could only include good transactions in blocks that meet the calculation, otherwise leaving them out and not broadcasting them to the rest of the world.

That attack advantages a savvy consumer of the contract, the next one advantages the owner.
How Long is the List?

The function changeEligibleDonkeys allows the owner of the contract to shorten or lengthen the list of Donkeys. A simple attack by the owner would look like this:

    Add self to list of eligible donkeys, perhaps multiple times
    Shorten list if 'whales' are near the end of it

I've skipped a number of 'efficiency' related bugs, and I would not claim to have captured all the logic errors in this code; there is a section with a comment labeled //Ranking logic: mindfuck edition in case you would like to hunt down your own edge cases.

Counting whitespace and data declarations, there are 350 or so lines of code here. I've pulled out two large bugs, and there are at least five places with rounding issues or efficiency issues in the code. The actual logic in the code is less than 100 lines.

This is a troubling number of errors, and I have not cherry-picked a contract, in fact, this contract seems fairly functional right now compared to many. It will eventually become a cesspit for attack algorithms trying to beat each-other at the randomness game, which will be kind of fun to watch, I suppose, but it will not be doing the job it promises to do.

I would rate it in the middle of code quality that I've seen in the last few days. Some popular services, ones with 100s of thousands of dollars flowing through them, are distressingly bad (as in "everyone loses all their money" bad) with no way to mitigate, by design.
Mitigation

Some recommendations -- first, I think that it is almost going to be a requirement for all but the simplest contracts that they have some sort of replacement mechanism baked in.

I have a few ideas about how this could work, and will write about them later, but one obvious point to make is that the replacement mechanism would need to be trusted by users of the contract.

Second, it's probably worth including a 'suicide' mechanic for most contracts, and thinking upfront about what the fairest thing to do is. In the case of something like this, the owner of the contract could have easily included some sort of fair pro-rata payout of balances to the 'donkeys', paying herself nothing, and that would allow a simple way to close the contract without financial incentive to steal for the contract owner.

Third, smart contract auditing and insurance is going to be a thing.

Update: The creator of the contract responded and clarified a few things on reddit. Hacker News has some interesting discussion as well.

