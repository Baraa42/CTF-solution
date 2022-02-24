// // SPDX-License-Identifier: MIT
// pragma solidity >=0.8.0;

// import "@openzeppelin/contracts/proxy/Proxy.sol";
// import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol";
// import "../../interfaces/ISetup.sol";

// contract Challenge {
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

// contract Slogan {
//     string public slogan;
//     address public currentSloganOwner;

//     function setSlogan(string memory _str) public payable returns (bool) {
//         require(msg.value == 0.001 ether);
//         slogan = _str;
//         currentSloganOwner = msg.sender;
//         return true;
//     }
// }

// contract InitialiazableUpgradeableProxy is Proxy, ERC1967Upgrade {
//     function initialize(address _logic, bytes memory _data) public payable {
//         require(_implementation() == address(0));
//         assert(
//             _IMPLEMENTATION_SLOT ==
//                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
//         );
//         _upgradeTo(_logic);
//         if (_data.length > 0) {
//             (bool success, ) = _logic.delegatecall(_data);
//             require(success);
//         }
//     }

//     function _implementation()
//         internal
//         view
//         virtual
//         override
//         returns (address impl)
//     {
//         return _getImplementation();
//     }
// }

// contract SloganProxy is InitialiazableUpgradeableProxy {}

// // create Slogan
// // create SloganProxy
// // initialize Slogan Proxy : address of slogan
// // create Challenge : Send 1 ether with Proxy address
// // job = Drain challenge

// contract Setup is ISetup {
//     Challenge public instance;

//     constructor() payable {
//         require(msg.value == 1 ether);
//         Slogan slogan = new Slogan();
//         SloganProxy sloganProxy = new SloganProxy();
//         sloganProxy.initialize(address(slogan), "");
//         // slogan is proxy of sloganproxy
//         // slogan proxy is proxy of challenge
//         instance = new Challenge{value: 1 ether}(address(sloganProxy));
//         emit Deployed(address(instance));
//     }

//     function isSolved() external view override returns (bool) {
//         return address(instance).balance == 0;
//     }
// }

// // call challenge
// // challenge delegate to slogan proxy
// // slogan proxy delegate to slogan
// // set slogan gets exectued
// //
