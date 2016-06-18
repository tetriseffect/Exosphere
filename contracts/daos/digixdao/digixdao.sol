DigixDAO
Anthony Eufemio


A.1. Config.sol


import "./Interfaces.sol"; 

contract Config is ConfigInterface { 

  event ConfigChange(bytes32 indexed _configKey, address indexed _user); 

  modifier ifAdmin() { 
    if (admins[msg.sender] == false) throw; 
    _ 
  } 

  modifier ifOwner() { 
    if (msg.sender != owner) throw; 
    _ 
  } 

  function Config() { 
    owner = msg.sender; 
    admins[msg.sender] = true; 
  } 

  function setConfigAddress(bytes32 _key, address _val) ifAdmin returns (bool success) { 
    addressMap[_key] = _val; 
    return true; 
  } 

  function setConfigBool(bytes32 _key, bool _val) ifAdmin returns (bool success) { 
    boolMap[_key] = _val; 
    return true; 
  } 

  function setConfigBytes(bytes32 _key, bytes32 _val) ifAdmin returns (bool success) { 
    bytesMap[_key] = _val; 
    return true; 
  } 

  function setConfigUint(bytes32 _key, uint256 _val) ifAdmin returns (bool success) { 
    uintMap[_key] = _val; 
    return true; 
  } 

  function getConfigAddress(bytes32 _key) returns (address val) { 
    val = addressMap[_key]; 
    return val; 
  } 

  function getConfigBool(bytes32 _key) returns (bool val) { 
    val = boolMap[_key]; 
    return val; 
  } 

  function getConfigBytes(bytes32 _key) returns (bytes32 val) { 
    val = bytesMap[_key]; 
    return val; 
  } 

  function getConfigUint(bytes32 _key) returns (uint256 val) { 
    val = uintMap[_key]; 
    return val; 
  } 

  function addAdmin(address _admin) ifOwner returns (bool success) { 
    admins[_admin] = true; 
    return true; 
  } 

  function removeAdmin(address _admin) ifOwner returns (bool success) { 
    admins[_admin] = false; 
    return true; 
  } 
}



A.2. CoreWallet.sol


