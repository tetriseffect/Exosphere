
#Understanding the ethereum trie	

[Original Article](https://easythereentropy.wordpress.com/2014/06/04/understanding-the-ethereum-trie/)

The other day I finally got around to reading the entire ethereum yellow paper and to figuring out how the modified Merkle-patricia-tree (trie) works. So let’s go through a brief but hopefully complete explanation of the trie, using examples.

A block in the ethereum blockchain consists of a header, a list of transactions, and a list of uncle blocks. Included in the header is a transaction root hash, which is used to validate the list of transactions. While transactions are sent over the wire from peer to peer as a simple list, they must be assembled into a special data structure called a trie to compute the root hash. Note that this data structure is not needed except to verify blocks (and hence of course to mine them), and can technically be discarded once a block has been verified. However, it is implied that the transaction lists are stored locally in a trie, and serialized to lists to send to clients requesting the blockchain. Of course, that client will then reconstruct the transaction list trie for each block to verify the root hash. Note that RLP (recursive length prefix encoding), ethereum’s home-rolled encoding system, is used to encode all entries in the trie.

A trie is also known as a radix tree, and the ethereum implementation introduces a couple modifications to boost efficiency. In a normal radix tree, a key is the actual path taken through the tree to get to the corresponding value. That is, beginning from the root node of the tree, each character in the key tells you which child node to follow to get to the corresponding value, where the values are stored in the leaf nodes that terminate every path through the tree. Supposing the keys come from an alphabet containing N characters, each node in the tree can have up to N children, and the maximum depth of the tree is the maximum length of a key.

Radix trees are nice because they allow keys that begin with the same sequence of characters to have values that are closer together in the tree. There are also no key collisions in a trie, like there might be in hash-tables. They can, however, be rather inefficient, like when you have a long key where no other key shares a common prefix. Then you have to travel (and store) a considerable number of nodes in the tree to get to the value, despite there being no other values along the path.

The ethereum implementation of radix trees introduces a number of improvements. First, to make the tree cryptographically secure, each node is referenced by its hash, which in current implementations are used for look-up in a leveldb database. With this scheme, the root node becomes a cryptographic fingerprint of the entire data structure (hence, Merkle). Second, a number of node ‘types’ are introduced to improve efficiency. There is the blank node, which is simply empty, and the standard leaf node, which is a simple list of [key, value]. Then there are extension nodes, which are also simple [key, value] lists, but where value is a hash of some other node. The hash can be used to look-up that node in the database. Finally, there are branch nodes, which are lists of length 17. The first 16 elements correspond to the 16 possible hex characters in a key, and the final element holds a value if there is a [key, value] pair where the key ends at the branch node. If you don’t get it yet, don’t worry, no one does😀. We will work through examples to make it all clear.

One more important thing is a special hex-prefix (HP) encoding used for keys. As mentioned, the alphabet is hex, so there are 16 possible children for each node. Since there are two kinds of [key, value] nodes (leaf and extension), a special ‘terminator’ flag is used to denote which type the key refers to. If the terminator flag is on, the key refers to a leaf node, and the corresponding value is the value for that key. If it’s off, then the value is a hash to be used to look-up the corresponding node in the db. HP also encodes whether or not the key is of odd or even length. Finally, we note that a single hex character, or 4 bit binary number, is known as a nibble.

The HP specification is rather simple. A nibble is appended to the key that encodes both the terminator status and parity. The lowest significant bit in the nibble encodes parity, while the next lowest encodes terminator status. If the key was in fact even, then we add another nibble, of value 0, to maintain overall evenness (so we can properly represent in bytes).

Ok. So this all sounds fine and dandy, and you probably read about it here or here, or if you’re quite brave, here, but let’s get down and dirty with some python examples. I’ve set up a little repo on github that you can clone and follow along with.

git clone git@github.com:ebuchman/understanding_ethereum_trie

Basically I just grabbed the necessary files from the pyethereum repo (trie.py, utils.py, rlp.py, db.py), and wrote a bunch of exercises as short python scripts that you can try out. I also added some print statements to help you see what’s going on in trie.py, though due to recursion, this can get messy, so there’s a flag at the top of trie.py allowing you to turn printing on/off. Please feel free to improve the print statements and send a pull-request! You should be in the trie directory after cloning, and run your scripts with python exercises/exA.py, where A is the exercise number. So let’s start with ex1.py.

In ex1.py, we initialize a trie with a blank root, and add a single entry:
```
state = trie.Trie('triedb', trie.BLANK_ROOT)
state.update('\x01\x01\x02', rlp.encode(['hello']))
print state.root_hash.encode('hex')
```
Here, we’re using '\x01\x01\x02' as the key and 'hello' as the value. The key should be a string (max 32 bytes, typically a big-endian integer or an address), and the value an rlp encoding of arbitrary data. Note we could have used something simpler, like 'dog', as our key, but let’s keep it real with raw bytes. We can follow through the code in trie.py to see what happens under the hood. Basically, in this case, since we start with a blank node, trie.py creates a new leaf node (adding the terminator flag to the key), rlp encodes it, takes the hash, and stores [hash, rlp(node)] in the database. The print statement should display the hash, which we can use from now on as the root hash for our trie. Finally, for completeness, we look at the HP encoding of the key:
```
k, v = state.root_node
print 'root node:', [k, v]
print 'hp encoded key, in hex', k.encode('hex')
```
The output of ex1.py is
```
root hash 15da97c42b7ed2e1c0c8dab6a6d7e3d9dc0a75580bbc4f1f29c33996d1415dcc
root node: [' \x01\x01\x02', '\xc6\x85hello']
hp encoded key, in hex: 20010102
```
Note the final 6 nibbles are the key we used, 010102, while the first two give us the HP encoding. The first nibble tells us that this is a terminator node (since it would be 10 in binary, so the second least significant bit is on), and since the key was even length (least significant bit is 0), we add a second 0 nibble.

Moving on to ex2.py, we initialize a trie that starts with the previous hash:
```
state = trie.Trie('triedb', '15da97c42b7ed2e1c0c8dab6a6d7e3d9dc0a75580bbc4f1f29c33996d1415dcc'.decode('hex'))
print state.root_node
```
The print statement should give us the [key, value] pair we previously stored. Great. Let’s add some more entries. We’re going to try this a few different ways, so we can clearly see the different possibilities. We’ll use multiple ex2 python files, initializing the trie from the original hash each time. First, let’s make an entry with the same key we already used but a different value. Since the new value will lead to a new hash, we will have two tries, referenced by two different hashes, both starting with the same key (the rest of ex2.py)
```
state.update('\x01\x01\x02', rlp.encode(['hellothere']))
print state.root_hash.encode('hex')
print state.root_node
```
The output for ex2.py is:
```
05e13d8be09601998499c89846ec5f3101a1ca09373a5f0b74021261af85d396
[‘ \x01\x01\x02’, ‘\xcb\x8ahellothere’]
```
So that’s not all that interesting, but it’s nice that we didn’t overwrite the original entry, and can still access both using their respective hashes. Now, let’s add an entry that use’s the same key but with a different final nibble (ex2b.py):
```
state.update('\x01\x01\x03', rlp.encode(['hellothere']))
print 'root hash:', state.root_hash.encode('hex')
k, v = state.root_node
print 'root node:', [k, v]
print 'hp encoded key, in hex:', k.encode('hex')
```
This print 'root node' statement should return something mostly unintelligible. That’s because it’s giving us a [key, value] node where the key is the common prefix from our two keys ([0,1,0,1,0]), encoded using HP to include a non-terminator flag and an indication that the key is odd-length, and the value is the hash of the rlp encoding of the node we’re interested in. That is, it’s an extension node. We can use the hash to look up the node in the database:
```
print state._get_node_type(state.root_node) == trie.NODE_TYPE_EXTENSION
common_prefix_key, node_hash = state.root_node
print state._decode_to_node(node_hash)
print state._get_node_type(state._decode_to_node(node_hash)) == trie.NODE_TYPE_BRANCH
```
And the output for ex2b.py:
```
root hash: b5e187f15f1a250e51a78561e29ccfc0a7f48e06d19ce02f98dd61159e81f71d
root node: ['\x10\x10\x10', '"\x01\xab\x83u\x15o\'\xf7T-h\xde\x94K/\xba\xa3[\x83l\x94\xe7\xb3\x8a\xcf\n\nt\xbb\xef\xd9']
hp encoded key, in hex: 101010
True
['', '', [' ', '\xc6\x85hello'], [' ', '\xcb\x8ahellothere'], '', '', '', '', '', '', '', '', '', '', '', '', '']
True
```
This result is rather interesting. What we have here is a branch node, a list with 17 entries. Note the difference in our original keys: they both start with [0,1,0,1,0], and one ends in 2 while the other ends in 3. So, when we add the new entry (key ending in 3), the node that previously held the key ending in 2 is replaced with a branch node whose key is the HP encoded common prefix of the two keys. The branch node is stored as a [key, value] extension node, where key is the HP encoded common prefix and value is the hash of the node, which can be used to look-up the branch node that it points to. The entry at index 2 of this branch node is the original node with key ending in 2 (‘hello’), while the entry at index 3 is the new node (‘hellothere’). Since both keys are only one nibble longer than the key for the branch node itself, the final nibble is encoded implicitly by the position of the nodes in the branch node. And since that exhausts all the characters in the keys, these nodes are stored with empty keys in the branch node.

You’ll note I added a couple print statements to verify that these nodes are in fact what I say they are – extension and branch nodes, respectively. Also, note, that there is a general rule here for storing nodes in branch nodes: if the rlp encoding of the node is less than 32 bytes, the node is stored directly in an element of the branch node. If the rlp encoding is longer than 32, then a hash of the node is stored in the branch node, which can be used to look-up the node of interest in the db.

Ok, so that was pretty cool. Let’s do it again but with a key equal to the first few nibbles of our original key (ex2c.py):

`state.update('\x01\x01', rlp.encode(['hellothere']))`

Again, we see that this results in the creation of a branch node, but something different has happened. The branch node corresponds to the key ‘\x01\x01’, but there is also a value with that key (‘hellothere’). Hence, that value is placed in the final (17th) position of the branch node. The other entry, with key ‘\x01\x01\x02’, is placed in the position corresponding to the next nibble in its key, in this case, 0. Since it’s key hasn’t been fully exhausted, we store the leftover nibbles (in this case, just ‘2’) in the key position for the node. Hence the output:
```
[['2', '\xc6\x85hello'], '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '\xcb\x8ahellothere']
```
Make sense? Let’s do one final component of exercise 2 (ex2d.py). Here, we add a new entry with a key that is identical to the original key, but has an additional two nibbles:
```
state.update('\x01\x01\x02\x57', rlp.encode(['hellothere']))
```
In this case, the opposite of what we just saw happens! The original entry’s value is stored at the final position of the branch node, where the key for the branch node is the key for that value (‘\x01\x01\x02’). The second entry is stored at the position of it’s next nibble (5), with a key equal to the remaining nibbles (just 7):
```
['', '', '', '', '', ['7', '\xcb\x8ahellothere'], '', '', '', '', '', '', '', '', '', '', '\xc6\x85hello']
```
Tada! Try playing around a bit to make sure you understand what’s going on here. Nodes are stored in the database according to the hash of their rlp encoding. Once a node is retrieved, key’s are used to travel a path through a further series of nodes (which may involve more hash lookups) to reach the final value. Of course, we’ve only used two entries in each of these examples to keep things simple, but that has been sufficient to expose the basic mechanic of the trie. We could add more entries to fill up the branch node, but since we already understand how that works, let’s move on to something more complicated. In exercise 3, we will add a third entry, which shares a common prefix with the second entry. This one’s a little longer, but the result is totally awesome (ex3.py):
```
state = trie.Trie('triedb', '15da97c42b7ed2e1c0c8dab6a6d7e3d9dc0a75580bbc4f1f29c33996d1415dcc'.decode('hex'))
print state.root_hash.encode('hex')
print state.root_node
print ''
state.update('\x01\x01\x02\x55', rlp.encode(['hellothere']))
print 'root hash:', state.root_hash.encode('hex')
print 'root node:', state.root_node
print 'branch node it points to:', state._decode_to_node(state.root_node[1])
print ''
```
Nothing new yet. Initialize from original hash, add a new node with key '\x01\x01\x02\x55'. Creates a branch node and points to it with a hash. We know this. Now the fun stuff:
```
state.update('\x01\x01\x02\x57', rlp.encode(['jimbojones']))
print 'root hash:', state.root_hash.encode('hex')
print 'root node:', state.root_node
branch_node = state._decode_to_node(state.root_node[1])
print 'branch node it points to:', branch_node
```
We’re doing the same thing – add a new node, this time with key '\x01\x01\x02\x57' and value 'jimbojones'. But now, in our branch node, where there used to be a node with value 'hellothere' (ie. at index 5), there is a messy ole hash! What do we do with hashes in tries? We use em to look up more nodes, of course!
```
next_hash = branch_node[5]
print 'hash stored in branch node:', next_hash.encode('hex')
print 'branch node it points to:', state._decode_to_node(next_hash)
```
And the output:
```
root hash: 17fe8af9c6e73de00ed5fd45d07e88b0c852da5dd4ee43870a26c39fc0ec6fb3
root node: ['\x00\x01\x01\x02', '\r\xca6X\xe5T\xd0\xbd\xf6\xd7\x19@\xd1E\t\x8ehW\x03\x8a\xbd\xa3\xb2\x92!\xae{2\x1bp\x06\xbb']
branch node it points to: ['', '', '', '', '', ['5', '\xcb\x8ahellothere'], '', '', '', '', '', '', '', '', '', '', '\xc6\x85hello']

root hash: fcb2e3098029e816b04d99d7e1bba22d7b77336f9fe8604f2adfb04bcf04a727
root node: ['\x00\x01\x01\x02', '\xd5/\xaf\x1f\xdeO!u>&3h_+\xac?\xf1\xf3*\xb7)3\xec\xe9\xd5\x9f2\xcaoc\x95m']
branch node it points to: ['', '', '', '', '', '\x00&\x15\xb7\xc4\x05\xf6\xf3F2\x9a(N\x8f\xb2H\xe75\xcf\xfa\x89C-\xab\xa2\x9eV\xe4\x14\xdfl0', '', '', '', '', '', '', '', '', '', '', '\xc6\x85hello']
hash stored in branch node: 002615b7c405f6f346329a284e8fb248e735cffa89432daba29e56e414df6c30
branch node it points to: ['', '', '', '', '', [' ', '\xcb\x8ahellothere'], '', [' ', '\xcb\x8ajimbojones'], '', '', '', '', '', '', '', '', '']
```
Tada! So this hash, which corresponds to key [0,1,0,1,0,2,5], points to another branch node which holds our values 'hellothere' and 'jimbojones' at the appropriate positions. I recommend experimenting a little further by adding some new entries, specifically, try filling in the final branch node some more, including the last position.

Ok! So this has been pretty cool. Hopefully by now you have a pretty solid understanding of how the trie works, the HP encoding, the different node types, and how the nodes are connected and refer to each other. As a final exercise, let’s do some look-ups.
```
state = trie.Trie('triedb', 'b5e187f15f1a250e51a78561e29ccfc0a7f48e06d19ce02f98dd61159e81f71d'.decode('hex'))
print 'using root hash from ex2b'
print rlp.decode(state.get('\x01\x01\x03'))
print ''
state = trie.Trie('triedb', 'fcb2e3098029e816b04d99d7e1bba22d7b77336f9fe8604f2adfb04bcf04a727'.decode('hex'))
print 'using root hash from ex3'
print rlp.decode(state.get('\x01\x01\x02'))
print rlp.decode(state.get('\x01\x01\x02\x55'))
print rlp.decode(state.get('\x01\x01\x02\x57'))
```
You should see the values we stored in previous exercises.

And that’s that! Now, you might wonder, “so, how is all this trie stuff actually used in ethereum?” Great question. And my repository does not have the solutions. But if you clone the official pyethereum repo, and do a quick grep -r 'Trie' . , it should clue you in. What we find is that a trie is used in two key places: to encode transaction lists in a block, and to encode the state of a block. For transactions, the keys are big-endian integers representing the transaction count in the current block. For the state trie, the keys are ethereum addresses. It is essential for any full node to maintain the state trie, as it must be used to verify new transactions (since contract data must be referenced). Unlike bitcoin, however, there is no need to store old transactions for verification purposes, since there is a state database. So technically the transaction tries don’t need to be stored. Of course, if no one keeps them around, then no one will ever be able to verify from the genesis block up to the current state again, so it makes sense to hang on to them.

And there you have it folks. We have achieved an understanding of the ethereum trie. Now go forth, and trie it!
