// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Escrow {
    address public payer;
    address public payee;
    address public lawyer;
    uint public amount;


    constructor( address _payer, address _payee, uint _amount){
        lawyer = msg.sender;
        payer = _payer;
        payee = _payee;
        amount = _amount;
    }

    function deposit() public payable {
        require(msg.sender == payer, "sender must be payer");
        require(address(this).balance <= amount, "Too much deposit");
    } 

    function release() public {
        require(msg.sender == lawyer, "Only the lawyer can release funds");
        require(address(this).balance == amount, "Cannot release before full amount");
        payable(payee).transfer(amount);
    }
}