contract CoreWallet { 

  event Withdraw(address indexed _recipient, uint256 indexed _amount, address indexed _sender); 
  event PaymentRequest(uint256 indexed _requestId); 
  event Approve(uint256 indexed _requestId); 
  event Decline(uint256 indexed _requestId); 
  
  enum RequestStatus { Pending, Declined, Approved } 

  struct Request { 
    RequestStatus status; 
    uint256 amount; 
    address recipient; 
  } 

  mapping (address => bool) approved; 
  mapping (address => bool) managers; 
  address public owner; 
  mapping (uint256 => Request) requests; 
  uint256 requestCount = 0; 

  modifier ifOwner() { 
    if (owner != msg.sender) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  modifier ifApproved() { 
    if (!approved[msg.sender]) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  modifier ifManager() { 
    if (!managers[msg.sender]) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  modifier ifStatus(RequestStatus _status, uint256 _requestId) { 
    if (_status != requests[_requestId].status) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  function CoreWallet() { 
    approved[msg.sender] = true; 
    managers[msg.sender] = true; 
    owner = msg.sender; 
  } 

  function balance() public constant returns (uint256 bal) { 
    bal = address(this).balance; 
    return bal; 
  } 

  function authorizeUser(address _user) ifManager returns (bool success) { 
    approved[_user] = true; 
    success = true; 
    return success; 
  } 

  function unauthorizeUser(address _user) ifManager returns (bool success) { 
    approved[_user] = false; 
    success = true; 
    return success; 
  } 

  function authorizeManager(address _user) ifOwner returns (bool success) { 
    managers[_user] = true; 
    success = true; 
    return success; 
  } 

  function unauthorizeManager(address _user) ifOwner returns (bool success) { 
    managers[_user] = false; 
    success = true; 
    return success; 
  } 

  function withdraw(address _recipient, uint256 _amount) ifManager returns (bool success) { 
    if (address(_recipient).send(_amount)) { 
      Withdraw(_recipient, _amount, msg.sender); 
      success = true; 
    } else { 
      success = false; 
    } 
    return success; 
  } 

  function request(address _recipient, uint256 _amount) ifApproved returns (bool success) { 
    if (_amount < balance()) { 
      success = false; 
    } else { 
      requestCount++; 
      requests[requestCount].status = RequestStatus.Pending; 
      requests[requestCount].amount = _amount; 
      requests[requestCount].recipient = _recipient; 
      success = true; 
      PaymentRequest(requestCount); 
    } 
    return success; 
  } 

  function approve(uint256 _requestId) ifManager ifStatus(RequestStatus.Pending, _requestId) returns (bool success) { 
    if (address(requests[_requestId].recipient).send(requests[_requestId].amount)) { 
      requests[_requestId].status = RequestStatus.Approved; 
      success = true; 
      Approve(_requestId); 
    } else { 
      success = false; 
    } 
    return success; 
  } 
 
  function decline(uint256 _requestId) ifManager ifStatus(RequestStatus.Pending, _requestId) returns (bool success) { 
    requests[_requestId].status = RequestStatus.Declined; 
    success = true; 
    Decline(_requestId); 
    return success; 
  } 

}



A.3. Dao.sol


import "./Token.sol"; 
import "./Interfaces.sol"; 

contract Proposal { 

  struct PledgeData { 
    uint256 startDate; 
    uint256 endDate; 
    mapping (address => uint256) balances; 
    uint256 totalApproves; 
    uint256 totalDeclines; 
  } 

  struct VoteData { 
    uint256 startDate; 
    uint256 endDate; 
    mapping (address => uint256) balances; 
    uint256 totalApproves; 
    uint256 totalDeclines; 
  } 

  enum Status { Pledging, FailPledge, Voting, FailVote, Passed } 

  Status public status = Status.Pledging; 

  address public proposer; 
  address public provider; 
  address public dao; 
  address public badgeLedger; 
  address public tokenLedger; 
  uint256 public minPledges; 
  uint256 public minVotes; 
  bool public dissolve; 
  PledgeData pledgeData; 
  VoteData voteData; 
  bytes32 public environment; 

  event Pledge(address indexed _pledger, uint256 indexed _amount, bool indexed _approve); 
  event Vote(address indexed _pledger, uint256 indexed _amount, bool indexed _approve); 

  modifier onlyAfter(uint _time) { 
    if (now < _time) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  modifier onlyBefore(uint _time) { 
    if (now > _time) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  modifier atStatus(Status _status) { 
    if (_status != status) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  function resolvePledging() onlyAfter(pledgeData.endDate) atStatus(Status.Pledging) internal returns (bool _success) { 
    uint256 _totalpledges = pledgeData.totalApproves + pledgeData.totalDeclines; 
    uint256 _approveppb = partsPerBillion(pledgeData.totalApproves, _totalpledges); 
    if (dissolve) { 
      if (_approveppb <= 800000000) { 
        status = Status.FailPledge; 
      } else { 
        status = Status.Voting; 
      } 
    } else { 
      if (_approveppb <= 500000000) { 
        status = Status.FailPledge; 
      } else { 
        status = Status.Voting; 
      } 
    } 
    _success = true; 
    return _success; 
  } 

  function resolveFailPledge() onlyAfter(pledgeData.endDate) atStatus(Status.FailPledge) internal returns (bool _success) { 
  } 

  function resolveVoting() onlyAfter(voteData.endDate) atStatus(Status.Voting) internal returns (bool _success) { 
  } 
  
  function resolveFailVote() onlyAfter(voteData.endDate) atStatus(Status.Voting) internal returns (bool _success) { 
  } 

  function Proposal(address _config, address _badgeledger, address _tokenledger, bytes32 _environment, bool _dissolve) { 
    proposer = tx.origin; 
    dao = msg.sender; 
    badgeLedger = _badgeledger; 
    tokenLedger = _tokenledger; 
    minPledges = ConfigInterface(_config).getConfigUint("pledges:minimum"); 
    minVotes = ConfigInterface(_config).getConfigUint("votes:minimum") * 1000000000; 
    provider = ConfigInterface(_config).getConfigAddress("provider:address"); 
    pledgeData.totalApproves = 0; 
    pledgeData.totalDeclines = 0; 
    voteData.totalApproves = 0; 
    voteData.totalDeclines = 0; 
    pledgeData.startDate = now; 
    dissolve = _dissolve; 
    environment = _environment; 
    if (dissolve) { 
      if (environment == "mainnet") pledgeData.endDate = now + 1 weeks; 
      if (environment == "testnet") pledgeData.endDate = now + 20 minutes; 
      if (environment == "morden") pledgeData.endDate = now + 1 days; 
    } else { 
      if (environment == "mainnet") pledgeData.endDate = now + 1 years; 
      if (environment == "testnet") pledgeData.endDate = now + 20 minutes; 
      if (environment == "morden") pledgeData.endDate = now + 1 days; 
    } 
    environment = environment; 
  } 

  function partsPerBillion(uint256 _a, uint256 _c) returns (uint256 b) { 
    b = (1000000000 * _a + _c / 2) / _c; 
    return b; 
  } 

  function calcShare(uint256 _antecedent, uint256 _consequent, uint256 _amount) returns (uint256 share) { 
    uint256 _ppb = partsPerBillion(_antecedent, _consequent); 
    share = ((_ppb * _amount) / 1000000000); 
    return share; 
  } 

  function pledgeApprove(uint256 _amount) returns (bool success) { 
    return pledge(true, _amount); 
  } 
 
  function pledgeDecline(uint256 _amount) returns (bool success) { 
    return pledge(false, _amount); 
  } 

  function pledge(bool _pledge, uint256 _amount) onlyAfter(pledgeData.startDate) onlyBefore(pledgeData.endDate) internal returns (bool success) { 
    if (!Badge(badgeLedger).transferFrom(msg.sender, address(this), _amount)) { 
      success = false; 
    } else { 
      if (_pledge == true) pledgeData.totalApproves += _amount; 
      if (_pledge == false) pledgeData.totalDeclines += _amount; 
      pledgeData.balances[msg.sender] = _amount; 
      Pledge(msg.sender, _amount, _pledge); 
      success = true; 
    } 
    return success; 
  } 


  function getInfo() public constant returns (uint8 istatus, uint256 pstartdate, uint256 penddate, uint256 papproves, uint256 pdeclines, uint256 ptotals, uint256 vstartdate, uint256 venddate, uint256 vapproves, uint256 vdeclines, uint256 vtotals) { 
    (pstartdate, penddate, papproves, pdeclines, ptotals) = (pledgeData.startDate, pledgeData.endDate, pledgeData.totalApproves, pledgeData.totalDeclines, (pledgeData.totalApproves + pledgeData.totalDeclines)); 
    (vstartdate, venddate, vapproves, vdeclines, vtotals) = (voteData.startDate, voteData.endDate, voteData.totalApproves, voteData.totalDeclines, (voteData.totalApproves + voteData.totalDeclines)); 
    return (getStatus(), pstartdate, penddate, papproves, pdeclines, ptotals, vstartdate, venddate, vapproves, vdeclines, vtotals); 
  } 

  function getStatus() public constant returns (uint8 status) { 
    return uint8(Status.Voting); 
  } 

  function getUserInfo(address _user) public constant returns (uint256 pledgecount, uint256 votecount) { 
    return (pledgeData.balances[_user], voteData.balances[_user]); 
  } 

  function getMyInfo() public constant returns (uint256 pledgecount, uint256 votecount) { 
    return getUserInfo(msg.sender); 
  } 

  function voteApprove(uint256 _amount) returns (bool success) { 
    return vote(true, _amount); 
  } 
 
  function voteDecline(uint256 _amount) returns (bool success) { 
    return vote(false, _amount); 
  } 


  function vote(bool _vote, uint256 _amount) atStatus(Status.Voting) onlyAfter(voteData.startDate) onlyBefore(voteData.endDate) internal returns (bool success) { 
    if (!Token(tokenLedger).transferFrom(msg.sender, address(this), _amount)) { 
      success = false; 
    } else { 
      if (_vote == true) voteData.totalApproves += _amount; 
      if (_vote == false) voteData.totalDeclines += _amount; 
      voteData.balances[msg.sender] = _amount; 
      Vote(msg.sender, _amount, _vote); 
      success = true; 
    } 
    return success; 
  } 

  function releaseBadges() onlyAfter(pledgeData.endDate) returns (bool success) { 
    return true; 
  } 

  function releaseTokens() onlyAfter(voteData.endDate) returns (bool success) { 
    return true; 
  } 

  function budget() public constant returns (uint256 _weibudget) { 
    return address(this).balance; 
  } 

} 

contract Dao { 
  
  struct ProposalData { 
    uint256 budget; 
    bytes32 document; 
  } 

  address public config; 
  address public owner; 
  address public tokenLedger; 
  address public badgeLedger; 
  mapping (uint256 => address) tokenSales; 
  mapping (address => ProposalData) proposals; 
  mapping (uint256 => address) proposalIndex; 
  uint256 public proposalsCount; 
  bytes32 public environment; 

  enum Status { Pledging, Voting, Completed } 

  event NewProposal(address indexed _proposal, bytes32 indexed _document, uint256 indexed _budget); 

  function Dao(address _config) { 
    config = _config; 
    owner = msg.sender; 
    tokenLedger = ConfigInterface(config).getConfigAddress("ledger"); 
    environment = ConfigInterface(config).getConfigBytes("environment"); 
    badgeLedger = Token(tokenLedger).badgeLedger(); 
    proposalsCount = 0; 
  } 

  function iPropose(bytes32 _document, uint256 _weibudget, bool _dissolve) internal returns (bool success, address proposal) { 
    if (Badge(badgeLedger).balanceOf(msg.sender) <= 0) throw; 
    if (_weibudget > funds()) throw; 
    proposal = new Proposal(config, badgeLedger, tokenLedger, environment, _dissolve); 
    proposals[proposal].budget = _weibudget; 
    proposals[proposal].document = _document; 
    proposalsCount++; 
    proposalIndex[proposalsCount] = proposal; 
    NewProposal(proposal, _document, _weibudget); 
    return (true, proposal); 
  } 

  function propose(bytes32 _document, uint256 _weibudget) returns (bool success, address proposal) { 
    if (Badge(badgeLedger).balanceOf(msg.sender) <= 0) return (false, 0x0000000000000000000000000000000000000000); 
    (success, proposal) = iPropose(_document, _weibudget, false); 
    if (success) { 
      if (proposal.send(_weibudget)) return (success, proposal); 
    } else { 
      success = false; 
      return (success, 0x0000000000000000000000000000000000000000); 
    } 
  } 

  function proposeDissolve(bytes32 _document) returns (bool success, address proposal) { 
    if (Badge(badgeLedger).balanceOf(msg.sender) <= 0) return (false, 0x0000000000000000000000000000000000000000); 
    uint256 _weibudget = funds(); 
    if (success) { 
      if (proposal.send(_weibudget)) return (success, proposal); 
    } else { 
      success = false; 
      return (success, 0x0000000000000000000000000000000000000000); 
    } 
  } 

  function getProposal(uint256 _index) public constant returns (address proposal) { 
    return proposalIndex[_index]; 
  } 

  function funds() public constant returns (uint256 weifunds) { 
    return address(this).balance; 
  } 

}



A.4. GoldTxFeePool.sol


import "./Token.sol"; 
import "./Interfaces.sol"; 

contract Collector { 
  address public owner; 
  address public dgdTokens; 
  address public txFeePool; 
  uint256 public payoutPeriod; 

  modifier ifTxFeePool() { 
    if (msg.sender != txFeePool) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  function Collector(address _owner, address _dgdtokens, uint256 _payoutperiod) { 
    owner = _owner; 
    dgdTokens = _dgdtokens; 
    txFeePool = msg.sender; 
    payoutPeriod = _payoutperiod; 
  } 

  function collect() ifTxFeePool returns (bool _success) { 
    _success = true; 
    return _success; 
  } 

  function withdraw() ifTxFeePool returns (bool _success) { 
    _success = true; 
    return _success; 
  } 
} 

contract GoldTxFeePool { 

  struct Period { 
    uint256 collectionStart; 
    uint256 collectionEnd; 
    mapping(address => address) collectors; 
  } 

  address public dgxTokens; 
  address public dgdTokens; 
  bytes32 public environment; 
  uint256 public collectionDuration; 
  uint256 public periodLength; 
  uint256 public periodCount; 
  mapping (uint256 => Period) periods; 

  modifier afterRecent() { 
    if (now < periods[periodCount].collectionEnd) { 
      throw; 
    } else { 
      _ 
    } 
  } 

  function GoldTxFeePool(address _dgxTokens, address _dgdTokens, bytes32 _environment) { 
    dgxTokens = _dgxTokens; 
    dgdTokens = _dgdTokens; 
    environment = _environment; 
    periodCount = 1; 

    if (environment == "testnet") { 
      collectionDuration = 5 minutes; 
      periodLength = 10 minutes; 
    } 
    if (environment == "morden") { 
      collectionDuration = 10 minutes; 
      periodLength = 30 minutes; 
    } 
    if (environment == "mainnet") { 
      collectionDuration = 7 days; 
      periodLength = 90 days; 
    } 
    periods[periodCount].collectionStart = now + periodLength; 
    periods[periodCount].collectionEnd = periods[periodCount].collectionStart + collectionDuration; 
  } 

  function newPeriod() afterRecent returns (bool _success) { 
    uint256 _newstart = periods[periodCount].collectionStart + periodLength; 
    uint256 _newend = periods[periodCount].collectionEnd + periodLength; 
    periodCount++; 
    periods[periodCount].collectionStart = _newstart; 
    periods[periodCount].collectionEnd = _newend; 
    _success = true; 
    return _success; 
  } 

  function getPeriodInfo() returns (uint256 _start, uint256 _end) { 
    _start = periods[periodCount].collectionStart; 
    _end = periods[periodCount].collectionEnd; 
    return (_start, _end); 
  } 

  function collect() { 
  } 

  function withdraw() { 
  } 
}



A.5. Inferfaces.sol


/// @title DigixDAO Contract Interfaces 

contract ConfigInterface { 
  address public owner; 
  mapping (address => bool) admins; 
  mapping (bytes32 => address) addressMap; 
  mapping (bytes32 => bool) boolMap; 
  mapping (bytes32 => bytes32) bytesMap; 
  mapping (bytes32 => uint256) uintMap; 

  /// @notice setConfigAddress sets configuration `_key` to `_val` 
  /// @param _key The key name of the configuration. 
  /// @param _val The value of the configuration. 
  /// @return Whether the configuration setting was successful or not. 
  function setConfigAddress(bytes32 _key, address _val) returns (bool success); 

  /// @notice setConfigBool sets configuration `_key` to `_val` 
  /// @param _key The key name of the configuration. 
  /// @param _val The value of the configuration. 
  /// @return Whether the configuration setting was successful or not. 
  function setConfigBool(bytes32 _key, bool _val) returns (bool success); 

  /// @notice setConfigBytes sets configuration `_key` to `_val` 
  /// @param _key The key name of the configuration. 
  /// @param _val The value of the configuration. 
  /// @return Whether the configuration setting was successful or not. 
  function setConfigBytes(bytes32 _key, bytes32 _val) returns (bool success); 

  /// @notice setConfigUint `_key` to `_val` 
  /// @param _key The key name of the configuration. 
  /// @param _val The value of the configuration. 
  /// @return Whether the configuration setting was successful or not. 
  function setConfigUint(bytes32 _key, uint256 _val) returns (bool success); 
 
  /// @notice getConfigAddress gets configuration `_key`'s value 
  /// @param _key The key name of the configuration. 
  /// @return The configuration value 
  function getConfigAddress(bytes32 _key) returns (address val); 

  /// @notice getConfigBool gets configuration `_key`'s value 
  /// @param _key The key name of the configuration. 
  /// @return The configuration value 
  function getConfigBool(bytes32 _key) returns (bool val); 

  /// @notice getConfigBytes gets configuration `_key`'s value 
  /// @param _key The key name of the configuration. 
  /// @return The configuration value 
  function getConfigBytes(bytes32 _key) returns (bytes32 val); 

  /// @notice getConfigUint gets configuration `_key`'s value 
  /// @param _key The key name of the configuration. 
  /// @return The configuration value 
  function getConfigUint(bytes32 _key) returns (uint256 val); 

  /// @notice addAdmin sets `_admin` as configuration admin 
  /// @return Whether the configuration setting was successful or not.  
  function addAdmin(address _admin) returns (bool success); 

  /// @notice removeAdmin removes  `_admin`'s rights 
  /// @param _admin The key name of the configuration. 
  /// @return Whether the configuration setting was successful or not.  
  function removeAdmin(address _admin) returns (bool success); 

} 

contract TokenInterface { 

  mapping (address => uint256) balances; 
  mapping (address => mapping (address => uint256)) allowed; 
  mapping (address => bool) seller; 

  address config; 
  address owner; 
  address dao; 
  address public badgeLedger; 
  bool locked; 

  /// @return total amount of tokens 
  uint256 public totalSupply; 

  /// @param _owner The address from which the balance will be retrieved 
  /// @return The balance 
  function balanceOf(address _owner) constant returns (uint256 balance); 

  /// @notice send `_value` tokens to `_to` from `msg.sender` 
  /// @param _to The address of the recipient 
  /// @param _value The amount of tokens to be transfered 
  /// @return Whether the transfer was successful or not 
  function transfer(address _to, uint256 _value) returns (bool success); 

  /// @notice send `_value` tokens to `_to` from `_from` on the condition it is approved by `_from` 
  /// @param _from The address of the sender 
  /// @param _to The address of the recipient 
  /// @param _value The amount of tokens to be transfered 
  /// @return Whether the transfer was successful or not 
  function transferFrom(address _from, address _to, uint256 _value) returns (bool success); 

  /// @notice `msg.sender` approves `_spender` to spend `_value` tokens on its behalf 
  /// @param _spender The address of the account able to transfer the tokens 
  /// @param _value The amount of tokens to be approved for transfer 
  /// @return Whether the approval was successful or not 
  function approve(address _spender, uint256 _value) returns (bool success); 

  /// @param _owner The address of the account owning tokens 
  /// @param _spender The address of the account able to transfer the tokens 
  /// @return Amount of remaining tokens of _owner that _spender is allowed to spend 
  function allowance(address _owner, address _spender) constant returns (uint256 remaining); 

  /// @notice mint `_amount` of tokens to `_owner` 
  /// @param _owner The address of the account receiving the tokens 
  /// @param _amount The amount of tokens to mint 
  /// @return Whether or not minting was successful 
  function mint(address _owner, uint256 _amount) returns (bool success); 

  /// @notice mintBadge Mint `_amount` badges to `_owner` 
  /// @param _owner The address of the account receiving the tokens 
  /// @param _amount The amount of tokens to mint 
  /// @return Whether or not minting was successful 
  function mintBadge(address _owner, uint256 _amount) returns (bool success); 

  function registerDao(address _dao) returns (bool success); 
  function registerSeller(address _tokensales) returns (bool success); 

  event Transfer(address indexed _from, address indexed _to, uint256 indexed _value); 
  event Mint(address indexed _recipient, uint256 indexed _amount); 
  event Approval(address indexed _owner, address indexed _spender, uint256 indexed _value); 
} 

contract TokenSalesInterface { 

  struct SaleProxy { 
    address payout; 
    bool isProxy; 
  } 

  struct SaleStatus { 
    bool founderClaim; 
    uint256 releasedTokens; 
    uint256 releasedBadges; 
    uint256 claimers; 
  } 

  struct Info { 
    uint256 totalWei; 
    uint256 totalCents; 
    uint256 realCents; 
    uint256 amount; 
  } 

  struct SaleConfig { 
    uint256 startDate; 
    uint256 periodTwo; 
    uint256 periodThree; 
    uint256 endDate; 
    uint256 goal; 
    uint256 cap; 
    uint256 badgeCost; 
    uint256 founderAmount; 
    address founderWallet; 
  } 

  struct Buyer { 
    uint256 centsTotal; 
    uint256 weiTotal; 
    bool claimed; 
  } 

  Info saleInfo; 
  SaleConfig saleConfig; 
  SaleStatus saleStatus; 

  address config; 
  address owner; 
  bool locked; 

  uint256 public ethToCents; 

  mapping (address => Buyer) buyers; 
  mapping (address => SaleProxy) proxies; 

  /// @notice Calculates the parts per billion 1⁄1,000,000,000 of `_a` to `_b` 
  /// @param _a The antecedent 
  /// @param _c The consequent 
  /// @return Part per billion value 
  function ppb(uint256 _a, uint256 _c) public constant returns (uint256 b); 
 

  /// @notice Calculates the share from `_total` based on `_contrib` 
  /// @param _contrib The contributed amount in USD 
  /// @param _total The total amount raised in USD 
  /// @return Total number of shares 
  function calcShare(uint256 _contrib, uint256 _total) public constant returns (uint256 share); 

  /// @notice Calculates the current USD cents value of `_wei` 
  /// @param _wei the amount of wei 
  /// @return The USD cents value 
  function weiToCents(uint256 _wei) public constant returns (uint256 centsvalue); 

  function proxyPurchase(address _user) returns (bool success); 

  /// @notice Send msg.value purchase for _user.  
  /// @param _user The account to be credited 
  /// @return Success if purchase was accepted 
  function purchase(address _user, uint256 _amount) private returns (bool success); 

  /// @notice Get crowdsale information for `_user` 
  /// @param _user The account to be queried 
  /// @return `centstotal` the total amount of USD cents contributed 
  /// @return `weitotal` the total amount in wei contributed 
  /// @return `share` the current token shares earned 
  /// @return `badges` the number of proposer badges earned 
  /// @return `claimed` is true if the tokens and badges have been claimed 
  function userInfo(address _user) public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed); 

  /// @notice Get the crowdsale information from msg.sender (see userInfo) 
  function myInfo() public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed); 

  /// @notice get the total amount of wei raised for the crowdsale 
  /// @return The amount of wei raised 
  function totalWei() public constant returns (uint); 

  /// @notice get the total USD value in cents raised for the crowdsale 
  /// @return the amount USD cents 
  function totalCents() public constant returns (uint); 

  /// @notice get the current crowdsale information 
  /// @return `startsale` The unix timestamp for the start of the crowdsale and the first period modifier 
  /// @return `two` The unix timestamp for the start of the second period modifier 
  /// @return `three` The unix timestamp for the start of the third period modifier 
  /// @return `endsale` The unix timestamp of the end of crowdsale 
  /// @return `totalwei` The total amount of wei raised 
  /// @return `totalcents` The total number of USD cents raised 
  /// @return `amount` The amount of DGD tokens available for the crowdsale 
  /// @return `goal` The USD value goal for the crowdsale 
  /// @return `famount` Founders endowment 
  /// @return `faddress` Founder wallet address 
  /*function getSaleInfo() public constant returns (uint256 startsale, uint256 two, uint256 three, uint256 endsale, uint256 totalwei, uint256 totalcents, uint256 amount, uint256 goal, uint256 famount, address faddress);*/ 

  function claimFor(address _user) returns (bool success); 

  /// @notice Allows msg.sender to claim the DGD tokens and badges if the goal is reached or refunds the ETH contributed if goal is not reached at the end of the crowdsale 
  function claim() returns (bool success); 

  function claimFounders() returns (bool success); 

  /// @notice See if the crowdsale goal has been reached 
  function goalReached() public constant returns (bool reached); 

  /// @notice Get the current sale period 
  /// @return `saleperiod` 0 = Outside of the crowdsale period, 1 = First reward period, 2 = Second reward period, 3 = Final crowdsale period. 
  function getPeriod() public constant returns (uint saleperiod); 

  /// @notice Get the date for the start of the crowdsale 
  /// @return `date` The unix timestamp for the start 
  function startDate() public constant returns (uint date); 
  
  /// @notice Get the date for the second reward period of the crowdsale 
  /// @return `date` The unix timestamp for the second period 
  function periodTwo() public constant returns (uint date); 

  /// @notice Get the date for the final period of the crowdsale 
  /// @return `date` The unix timestamp for the final period 
  function periodThree() public constant returns (uint date); 

  /// @notice Get the date for the end of the crowdsale 
  /// @return `date` The unix timestamp for the end of the crowdsale 
  function endDate() public constant returns (uint date); 

  /// @notice Check if crowdsale has ended 
  /// @return `ended` If the crowdsale has ended 
  
  function isEnded() public constant returns (bool ended); 

  /// @notice Send raised funds from the crowdsale to the DAO 
  /// @return `success` if the send succeeded 
  function sendFunds() public returns (bool success); 
 
  //function regProxy(address _payment, address _payout) returns (bool success); 
  function regProxy(address _payout) returns (bool success); 

  function getProxy(address _payout) public returns (address proxy); 
  
  function getPayout(address _proxy) public returns (address payout, bool isproxy); 

  function unlock() public returns (bool success); 

  function getSaleStatus() public constant returns (bool fclaim, uint256 reltokens, uint256 relbadges, uint256 claimers); 

  function getSaleInfo() public constant returns (uint256 weiamount, uint256 cents, uint256 realcents, uint256 amount); 

  function getSaleConfig() public constant returns (uint256 start, uint256 two, uint256 three, uint256 end, uint256 goal, uint256 cap, uint256 badgecost, uint256 famount, address fwallet); 
  
  event Purchase(uint256 indexed _exchange, uint256 indexed _rate, uint256 indexed _cents); 
  event Claim(address indexed _user, uint256 indexed _amount, uint256 indexed _badges); 

} 



A.6. Token.sol


import "./Interfaces.sol"; 

contract Badge  { 
  mapping (address => uint256) balances; 
  mapping (address => mapping (address => uint256)) allowed; 

  address public owner; 
  bool public locked; 

  /// @return total amount of tokens 
  uint256 public totalSupply; 

  modifier ifOwner() { 
    if (msg.sender != owner) { 
      throw; 
    } else { 
      _ 
    } 
  } 


  event Transfer(address indexed _from, address indexed _to, uint256 _value); 
  event Mint(address indexed _recipient, uint256 indexed _amount); 
  event Approval(address indexed _owner, address indexed _spender, uint256  _value); 

  function Badge() { 
    owner = msg.sender; 
  } 

  function safeToAdd(uint a, uint b) returns (bool) { 
    return (a + b >= a); 
  } 

  function addSafely(uint a, uint b) returns (uint result) { 
    if (!safeToAdd(a, b)) { 
      throw; 
    } else { 
      result = a + b; 
      return result; 
    } 
  } 

  function safeToSubtract(uint a, uint b) returns (bool) { 
    return (b <= a); 
  } 

  function subtractSafely(uint a, uint b) returns (uint) { 
    if (!safeToSubtract(a, b)) throw; 
    return a - b; 
  } 

  function balanceOf(address _owner) constant returns (uint256 balance) { 
    return balances[_owner]; 
  } 

  function transfer(address _to, uint256 _value) returns (bool success) { 
    if (balances[msg.sender] >= _value && _value > 0) { 
      balances[msg.sender] = subtractSafely(balances[msg.sender], _value); 
      balances[_to] = addSafely(_value, balances[_to]); 
      Transfer(msg.sender, _to, _value); 
      success = true; 
    } else { 
      success = false; 
    } 
    return success; 
  } 

  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) { 
    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) { 
      balances[_to] = addSafely(balances[_to], _value); 
      balances[_from] = subtractSafely(balances[_from], _value); 
      allowed[_from][msg.sender] = subtractSafely(allowed[_from][msg.sender], _value); 
      Transfer(_from, _to, _value); 
      return true; 
    } else { 
      return false; 
    } 
  } 

  function approve(address _spender, uint256 _value) returns (bool success) { 
    allowed[msg.sender][_spender] = _value; 
    Approval(msg.sender, _spender, _value); 
    success = true; 
    return success; 
  } 

  function allowance(address _owner, address _spender) constant returns (uint256 remaining) { 
    remaining = allowed[_owner][_spender]; 
    return remaining; 
  } 

  function mint(address _owner, uint256 _amount) ifOwner returns (bool success) { 
    totalSupply = addSafely(totalSupply, _amount); 
    balances[_owner] = addSafely(balances[_owner], _amount); 
    Mint(_owner, _amount); 
    return true; 
  } 

  function setOwner(address _owner) ifOwner returns (bool success) { 
    owner = _owner; 
    return true; 
  } 

} 

contract Token { 

  address public owner; 
  address public config; 
  bool public locked; 
  address public dao; 
  address public badgeLedger; 
  uint256 public totalSupply; 

  mapping (address => uint256) balances; 
  mapping (address => mapping (address => uint256)) allowed; 
  mapping (address => bool) seller; 

  /// @return total amount of tokens 

  modifier ifSales() { 
    if (!seller[msg.sender]) throw; 
    _ 
  } 

  modifier ifOwner() { 
    if (msg.sender != owner) throw; 
    _ 
  } 

  modifier ifDao() { 
    if (msg.sender != dao) throw; 
    _ 
  } 

  event Transfer(address indexed _from, address indexed _to, uint256 _value); 
  event Mint(address indexed _recipient, uint256  _amount); 
  event Approval(address indexed _owner, address indexed _spender, uint256  _value); 

  function Token(address _config) { 
    config = _config; 
    owner = msg.sender; 
    address _initseller = ConfigInterface(_config).getConfigAddress("sale1:address"); 
    seller[_initseller] = true; 
    badgeLedger = new Badge(); 
    locked = false; 
  } 

  function safeToAdd(uint a, uint b) returns (bool) { 
    return (a + b >= a); 
  } 

  function addSafely(uint a, uint b) returns (uint result) { 
    if (!safeToAdd(a, b)) { 
      throw; 
    } else { 
      result = a + b; 
      return result; 
    } 
  } 

  function safeToSubtract(uint a, uint b) returns (bool) { 
    return (b <= a); 
  } 

  function subtractSafely(uint a, uint b) returns (uint) { 
    if (!safeToSubtract(a, b)) throw; 
    return a - b; 
  } 

  function balanceOf(address _owner) constant returns (uint256 balance) { 
    return balances[_owner]; 
  } 

  function transfer(address _to, uint256 _value) returns (bool success) { 
    if (balances[msg.sender] >= _value && _value > 0) { 
      balances[msg.sender] = subtractSafely(balances[msg.sender], _value); 
      balances[_to] = addSafely(balances[_to], _value); 
      Transfer(msg.sender, _to, _value); 
      success = true; 
    } else { 
      success = false; 
    } 
    return success; 
  } 

  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) { 
    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) { 
      balances[_to] = addSafely(balances[_to], _value); 
      balances[_from] = subtractSafely(balances[_from], _value); 
      allowed[_from][msg.sender] = subtractSafely(allowed[_from][msg.sender], _value); 
      Transfer(_from, _to, _value); 
      return true; 
    } else { 
      return false; 
    } 
  } 

  function approve(address _spender, uint256 _value) returns (bool success) { 
    allowed[msg.sender][_spender] = _value; 
    Approval(msg.sender, _spender, _value); 
    success = true; 
    return success; 
  } 

  function allowance(address _owner, address _spender) constant returns (uint256 remaining) { 
    remaining = allowed[_owner][_spender]; 
    return remaining; 
  } 
  function mint(address _owner, uint256 _amount) ifSales returns (bool success) { 
    totalSupply = addSafely(_amount, totalSupply); 
    balances[_owner] = addSafely(balances[_owner], _amount); 
    return true; 
  } 

  function mintBadge(address _owner, uint256 _amount) ifSales returns (bool success) { 
    if (!Badge(badgeLedger).mint(_owner, _amount)) return false; 
    return true; 
  } 

  function registerDao(address _dao) ifOwner returns (bool success) { 
    if (locked == true) return false; 
    dao = _dao; 
    locked = true; 
    return true; 
  } 

  function setDao(address _newdao) ifDao returns (bool success) { 
    dao = _newdao; 
    return true; 
  } 

  function isSeller(address _query) returns (bool isseller) { 
    return seller[_query]; 
  } 

  function registerSeller(address _tokensales) ifDao returns (bool success) { 
    seller[_tokensales] = true; 
    return true; 
  } 

  function unregisterSeller(address _tokensales) ifDao returns (bool success) { 
    seller[_tokensales] = false; 
    return true; 
  } 

  function setOwner(address _newowner) ifDao returns (bool success) { 
    if(Badge(badgeLedger).setOwner(_newowner)) { 
      owner = _newowner; 
      success = true; 
    } else { 
      success = false; 
    } 
    return success; 
  } 

}



A.7. TokenSales.sol


import "./Interfaces.sol"; 

contract ProxyPayment { 

  address payout; 
  address tokenSales; 
  address owner; 
 
  function ProxyPayment(address _payout, address _tokenSales) { 
    payout = _payout; 
    tokenSales = _tokenSales; 
    owner = _payout; 
  } 

  function () { 
    if (!TokenSalesInterface(tokenSales).proxyPurchase.value(msg.value).gas(106000)(payout)) throw; 
  } 

} 



contract TokenSales is TokenSalesInterface { 

  modifier ifOwner() { 
    if (msg.sender != owner) throw; 
    _ 
  } 

  modifier ifOOrigin() { 
    if (tx.origin != owner) throw; 
    _ 
  } 

  mapping (address => address) proxyPayouts; 
  uint256 public WEI_PER_ETH = 1000000000000000000; 
  uint256 public BILLION = 1000000000; 
  uint256 public CENTS = 100; 


  function TokenSales(address _config) { 
    owner = msg.sender; 
    config = _config; 
    saleStatus.founderClaim = false; 
    saleStatus.releasedTokens = 0; 
    saleStatus.releasedBadges = 0; 
    saleStatus.claimers = 0; 
    saleConfig.startDate = ConfigInterface(_config).getConfigUint("sale1:period1"); 
    saleConfig.periodTwo = ConfigInterface(_config).getConfigUint("sale1:period2"); 
    saleConfig.periodThree = ConfigInterface(_config).getConfigUint("sale1:period3"); 
    saleConfig.endDate = ConfigInterface(_config).getConfigUint("sale1:end"); 
    saleConfig.founderAmount = ConfigInterface(_config).getConfigUint("sale1:famount") * BILLION; 
    saleConfig.founderWallet = ConfigInterface(_config).getConfigAddress("sale1:fwallet"); 
    saleConfig.goal = ConfigInterface(_config).getConfigUint("sale1:goal") * CENTS; 
    saleConfig.cap = ConfigInterface(_config).getConfigUint("sale1:cap") * CENTS; 
    saleConfig.badgeCost = ConfigInterface(_config).getConfigUint("sale1:badgecost") * CENTS; 
    saleInfo.amount = ConfigInterface(_config).getConfigUint("sale1:amount") * BILLION; 
    saleInfo.totalWei = 0; 
    saleInfo.totalCents = 0; 
    saleInfo.realCents; 
    saleStatus.founderClaim = false; 
    locked = true; 
  } 

  function () { 
    if (getPeriod() == 0) throw; 
    uint256 _amount = msg.value; 
    address _sender; 
    if (proxies[msg.sender].isProxy == true) { 
      _sender = proxies[msg.sender].payout; 
    } else { 
      _sender = msg.sender; 
    } 
    if (!purchase(_sender, _amount)) throw; 
  } 

  function proxyPurchase(address _user) returns (bool success) { 
    return purchase(_user, msg.value); 
  } 

  function purchase(address _user, uint256 _amount) private returns (bool success) { 
    uint256 _cents = weiToCents(_amount); 
    if ((saleInfo.realCents + _cents) > saleConfig.cap) return false; 
    uint256 _wei = _amount; 
    uint256 _modifier; 
    uint _period = getPeriod(); 
    if ((_period == 0) || (_cents == 0)) { 
      return false; 
    } else { 
      if (_period == 3) _modifier = 100; 
      if (_period == 2) _modifier = 115; 
      if (_period == 1) _modifier = 130; 
      uint256 _creditwei = _amount; 
      uint256 _creditcents = (weiToCents(_creditwei) * _modifier * 10000) / 1000000 ; 
      buyers[_user].centsTotal += _creditcents; 
      buyers[_user].weiTotal += _creditwei; 
      saleInfo.totalCents += _creditcents; 
      saleInfo.realCents += _cents; 
      saleInfo.totalWei += _creditwei; 
      Purchase(ethToCents, _modifier, _creditcents); 
      return true; 
    } 
  } 
 
  function ppb(uint256 _a, uint256 _c) public constant returns (uint256 b) { 
    b = (BILLION * _a + _c / 2) / _c; 
    return b; 
  } 

  function calcShare(uint256 _contrib, uint256 _total) public constant returns (uint256 share) { 
    uint256 _ppb = ppb(_contrib, _total); 
    share = ((_ppb * saleInfo.amount) / BILLION); 
    return share; 
  } 

  function weiToCents(uint256 _wei) public constant returns (uint256 centsvalue) { 
    centsvalue = ((_wei * 100000 / WEI_PER_ETH) * ethToCents) / 100000; 
    return centsvalue; 
  } 

  function setEthToCents(uint256 _eth) ifOwner returns (bool success) { 
    ethToCents = _eth; 
    success = true; 
    return success; 
  } 


  function getSaleStatus() public constant returns (bool fclaim, uint256 reltokens, uint256 relbadges, uint256 claimers) { 
    return (saleStatus.founderClaim, saleStatus.releasedTokens, saleStatus.releasedBadges, saleStatus.claimers); 
  } 

  function getSaleInfo() public constant returns (uint256 weiamount, uint256 cents, uint256 realcents, uint256 amount) { 
    return (saleInfo.totalWei, saleInfo.totalCents, saleInfo.realCents, saleInfo.amount); 
  } 


  function getSaleConfig() public constant returns (uint256 start, uint256 two, uint256 three, uint256 end, uint256 goal, uint256 cap, uint256 badgecost, uint256 famount, address fwallet) { 
    return (saleConfig.startDate, saleConfig.periodTwo, saleConfig.periodThree, saleConfig.endDate, saleConfig.goal, saleConfig.cap, saleConfig.badgeCost, saleConfig.founderAmount, saleConfig.founderWallet); 
  } 

  function goalReached() public constant returns (bool reached) { 
    reached = (saleInfo.totalCents >= saleConfig.goal); 
    return reached; 
  } 

  function claim() returns (bool success) { 
    return claimFor(msg.sender); 
  } 

  function claimFor(address _user) returns (bool success) { 
    if ( (now < saleConfig.endDate) || (buyers[_user].claimed == true) ) { 
      return true; 
    } 
  
    if (!goalReached()) { 
      if (!address(_user).send(buyers[_user].weiTotal)) throw; 
      buyers[_user].claimed = true; 
      return true; 
    } 

    if (goalReached()) { 
      address _tokenc = ConfigInterface(config).getConfigAddress("ledger"); 
      uint256 _tokens = calcShare(buyers[_user].centsTotal, saleInfo.totalCents); 
      uint256 _badges = buyers[_user].centsTotal / saleConfig.badgeCost; 
      if ((TokenInterface(_tokenc).mint(msg.sender, _tokens)) && (TokenInterface(_tokenc).mintBadge(_user, _badges))) { 
        saleStatus.releasedTokens += _tokens; 
        saleStatus.releasedBadges += _badges; 
        saleStatus.claimers += 1; 
        buyers[_user].claimed = true; 
        Claim(_user, _tokens, _badges); 
        return true; 
      } else { 
        return false; 
      } 
    } 

  } 

  function claimFounders() returns (bool success) { 
    if (saleStatus.founderClaim == true) return false; 
    if (now < saleConfig.endDate) return false; 
    if (!goalReached()) return false; 
    address _tokenc = ConfigInterface(config).getConfigAddress("ledger"); 
    uint256 _tokens = saleConfig.founderAmount; 
    uint256 _badges = 4; 
    address _faddr = saleConfig.founderWallet; 
    if ((TokenInterface(_tokenc).mint(_faddr, _tokens)) && (TokenInterface(_tokenc).mintBadge(_faddr, _badges))) { 
      saleStatus.founderClaim = true; 
      saleStatus.releasedTokens += _tokens; 
      saleStatus.releasedBadges += _badges; 
      saleStatus.claimers += 1; 
      Claim(_faddr, _tokens, _badges); 
      return true; 
    } else { 
      return false; 
    } 
  } 

  function getPeriod() public constant returns (uint saleperiod) { 
    if ((now > saleConfig.endDate) || (now < saleConfig.startDate)) { 
      saleperiod = 0; 
      return saleperiod; 
    } 
    if (now >= saleConfig.periodThree) { 
      saleperiod = 3; 
      return saleperiod; 
    } 
    if (now >= saleConfig.periodTwo) { 
      saleperiod = 2; 
      return saleperiod; 
    } 
    if (now < saleConfig.periodTwo) { 
      saleperiod = 1; 
      return saleperiod; 
    } 
  } 

  function userInfo(address _user) public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed) { 
    share = calcShare(buyers[_user].centsTotal, saleInfo.totalCents); 
    badges = buyers[_user].centsTotal / saleConfig.badgeCost; 
    return (buyers[_user].centsTotal, buyers[_user].weiTotal, share, badges, buyers[_user].claimed); 
  } 

  function myInfo() public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed) { 
    return userInfo(msg.sender); 
  } 

  function totalWei() public constant returns (uint) { 
    return saleInfo.totalWei; 
  } 

  function totalCents() public constant returns (uint) { 
    return saleInfo.totalCents; 
  } 

  function startDate() public constant returns (uint date) { 
    return saleConfig.startDate; 
  } 
  
  function periodTwo() public constant returns (uint date) { 
    return saleConfig.periodTwo; 
  } 

  function periodThree() public constant returns (uint date) { 
    return saleConfig.periodThree; 
  } 
 
  function endDate() public constant returns (uint date) { 
    return saleConfig.endDate; 
  } 

  function isEnded() public constant returns (bool ended) { 
    return (now >= endDate()); 
  } 
  
  function sendFunds() public returns (bool success) { 
    if (locked) return false; 
    if (!goalReached()) return false; 
    if (!isEnded()) return false; 
    address _dao = ConfigInterface(config).getConfigAddress("sale1:dao"); 
    if (_dao == 0x0000000000000000000000000000000000000000) return false; 
    return _dao.send(totalWei()); 
  } 

  function regProxy(address _payout) ifOOrigin returns (bool success) { 
    address _proxy = new ProxyPayment(_payout, address(this)); 
    proxies[_proxy].payout = _payout; 
    proxies[_proxy].isProxy = true; 
    proxyPayouts[_payout] = _proxy; 
    return true; 
  } 
  
  function getProxy(address _payout) public returns (address proxy) { 
    return proxyPayouts[_payout]; 
  } 

  function getPayout(address _proxy) public returns (address payout, bool isproxy) { 
    return (proxies[_proxy].payout, proxies[_proxy].isProxy); 
  } 

  function unlock() ifOwner public returns (bool success) { 
    locked = false; 
    return true; 
  } 
}
