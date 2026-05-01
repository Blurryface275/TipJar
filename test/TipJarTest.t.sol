// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test, console} from "forge-std/Test.sol";
import {TipJar} from "../src/TipJar.sol";

contract TipJarTest is Test {
    TipJar tipJar;
    address owner;
    address alice;
    address bob;

    function setUp() public{
        owner = makeAddr("owner"); // create fake address called "owner"
        alice = makeAddr("alice"); // create fake address called "alice"
        bob = makeAddr("bob"); // create fake address called "bob"

        vm.prank(owner); // from this point, we will simulate that "owner" adress is responsible for deploying this contract
        tipJar = new TipJar(); // generate new contract
    }
    function test_OwnerIsSetCorrectly() public{
        assertEq(tipJar.getOwner(), owner); // comparing if the owner of tipjar contract is equal to owner, if true this will pass
    }

    function test_TipIncreasesTotalTips() public{
        // checking if total tips is increased after an address give some tips
        // 1. Give Alice some ETH
        vm.deal(alice, 1 ether);

        // 2. Simulating Alice is the one who called tip()
        vm.prank(alice);
        tipJar.tip{value:1 ether}();

        // 3. Check if totalTips increased
        assertEq(tipJar.getTotalTips(), 1 ether);
        vm.stopPrank();
    }

    function test_TipRevertIfZero() public{
        // 1. Simulating Bob is called tip()
        vm.deal(bob, 1 ether);
        vm.prank(bob);
        vm.expectRevert(); // we will expect this test will get fail / reverted, so if the test failed just pass it
        tipJar.tip{value:0 ether}(); // here, we send 0 ETH to the tipJar
        vm.stopPrank();
    }

    function test_WithdrawSendsETHToOwner() public{
        // Make the owner withdraw all balances from the tipJar
        // 1. Give Alice some ETH and make her tipping the tipJar
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        tipJar.tip{value:1 ether}();

        // 2. Store the initial owner balance before withdraw
        uint256 initialOwnerBalance = owner.balance;

        // 3. Owner withdraw
        vm.prank(owner);
        tipJar.withdraw();

        // 4. Check if the owner's balance is increased by 1 ETH
        assertEq(owner.balance, initialOwnerBalance + 1 ether);
        vm.stopPrank();
    }

    function test_WithdrawRevertsIfNotOwner() public{
        // 1. Make Alice Tipping
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        tipJar.tip{value:1 ether}();
        vm.stopPrank();

        // 2. Make Alice withdraw
        vm.prank(alice);
        vm.expectRevert(); // here, we will expect this transaction will get reverted because by default the owner is not Alice, it's owner;
        tipJar.withdraw();
        vm.stopPrank(); 
    }

    function test_WithdrawRevertsIfNoTips() public{
        vm.prank(owner);
        vm.expectRevert();
        tipJar.withdraw();
        vm.stopPrank();    
    }

    function test_EpochIncreasesAfterWithdraw() public{
        vm.deal(owner, 1 ether);
        vm.prank(owner);
        tipJar.tip{value:1 ether}();
        vm.stopPrank();

        vm.prank(owner);
        tipJar.withdraw();
        assertEq(tipJar.getEpoch(), 1);
        vm.stopPrank();
    }

    function test_TransferOwnership() public{
        vm.startPrank(owner);
        tipJar.transferOwnership(alice);
        assertEq(tipJar.getOwner(), alice);
        vm.stopPrank();
    }
    
}