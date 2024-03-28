// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "lib/forge-std/src/Test.sol";
import "lib/forge-std/src/console.sol";
import {Ens} from "../src/contracts/Ens.sol";
import "lib/forge-std/src/StdAssertions.sol";

contract EnsTest is Test{

    Ens private ens;
    address private firstAddress = address(0xa);
    address private secondAddress = address(0xbb);

    function setUp() external{
        ens = new Ens();
    }

    function testRegister() external {
        createRegister();
        assertEq(ens.getAddress("Dleex"), firstAddress);
    }

    function testMultipleRegister() external {
        createRegister();
        assertEq(ens.getAddress("Reason"), secondAddress);
        assertEq(ens.getUserWithUsername("Reason").userAddress, secondAddress);
        assertEq(ens.getUserWithUsername("Reason").uri, "uri2");
        switchUser(firstAddress);
        bytes32 usernameIs = keccak256(abi.encodePacked("reason"));
        assertEq(ens.getUserWithAddress(secondAddress)._username, usernameIs);
    }

    function testThatAlreadyExistingNameCannotBeSaved() external  {
        createRegister();
        switchUser(address (1));
        vm.expectRevert(bytes ("User with that name already exist"));
        ens.register("Dleex", "uri");
    }

    function createRegister() internal {
        switchUser(firstAddress);
        ens.register("Dleex", "uri");

        switchUser(secondAddress);
        ens.register("Reason", "uri2");
    }

    function switchUser(address _user) internal {
        vm.prank(_user);
    }
}
