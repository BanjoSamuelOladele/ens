// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Ens} from "../src/contracts/Ens.sol";

contract EnsScript is Script {

    function setUp() public {}

    function run() public {

        uint privateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(privateKey);

        console.log("address owner", user);
        vm.startBroadcast(privateKey);
            Ens ens = new Ens();
            ens.register("Dele", "Uri");
        vm.stopBroadcast();
    }
}