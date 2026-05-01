// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

contract TipJar {
    // Errors
    error TipJar__NotOwner();
    error TipJar__WithdrawFailed();
    error TipJar__NoTips();
    error TipJar__ZeroAddress();
    
    // State variables 
    address private i_owner; // address for owner of the tip jar - the only eligible address to withdraw all of the money
    mapping (address => uint256) s_tips;
    uint256 private s_totalTips; // total tips from all of the tip has been donated by another user

    // Events
    events TipReceived(address indexed tipper, uint256 amount);
    events Withdrawn(address indexed owner, uint256 amount);

    constructor (address msg.owner){
        i_owner = msg.owner;
    }

    // Modifiers
    // This part is used to do checking that need to be run before or after a function
    modifier onlyOwner(){
        if(msg,sender != i_owner){
            revert(TipJar__NotOwner());
        }
    }

    // Functions
    // Function - tip() : 
    // Description :
    // I use external because we will need to call this function from another contract to perform testing and this cost cheaper gas 
    // I use payable because we will make this function able to receives ETH, payable function has already built in msg.value properties
    function tip() external payable{
        if (msg.value == 0){
            revert(TipJar_NoTips());
        }
        s_tips[msg.sender] += msg.value; // update total tips has been donated by user
        s_totalTips += msg.value; // update total tips in jar
        emit TipReceived(msg.sender, msg.value); // we will broadcast who has been donating tip and how much they donated
    }



   


}
