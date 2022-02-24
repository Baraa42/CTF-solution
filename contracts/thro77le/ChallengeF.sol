// pragma solidity 0.8.0;

// interface IFactory {
//     function createContract(bytes memory bytecode, uint256 salt)
//         external
//         returns (bool);
// }

// contract ChallengeF {
//     bool public isSolved;
//     IFactory factory;

//     constructor(address _factory) {
//         factory = IFactory(_factory);
//     }

//     function createContract(bytes memory bytecode, uint256 salt) public {
//         isSolved = factory.createContract(bytecode, salt);
//     }
// }
