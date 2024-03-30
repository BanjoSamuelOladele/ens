// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "src/interface/IEns.sol";
import "src/libraries/AllStructs.sol";
import "src/contracts/Ens.sol";
import "lib/forge-std/src/console.sol";

contract ChatApp {

    IEns private iEns;

    struct Message{
        uint256 timestamp;
        string message;
        bytes32 name;
    }

    struct Profile{
        bytes32 name;
        string uri;
        address userAddress;
        bool isRegistered;
    }

    Profile[] private allUsers;

    event SentMessage(address indexed, address indexed, uint);
    event RegisterComplete(address indexed);

    mapping(address => mapping(address => Message[])) private messages;
    mapping(address => Profile) private userProfile;

    constructor(address ensAddress) {
        iEns = IEns(ensAddress);
    }


    function sendMessage(string calldata _receiver, string calldata _message) external{
        address receiver = iEns.getAddress(_receiver);
        bytes32 senderName = iEns.getUserWithAddress(msg.sender)._username;
        require(receiver != msg.sender);
        require(checkIsRegistered(receiver), "Recipient not registered here");
        require(checkIsRegistered(msg.sender), "sender not registered here");

        Message memory message;
        message.name = senderName;
        message.message = _message;
        message.timestamp = block.timestamp;

        messages[msg.sender][receiver].push(message);
        messages[receiver][msg.sender].push(message);

        emit SentMessage(msg.sender, receiver, block.timestamp);
    }

    function checkIsRegistered(address _address) internal view returns(bool){
        return userProfile[_address].isRegistered;
    }

    function getMessages(string calldata _receiver) external view returns(Message[] memory){
        address rec = iEns.getAddress(_receiver);
        return messages[msg.sender][rec];
    }

    function getUserProfile() external view returns(Profile memory){
        return userProfile[msg.sender];
    }

    function getAllUsers() external view returns(Profile[] memory){
        return allUsers;
    }
}
