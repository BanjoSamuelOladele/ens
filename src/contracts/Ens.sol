// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "src/libraries/AllStructs.sol";

contract Ens {

    struct User{
        address userAddress;
        bytes32 _username;
        string uri;
    }

    event RegistrationComplete(address indexed, string);

    mapping(bytes32 => User) private usernames;
    mapping(address => User) private userAddresses;

    function register(string calldata _username, string calldata _uri) external{
        require(checkIfUsernameAlreadyExist(_username), "User with that name already exist");
        require(userAddresses[msg.sender].userAddress == address (0), "Already registered");
        bytes32 hashedUsername = hashStringToByte32(_username);
        User memory user = User(msg.sender, hashedUsername, _uri);
        usernames[hashedUsername] = user;
        userAddresses[msg.sender] = user;

        emit RegistrationComplete(msg.sender, _username);
    }

    function checkIfUsernameAlreadyExist(string calldata _username) public view returns(bool){
        bytes32 hashedResult = hashStringToByte32(_username);
        return usernames[hashedResult].userAddress == address(0);
    }

    function hashStringToByte32(string calldata _username) internal pure returns(bytes32){
        return keccak256(abi.encodePacked(convertToLowerCase(_username)));
    }

    function convertToLowerCase(string calldata _username) internal pure returns(string memory){
        bytes memory here = bytes(_username);
        bytes memory toLowerCase = new bytes(here.length);
        for (uint i = 0; i < here.length; i++) {
            if (uint8(here[i] )>= 65 && uint8(here[i])<= 90){
                toLowerCase[i] = bytes1(uint8(here[i]) + 32);
            }
            else toLowerCase[i] = here[i];
        }
        return string(toLowerCase);
    }

    function getAddress(string calldata _username) external view returns(address){
        return usernames[hashStringToByte32(_username)].userAddress;
    }

    function getUserWithUsername(string calldata _username) external view returns(User memory){
        return usernames[hashStringToByte32(_username)];
    }

    function getUserWithAddress(address _userAddress) external view returns(User memory){
        return userAddresses[_userAddress];
    }
}
