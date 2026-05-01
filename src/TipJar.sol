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
pragma solidity ^0.8.33;

contract TipJar {
    // Errors
    error TipJar__NotOwner();
    error TipJar__WithdrawFailed();
    error TipJar__NoTips();
    error TipJar__ZeroAddress();
    
    // State variables 
    address private s_owner; // address for owner of the tip jar - the only eligible address to withdraw all of the money
    uint256 private s_totalTips; // total tips from all of the tip has been donated by another user
    uint256 private s_epoch; 
    address[] private s_tippers;

    mapping (uint256 => mapping(address => uint256)) s_tips; // epoch, address, amount

    // Events
    event TipReceived(address indexed tipper, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
        
    // Constructor
    constructor (){
        s_owner = msg.sender;
    }

    // Modifiers
    // This part is used to do checking that need to be run before or after a function
    modifier onlyOwner(){
        if(msg.sender != s_owner){
            revert TipJar__NotOwner();
        }
        _;
    }

    // Functions
    // Function - tip() : 
    // Description :
    // I use external because we will need to call this function from another contract to perform testing and this cost cheaper gas 
    // I use payable because we will make this function able to receives ETH, payable function has already built in msg.value properties
    function tip() external payable{
        if (msg.value == 0){
            revert TipJar__NoTips();
        }
        if (s_tips[s_epoch][msg.sender]==0){
            s_tippers.push(msg.sender);
        }
        
        s_tips[s_epoch][msg.sender] += msg.value; // update total tips has been donated by user
        s_totalTips += msg.value; // update total tips in jar
        emit TipReceived(msg.sender, msg.value); // we will broadcast who has been donating tip and how much they donated
    }

    function withdraw() external onlyOwner{
        // use CEI : Checks, Effets, Interaction
        // Checks : Ensure sufficient balance before perform withdrawing actions (s_totalTips>0)
        if (s_totalTips <= 0){
            revert TipJar__NoTips();
        }

        // Effects : Update TipJar's Balances
        uint256 amount = s_totalTips; // saving current total tips collected to a local variable
        s_totalTips = 0; // overwrtie current total tips is 0
        s_epoch+=1;
        delete s_tippers;
        emit Withdrawn(s_owner, amount); // writing this action to events

        // Interaction : Sending ETH from all TipJar to owner of the TipJar
        (bool ok, ) = s_owner.call{value: amount}(""); // transfer ETH from TipJar to owner
        if (!ok){
            revert TipJar__WithdrawFailed();
        }
    }

    function transferOwnership(address newOwner) external onlyOwner{
        if (newOwner == address(0)){
            revert TipJar__ZeroAddress();
        }
        emit OwnershipTransferred(s_owner, newOwner); // writing this ownershiptransferring action to events
        s_owner = newOwner;
    }
    
    // Getter Function
    function getOwner() external view returns (address){
        return s_owner;
    }

    function getTip(address tipper) external view returns (uint256){
        return s_tips[s_epoch][tipper];
    }

    function getTotalTips() external view returns (uint256){
        return s_totalTips;
    }

    function getEpoch() external view returns (uint256){
    return s_epoch;
}

}
