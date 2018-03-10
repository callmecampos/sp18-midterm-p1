pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';
import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	using SafeMath for uint;

  address owner;
  uint startTime;
  uint initAmount;
  uint tokensPerWei;
  uint tokensSold;
  uint timeCap = (2**256 - 1);
  Token public tokenReward;
  Queue public queue;

  function Crowdsale() public {
    owner = msg.sender;
    queue = new Queue();
		tokenReward = new Token();
  }

	function SetDetails(uint _initAmount, uint rate, string symbol, string name, uint decimals) public {
		tokensPerWei = rate;
    initAmount = _initAmount;
    startTime = now;
		tokenReward.SetDetails(symbol, name, decimals);
		tokenReward.setBalance(msg.sender, _initAmount);
	}

  function mint(uint amount) {
    tokenReward.mintThing(msg.sender, amount);
  }

  function burn(uint amount) {
    tokenReward.burnThing(msg.sender, amount);
  }

  function buyToken() public payable returns (uint amount) {
    uint _amount = msg.value * tokensPerWei;
    if (!saleComplete() && queue.getFirst() == msg.sender &&
    queue.isWaiting())
        {
            tokenReward.buyThing(owner, msg.sender, _amount);
            tokensSold.add(_amount);
            Purchase(msg.sender, _amount);
            return _amount;
        }
    return 0;
  }

  function refundToken(uint amount) {
    if (saleComplete()) {
      return;
    }
    tokenReward.refundThing(owner, msg.sender, amount);
    tokensSold.sub(amount);
    Refund(msg.sender, amount);
  }

  function setTimeCap(uint cap) public returns(bool) {
    if (isOwner()) {
      timeCap = cap;
      return true;
    }
    return false;
  }

	function cap() external returns (uint) {
		return timeCap;
	}

  function isOwner() private returns(bool) {
    return msg.sender == owner;
  }

  function timeSinceStart() returns(uint) {
    return now - startTime;
  }

  function saleComplete() returns(bool) {
    return timeSinceStart() >= timeCap;
  }

  function receiveFunds() returns(bool) {
    if (saleComplete()) {
      owner.send(this.balance);
    }
  }

  event Purchase(address buyer, uint tokens);
  event Refund(address addr, uint tokens);
}
