// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

//import "../contracts/Ens.sol";
import "src/libraries/AllStructs.sol";
import "src/contracts/Ens.sol";

interface IEns {

//    struct User{
//        address userAddress;
//        bytes32 _username;
//        string uri;
//    }

    function register(string calldata _username, string calldata _uri) external;
    function checkIfUsernameAlreadyExist(string calldata _username) external view returns(bool);
    function getAddress(string calldata _username) external view returns(address);
    function getUserWithUsername(string calldata _username) external view returns(Ens.User memory);
    function getUserWithAddress(address _userAddress) external view returns(Ens.User memory);
}
