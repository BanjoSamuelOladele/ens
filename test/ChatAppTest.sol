// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "lib/forge-std/src/Test.sol";
import "../src/contracts/Ens.sol";
import "../src/contracts/ChatApp.sol";

contract ChatAppTest is Test{

    Ens private ens;
    ChatApp private chatApp;
    address private A = address (0xa);
    address private B = address (0xbb);

    function setUp() external {
        ens = new Ens();
        chatApp = new ChatApp(address(ens));
    }

    function testRegister() external{
        createEns();
        assertEq(chatApp.getAllUsers().length, 0);
        vm.prank(A);
        chatApp.register("Name");
        vm.prank(A);
        assertEq(chatApp.getUserProfile().userAddress, A);
        assertEq(chatApp.getAllUsers().length, 1);
    }

    function testUserCanRegisterAgainAfterFirstRegistration() external{
        createEns();
        vm.prank(A);
        chatApp.register("Name");
        vm.prank(A);
        vm.expectRevert(bytes ("Already registered"));
        chatApp.register("Name");
        assertEq(chatApp.getAllUsers().length, 1);
    }

    function testCreateMultipleUser() external{
        createEns();
        vm.prank(A);
        chatApp.register("Name");
        vm.prank(B);
        chatApp.register("Another Name");

        assertEq(chatApp.getAllUsers().length, 2);
    }

    function testThatOnlyUsernameCanCreateAccount() external {
        createEns();
        vm.prank(A);
        vm.expectRevert( bytes("Not signer"));
        chatApp.register("Another Name");
    }

    function testSendMessage() external{
        registerUser();

        vm.prank(A);
        chatApp.sendMessage("Another Name", "Hi, how are you?");

        vm.prank(A);
        assertEq(chatApp.getMessages("Another Name")[0].message, "Hi, how are you?");

        vm.prank(B);
        assertEq(chatApp.getMessages("Name")[0].message, "Hi, how are you?");
    }

    function testUnRegisteredUserCannotBeSentAMessage() external{
        registerUser();

        vm.prank(A);
        vm.expectRevert(bytes ("Recipient not registered here"));
        chatApp.sendMessage("Another", "Hi, how are you?");

    }

    function createEns() internal {
        vm.prank(A);
        ens.register("Name", "uri");
        vm.prank(B);
        ens.register("Another Name", "uri2");
    }

    function registerUser() internal{
        createEns();

        vm.prank(A);
        chatApp.register("Name");

        vm.prank(B);
        chatApp.register("Another Name");
    }
}
