//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";  // Will let us do console logging inside of our smart contracts during development.

contract Token {
    string public name;
    string public symbol;
    uint256 public decimals = 18;
    uint256 public totalSupply;

    // Track the balances
    mapping(address => uint256) public balanceOf;
    // Create a nested mapping for allowance
    mapping(address => mapping(address => uint256)) public allowance;
    //Syntax Explanation: mapping(<Owner Address> to another mapping, "=>"
        //, mapping(<"Exchange" or "Spender" address> => <# of Tokens Approved for spending>))

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );  // NOTE: "indexed" makes it easier to filter the events based on the "_from" and "_to" addresses.

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply * (10**decimals);
        balanceOf[msg.sender] = totalSupply;
    }

// function transfer allows you to take $ out of you're own wallet & send to someone else.
    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        // Requires that the Sender has enough tokens to spend.
        require(balanceOf[msg.sender] >= _value);
        // Requires that the toakens are being sent to a valid address / Not getting burned.
        require(_to != address(0));

        // Deduct tokens from the spender's Address.
        balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
        // Credit tokens to the receiver's Address.
        balanceOf[_to] = balanceOf[_to] + _value;

        // Emit the Transfer Event: Records the event in the EVM logs.
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

// approve function, aproves the address allowed to spend our tokens & the amount (_value)
        // They, "_spender", are allowed to spend on our behalf.
    function approve(address _spender, uint256 _value)
        public
        returns(bool success)
    {
        // Don't want the spender to be the 0 address.
        require(_spender != address(0));

        // Access the nested mapping we called "allowance".
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

}
