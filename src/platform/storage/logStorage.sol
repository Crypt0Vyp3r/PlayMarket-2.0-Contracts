pragma solidity ^0.4.24;

import '../../common/AgentStorage.sol';
import './logStorageI.sol';

/**
 * @title Logs contract - basic contract for working with logs (only events)
 */
contract LogStorage is LogStorageI, AgentStorage {

  //App events 
  event AddAppEvent(uint32 indexed _store, uint indexed _app, uint32 _hashType, uint32 indexed _appType, uint _price, bool _publish, address _dev, string _hash);
  event SetConfirmationAppEvent(uint32 indexed _store, uint indexed _app, bool _state, address _moderator);
  event ChangeHashAppEvent(uint32 indexed _store, uint indexed _app, string _hash, uint32 _hashType);
  event ChangePublishEvent(uint32 indexed _store, uint indexed _app, bool publish);
  event SetPriceEvent(uint32 indexed _store, uint indexed _app, uint _obj ,uint price);
  event BuyAppEvent(uint32 indexed _store, address indexed _user, address indexed _dev, uint _app, uint _obj, address _node, uint price);
  
  //Ico App events 
  event AddAppICOEvent(uint32 indexed _store, uint _app, string hash, uint32 _hashType);
  event ChangeHashAppICOEvent(uint32 indexed _store, uint indexed _app, string hash, uint32 _hashType);
  
  //Developer events 
  event AddDevEvent(uint32 indexed _store, address indexed _dev, bytes32 _name, bytes32 _info);
  event ChangeNameDevEvent(uint32 indexed _store, address indexed _dev, bytes32 _name, bytes32 _info);
  event SetStoreBlockedDevEvent(uint32 indexed _store, address indexed _dev, bool _state);
  event SetRatingDevEvent(uint32 indexed _store, address indexed _dev, int _rating);
  
  //Node events  
  event AddNodeEvent(uint32 indexed _store, address indexed _node, uint32 _hashType, bytes24 _reserv, string _hash, string _ip, string _coordinates);
  event ConfirmationNodeEvent(uint32 indexed _store, address indexed _node, bool _state);
  event ChangeInfoNodeEvent(uint32 indexed _store, address _node, string _hash, uint32 _hashType, string _ip, string _coordinates);
  
  //Reviews events  
  event FeedbackRatingEvent(uint32 indexed store, address voter, uint indexed _app, uint vote, string description, bytes32 txIndex, uint blocktimestamp);
  
  //ICO events 
  //event releaseICOEvent(address adrDev, uint _app, bool release, address ICO);
  //event newContractEvent(string name, string symbol, address adrDev, uint _app);
  

  /** 
  ** Applications events 
  **/
  function addAppEvent(uint _app, uint32 _hashType, uint32 _appType, uint _price, bool _publish, address _dev, string _hash) external onlyAgentLog {
    emit AddAppEvent(Agents[msg.sender].store, _app, _hashType, _appType, _price, _publish, _dev, _hash);
  }

  function setConfirmationAppEvent(uint _app, bool _state, address _moderator) external onlyAgentLog {
    emit SetConfirmationAppEvent(Agents[msg.sender].store, _app, _state, _moderator);
  }
  
  function changeHashAppEvent(uint _app, string _hash, uint32 _hashType) external onlyAgentLog {
    emit ChangeHashAppEvent(Agents[msg.sender].store, _app, _hash, _hashType);
  }
  
  function changePublishEvent(uint _app, bool _publish) external onlyAgentLog {
    emit ChangePublishEvent(Agents[msg.sender].store, _app, _publish);
  }
  
  function setPriceEvent(uint _app, uint _obj, uint _price) external onlyAgentLog {
    emit SetPriceEvent(Agents[msg.sender].store, _obj, _app, _price);
  }
  
  function buyAppEvent(address _user, address _dev, uint _app, uint _obj, address _node, uint _price) external onlyAgentLog {
    emit BuyAppEvent(Agents[msg.sender].store, _user, _dev, _app, _obj, _node, _price);
  }
  
  /** 
  ** Applications ICO events 
  **/
  function addAppICOEvent(uint _app, string hash, uint32 hashType) external onlyAgentLog {
    emit AddAppICOEvent(Agents[msg.sender].store, _app, hash, hashType);
  }
  
  function changeHashAppICOEvent(uint _app, string hash, uint32 hashType) external onlyAgentLog {
    emit ChangeHashAppICOEvent(Agents[msg.sender].store, _app, hash, hashType);
  }


  /** 
  ** Developers events 
  **/  
  function addDevEvent(address _dev, bytes32 name, bytes32 info) external onlyAgentLog {
    emit AddDevEvent(Agents[msg.sender].store, _dev, name, info);
  }
  
  function changeNameDevEvent(address _dev, bytes32 name, bytes32 info) external onlyAgentLog {
    emit ChangeNameDevEvent(Agents[msg.sender].store, _dev, name, info);
  }
  
  function setStoreBlockedDevEvent(address _dev, bool _state) external onlyAgentLog {
    emit SetStoreBlockedDevEvent(Agents[msg.sender].store, _dev, _state);
  }
  
  function setRatingDevEvent(address _dev, int _rating) external onlyAgentLog {
    emit SetRatingDevEvent(Agents[msg.sender].store, _dev, _rating);
  }
  /** 
  ** Nodes events 
  **/  
  function addNodeEvent(address _node, uint32 _hashType, bytes24 _reserv, string _hash, string _ip, string _coordinates) external onlyAgentLog {
    emit AddNodeEvent(Agents[msg.sender].store, _node, _hashType, _reserv, _hash, _ip, _coordinates);
  }
  
  function confirmationNodeEvent(address _node, bool value) external onlyAgentLog {
    emit ConfirmationNodeEvent(Agents[msg.sender].store, _node, value);
  }

  function changeInfoNodeEvent(address _node,  string _hash, uint32 _hashType, string _ip, string _coordinates) external onlyAgentLog {
    emit ChangeInfoNodeEvent(Agents[msg.sender].store, _node, _hash, _hashType, _ip, _coordinates);
  }

  
  //function releaseICOEvent(address adrDev, uint _app, bool release, address ICO) external onlyAgentLog {
  //  emit releaseICOEvent(adrDev, _app, release, ICO);
  //}  
  
  //function newContractEvent(string name, string symbol, address adrDev, uint _app) external onlyAgentLog {
  //  emit newContractEvent(name, symbol, adrDev, _app);
  //}

  /** 
  ** Feedback Rating event
  **/
  function feedbackRatingEvent(address voter, uint _app, uint vote, string description, bytes32 txIndex, uint blocktimestamp) external onlyAgentLog {
    emit FeedbackRatingEvent(Agents[msg.sender].store, voter, _app, vote, description, txIndex, blocktimestamp);
  }
}