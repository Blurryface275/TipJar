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
    event TipReceived(address indexed tipper, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

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
            revert(TipJar__NoTips());
        }
        s_tips[msg.sender] += msg.value; // update total tips has been donated by user
        s_totalTips += msg.value; // update total tips in jar
        emit TipReceived(msg.sender, msg.value); // we will broadcast who has been donating tip and how much they donated
    }

    function withdraw() external onlyOwner{
        // use CEI : Checks, Effets, Interaction
        // Checks : Ensure sufficient balance before perform withdrawing actions (s_totalTips>0)
        if (s_totalTips <= 0){
            revert(TipJar__NoTips());
        }

        // Effects : Update TipJar's Balances
        uint256 amount = s_totalTips; // saving current total tips collected to a local variable
        s_totalTips = 0; // overwrtie current total tips is 0
        emit Withdrawn(i_owner, amount); // writing this action to events

        // Interaction : Sending ETH from all TipJar to owner of the TipJar
        (bool ok, ) = i_owner.call{value: amount}(""); // transfer ETH from TipJar to owner
        if (!ok){
            revert TipJar__WithdrawFailed();
        }
    }

   


}
