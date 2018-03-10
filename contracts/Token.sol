pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';
import './utils/SafeMath.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	using SafeMath for uint;

  string public symbol;
  string public name;
  uint public decimals;
  uint public totalSupply;

  mapping(address => uint256) public balances;
  mapping(address => mapping (address => uint256)) allowed;

  function Token() public {}

	function SetDetails(string _symbol, string _name, uint _decimals) public {
		symbol = _symbol;
    name = _name;
    decimals = _decimals;
	}

  function totalSupply() public constant returns (uint) {
    return totalSupply;
  }

  function balanceOf(address tokenOwner) public constant returns (uint balance) {
    return balances[tokenOwner];
  }

  function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
    return allowed[tokenOwner][spender];
  }

  function transfer(address to, uint tokens) public returns (bool success) {
    balances[msg.sender] = balances[msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    Transfer(msg.sender, to, tokens);
    return true;
  }

  function approve(address spender, uint tokens) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    Approval(msg.sender, spender, tokens);
    return true;
  }

  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
    balances[from] = balances[from].sub(tokens);
    balances[to] = balances[to].add(tokens);
    Transfer(from, to, tokens);
    return true;
  }

  function burn(address addr, uint amount) {
    balances[addr] = balances[addr].sub(amount);
    totalSupply = totalSupply.sub(amount);
    Burned(addr, amount);
  }

  function setBalance(address a, uint b) public {
    balances[a] = b;
  }

  function mintThing(address owner, uint amount) {
    balances[owner].add(amount);
    totalSupply.add(amount);
  }

  function burnThing(address owner, uint amount) {
    balances[owner].sub(amount);
    totalSupply.sub(amount);
  }

  function buyThing(address owner, address buyer, uint amount) {
    balances[owner].sub(amount);
    balances[buyer].add(amount);
  }

  function refundThing(address owner, address refunder, uint amount) {
    balances[refunder].sub(amount);
    balances[owner].add(amount);
  }

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
  event Burned(address burner, uint tokens);
}
