// pragma solidity 0.8.7;

// contract gameVault {
//     address public keeper;
//     uint256 public balance;

//     constructor() {
//         keeper = msg.sender;
//     }

//     modifier forKeeper() {
//         require(keeper == msg.sender, "You shall not pass.");
//         _;
//     }

//     function deposit() public payable forKeeper {
//         balance += msg.value;
//     }

//     function withdraw(uint256 _amount) public forKeeper {
//         require(_amount <= balance, "Can you offer me an installment plan?");
//         balance -= _amount;
//         (bool success, ) = keeper.call{value: _amount}("");
//         require(success);
//     }

//     function withdrawFor(address _receiver, uint256 _amount) public forKeeper {
//         require(_amount <= balance, "Can you offer me an installment plan?");
//         balance -= _amount;
//         (bool success, ) = _receiver.call{value: _amount}("");
//         require(success);
//     }

//     function checkBalance() external view returns (uint256) {
//         return balance;
//     }
// }

// contract Monopoly {
//     bytes8 public FACTOR = 0x000000012ACE4C7F; // 5013130367 // max uint32 4294967296
//     uint256 public landPrice = 0.3 gwei;
//     uint32 private last = type(uint32).max - 3; // 2**32 - 4
//     uint256 public balance;
//     mapping(address => uint32) public lastMove;
//     gameVault public vault;

//     event Roll(uint16);
//     event Move(uint32);

//     constructor() payable {
//         require(msg.value == 1 ether);
//         vault = new gameVault();
//         vault.deposit{value: msg.value}();
//     }

//     // vault has 1 ether to start with
//     // all money received is put into the vault

//     receive() external payable {
//         vault.deposit{value: msg.value}();
//     }

//     function roll(uint32 _seed) internal returns (uint16) {
//         uint16 dice;
//         // 1, 7, 49, 102308783, 716161481, 5013130367 divisor of factor 
//         // uint 16 of divisors
//         // 1, 7, 49, 7087, 49609, 19583 
//         if (uint64(FACTOR) % _seed == 0) {
//             // 5013130367
//             unchecked {
//                 dice =
//                     uint16(_seed) ^
//                     uint16(bytes2(bytes20(address(msg.sender))));
//             }
//         } else {
//             unchecked {
//                 dice =
//                     uint16(_seed) ^
//                     uint16(bytes2(bytes20(address(tx.origin))));
//             }
//         }
//         assert(dice != 0);
//         emit Roll(dice);
//         return dice;
//     }

//     function endTurn(uint256 _amount) internal {
//         vault.withdrawFor(msg.sender, _amount);
//     }

//     // i can only call play
//     // seed1 , seed2
//     // value = 0.25 ether
//     // goes to vault
//     // last move = 0 for now
//     //
//     function play(uint32 _seed1, uint32 _seed2) public payable {
//         require(msg.value >= 0.25 ether, "0.25 ETH per turn");
//         require(_seed1 != _seed2, "Nah nah");
//         vault.deposit{value: msg.value}();
//         balance = vault.checkBalance();
//         uint32 _index = lastMove[msg.sender]; // first 0 then dice
//         uint32 _dice = roll(_seed1); // first roll result
//         _dice = _dice * roll(_seed2); // second roll result // dice = seed1 xor seed2 
//         lastMove[msg.sender] = move(_dice, _index); // move, index = dice
//         endTurn(balance); // i get 1 ether, vault still has 0.25
//     }

//     function move(uint32 _dice, uint32 _index) private returns (uint32) {
//         if (_index == 0) {
//             _index = _dice; // 0 
//         } else {
//             _index *= _dice;
//         }
//         if (_index == 0) {
//             endTurn(msg.value);
//         } else if (last % _index == 0) {
//             //Oh, it's the penalty slot.
//             endTurn(msg.value / 2);
//         } else if (
//             _index == last / 4 + 1 ||
//             _index == (last / 4) * 2 + 2 ||
//             _index == (last / 4) * 3 + 3
//         ) {
//             //It's a trap!
//         } else {
//             if (_index <= last / 4) {
//                 unchecked {
//                     landPrice = landPrice * _dice;
//                     balance -= landPrice;
//                 }
//             } else if (_index > last / 4 && _index < (last / 4) * 2) {
//                 unchecked {
//                     landPrice = landPrice * _dice * 2;
//                     balance -= landPrice;
//                 }
//             } else if (_index > (last / 4) * 2 && _index < (last / 4) * 3) {
//                 unchecked {
//                     landPrice = landPrice * _dice * 3;
//                     balance -= landPrice;
//                 }
//             } else if (_index > (last / 4) * 3 && _index <= last) {
//                 unchecked {
//                     landPrice = landPrice * _dice * 4;
//                     balance -= landPrice;
//                 }
//             }
//             emit Move(_dice);
//             return _index;
//         }
//         return 0;
//     }
// }
