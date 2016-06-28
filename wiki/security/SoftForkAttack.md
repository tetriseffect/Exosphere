#Ethereum's DAO Wars Soft Fork is a Potential DoS Vector

[Original Article](http://hackingdistributed.com/2016/06/28/ethereum-soft-fork-dos-vector/)

It has been 10 days since the DAO was hacked on Friday June 17th, when someone moved around $53M USD worth of ether to an object now nicknamed the “Dark DAO.” The mechanics of the attack have been discussed extensively. The hacker further stalked investors who were splitting from The DAO, obtaining the right to attack them as well, initiating an attack that we had cautioned about. A group of whitehat hackers responded by using the same exploit to drain the remaining funds from the DAO, originally worth around $100M USD, to a “Whitehat DAO.”

This is where things sit today. The hacker cannot start the process to extract the funds in the Dark DAO for at least another 17 days, so for now, the funds are not going anywhere. In the meantime, the Ethereum community has spoken resoundingly in favor of a soft fork to freeze all further movement of funds in the Dark DAO. If all goes well, the soft fork will activate on Thursday, June 30th, 2016, and buy the community some additional time to debate longer term strategy.

In this post, we make the case that the soft fork itself can introduce a new attack vector for denial of service (DoS) attacks on Ethereum. We describe how these DoS attacks would work, what effect they would have on the network, and what alternatives we might have. Interestingly, if the community understands and expects such attacks, then any DoS attack is actually much less likely to achieve its aims, and might not be mounted in the first place.

With that in mind, let’s look at the DoS scenarios.

##DoSing the Soft Fork

The current soft fork implementation, incorporated into the latest version of Ethereum mining software, dubbed “DAO Wars,” deems as invalid any transaction that invokes the Dark DAO contract, and rejects any block that includes such a transaction [1].

The intended effect is to freeze the attacker in their tracks: if a majority of the miners buy into the soft fork, then they would ignore any block that contains a transaction that helps the attacker move the Dark DAO funds. Forever trapped, the Dark DAO funds would essentially be excised out of the system, and the whitehat funds can be returned to The DAO investors, at 0.70 ether per each ether invested.

But the soft fork creates a denial of service attack vector which, if exploited, would prevent the network from processing valid transactions at negligible expense to the attacker. Specifically, an attacker can flood the network with transactions that execute difficult computation, and end by performing an operation on the DAO contract. Miners running the soft fork would end up having to execute, and then subsequently discard, such contracts without collecting any fees.

One simple example of this type of malicious transaction is shown below:
```
for(uint32 i=0; i < 1000000; i++) {
   sha3('some data'); // costly computation
}
DarkDAO.splitDAO(...); // render the transaction invalid
```

##Root Cause

At a high level, recall that Ethereum miners are currently protected from DoS attacks by gas payments: the more computation they perform, the more gas they collect, and the more money an attacker has to spend. But with the soft fork in place, miners are in a new position where they end up having to perform substantial work without collecting any compensation, at no penalty to the attacker. The soft fork creates a new and fundamentally different class of transactions in contrast with those that currently exist within the protocol. Currently, transactions either complete successfully and cause a state transition, or run into an exception, in which case state is reverted but the maximum possible gas is still charged. With the soft fork, transactions which interact with a DAO will not fit within these two classes: they will fail execution but no gas will be charged. This must inevitably be the case in any soft fork that aims to freeze the stolen funds; since the protocol does not specify a “DAO Interaction Exception,” miners must either include the transaction in their block along with all of its resultant state changes, or they must exclude the transaction entirely, and forfeit any gas reward. Attempts to include a transaction without its proper state transitions will cause the block to be invalid and not propagated by other nodes. This provides an enormous amount of amplification to the attacker.

And it gets worse: miners typically prioritize transactions by gas price. Because malicious transactions don’t actually pay gas, an attacker could set an extraordinarily high gas price to trick miners into wasting all their computation. This could result in blocks entirely empty of any valid transactions.

##Attack Outcome

This DoS attack is not the end of the world: it would not cause further theft, nor would it confer a substantial advantage to the DAO hacker. The main outcome is that the Ethereum blockchain would consist mostly of empty blocks, as the soft-fork-supporting miners, who are in the majority, waste their time on transactions that are invalid by the soft fork rules. Non-SF miners would mine more useful blocks, but these blocks would be discarded by the SF majority. Ethereum contracts would thus fail to execute or proceed much more slowly for as long as the attack is taking place. The safety of the system would be maintained, while progress is hampered.

##DoS Defenses Are Ineffective

One might try to thwart DoS attacks on the soft fork by checking the contract code for references to the Dark DAO address. This is known as static analysis, and naive attempts, such as scanning transactions for a call to the DarkDAO address, are easy to fool through program obfuscation, for instance, by XORing the address and performing a hash lookup. More intelligent detection attempts that use conservative static analysis can easily take more time and resources than actual execution, exacerbating the DoS vector. In general, due to the [halting problem](https://en.wikipedia.org/wiki/Halting_problem), there is no general analysis algorithm that can determine the outcome of all possible Ethereum programs, short of performing the computation and observing the result.

##IP Blacklists Are Worse

One possible approach that has been suggested is to require that nodes in the network execute the transactions they receive to determine if they are soft-fork compliant (i.e. they do not invoke the Dark DAO), and only ferry them onto the miners if they are safe.

This is a terrible idea, for three reasons, listed from least bad to really bad.

Recall that Ethereum nodes currently check transactions solely for well-formedness, that is, validity of the format and signature, but not of the content. Actually executing a transaction is left up to the miners, who understand and buy into the economic game of executing the code in return for rewards. Forcing the intermediary nodes to validate the content of a transaction can cause nodes to voluntarily drop out of the network due to increased CPU costs.

Further, recall that a transaction executes in a particular context on the blockchain, assigned by a miner. Intermediaries do not have the definitive context, and it’s therefore possible to write transactions that seem to execute safely when checking during transmission, but to end up invoking the Dark DAO when in a block. A simple way to do so would be to follow conditional paths depending on block number. If it’s above T, the transaction invokes the DarkDAO. The attacker would have to time it such that the transaction is transmitted while block height is T-1, but reaches the miners at time T.

But most importantly, blacklists are a terrible idea because they are no longer soft forks: nodes need to be updated to perform the requisite checking, or else they can be cut off from the network. There is no universal agreement on what exactly constitutes a soft fork, because the blockchain would continue to be parsed, but these nodes would be cast aside, fracturing the network.

##Creative Solutions Considered Harmful

Almost any protocol can be deployed as a soft fork, especially on top of a versatile platform such as Ethereum, using clever tricks. In this specific instance, one could modify all SF-supporting software, including all nodes, wallets and exchanges, to use a different transaction format (e.g. one where all transactions necessarily predeclare all call targets for easy analysis), but to continue to accept old transactions. If the new format can be engineered to parse as a valid transaction under the old rules, it just might be possible to keep all nodes connected to the network, to create a backwards-compatible blockchain, and thus to keep chugging along while banishing the DoS vector.

But this would simply introduce unnecessary complications to a clean, elegant, freshly-designed system. It would be a big mistake for Ethereum to repeat [Bitcoin's SegWit soft-fork mistake](http://hackingdistributed.com/2016/04/05/how-software-gets-bloated/). Such clever tricks incur not a technical debt, but a social one, as they overwhelm newcomers with quirks and discourage new people from wanting to learn about the system.

Luckily, the code deployment timelines render this a non-option. There just isn’t time to develop, test and roll out such a trick, which is good.

##Partial Measures

**Gas Limits:** One workable solution to reduce the amount of amplification available to the attacker is to simply reduce the transaction gas limit. This would freeze out complex contracts, but it can provide some limit on the leverage available to the attacker. It is only a partial fix, which could detract from an attack’s effectiveness and allow simple transactions to find their way into the blockchain but does not address the root cause of the attack.

**Banning Spam Addresses:** Another partially workable solution is to ban any address that issues a transaction that invokes the Dark DAO. This means that an attacker cannot repeatedly use the same address to continually spam the network, which in turn would force her to spend gas on creating additional wallet addresses. This can reduce the attacker's leverage, but does not completely eliminate attacks, and needs to be implemented carefully to avoid banning contracts that are tricked into invoking a DAO function.

##Would Anyone Launch DoS Attacks?

It is quite common for network protocols to harbor opportunities for attack, and yet flourish in the real world because no one would have any incentive to take advantage of them. Sadly, we are concerned that this is not the case for this particular attack on Ethereum.

There are three categories of people who might launch a soft-fork DoS attack, two of which are unlikely, while a third is quite dangerous.

A non-SF miner might take advantage of this vector to attack rival SF-supporting miners. While we have seen malicious behaviors by miners in the Bitcoin world, they are rare.

The DAO hacker may take advantage of this vector to attack SF-supporting miners to drop their support for the soft fork. We would expect the attacker to launch this attack on or around the day he is able to start moving his funds in the Dark DAO, some time in July. However, Alex van de Sande has reported that the hacker is not the curator of the Dark DAO, so, even if the hacker were to break down the miner-imposed soft fork, that would not enable her to retrieve the funds.

The most dangerous group are “griefers,” people who might short ETH and launch a DoS attack to profit off of the impending drop in the coin’s value. Similarly, extremists who falsely believe cryptocurrencies to be a zero-sum game might want to sabotage Ethereum for a perceived increase in the value or stature of their coins. And of course, there are people who might want to attack the Ethereum miners for the amusement value. Because the attack currently has no cost, it is quite possible for these groups to launch it.

##Alternatives

Soft forks are difficult to get right. They introduce a new attack vector, mangle the economics of running a node, and can potentially cause the network to split.

**No Fork:** One alternative is to avoid forking at all. Depending on how events play out, this would lead The DAO investors to lose somewhere between 30% to 100% of their investment. Recall that these people were among the earliest and most optimistic adopters of a brand new technology. A substantial loss would deliver a substantial kick to the nascent world of smart contracts.

**Soft Fork with a Stiff Upper Lip:** We can continue with the current soft fork plan, fully cognizant that there is an opportunity for DoS attacks. Now that they have been made public, their shock value, and the ability to profit off of them, will be diminished. Users will have to steel themselves for a period of time when the Ethereum blockchain may make progress at a slower pace than usual. Desperate measures, such as blacklists, might cause the Ethereum network to shrink and fracture, and should be avoided. Stopgap measures, such as reducing the gas limit or permabanning addresses, may lead to certain contracts becoming inaccessible. This period of DoS vulnerability and/or diminished Ethereum operation would have to end in an abandonment of the soft fork in favor of either the no-fork option or a hard fork.

**Hard Fork:** A hard fork would put a decisive end to the ongoing corewars game that is being played. From a technical perspective, it is the cleanest, simplest, and most secure option on the table. It is beyond the scope of this post to debate the ideology behind a hard fork, so we will refrain from it, even though it is an interesting and worthy topic.

##Conclusions

The current soft fork deployed in Ethereum poses a DoS vector. If the soft fork activation goes ahead as planned, the community should be prepared for potential DoS attacks, which would lead to diminished performance for the network. We urge the community to come to consensus on the ultimate resolution of The DAO saga as quickly as possible.

>[1]	The soft fork code also restricts what can happen with the Whitehat DAO, but those restrictions are not germane to this discussion.
