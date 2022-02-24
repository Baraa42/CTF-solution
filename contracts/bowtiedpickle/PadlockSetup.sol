// // SPDX-License-Identifier: UNLICENSED

// pragma solidity >=0.8.4;

// import "../../interfaces/ISetup.sol";
// import "./Padlock.sol";

// contract PadlockSetup is ISetup {
//     Padlock public instance;

//     constructor() payable {
//         string memory PIN = unicode"9027616";

//         instance = new Padlock(PIN);
//         emit Deployed(address(instance));
//     }

//     function isSolved() external view override returns (bool) {
//         bool unlocked = instance.opened();
//         return unlocked;
//     }
// }
