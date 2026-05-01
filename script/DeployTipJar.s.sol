// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.33;

import {Script} from "forge-std/Script.sol";
import {TipJar} from "../src/TipJar.sol";


contract DeployTipJar is Script{
    function run () external returns (TipJar){
        vm.startBroadcast(); // this line will make every transaction will be sent to network, not just simulation
        TipJar tipJar = new TipJar();
        vm.stopBroadcast();
        return tipJar;
    }
}