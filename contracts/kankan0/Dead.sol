// // // SPDX-License-Identifier: MIT

// pragma solidity >=0.7.4;

// contract Dead {
//     uint256 public fee = 1000 ether;
//     bool public timeToKill;
//     bool public killed; // need to make it true
//     address public killer; // deployer
//     mapping(address => uint256) public balances;
//     mapping(address => bool) public registered;

//     constructor() payable {
//         require(msg.value == 0.1 ether);
//         killer = msg.sender;
//         balances[msg.sender] = 50 * msg.value;
//     }

//     modifier yetToKill() {
//         require(address(this).balance >= 0);
//         _;
//     }

//     function register() public payable yetToKill {
//         require(msg.value == 0.01 ether);
//         balances[msg.sender] = msg.value;
//         registered[msg.sender] = true;
//     }

//     function canKill() public {
//         require(registered[msg.sender]); // need to register
//         require(killer != msg.sender); // need to be different than deployer ok
//         if (address(this).balance - (balances[killer] * 8) / 5 >= 0) {
//             timeToKill = true;
//         }
//     }

//     function withdrawRegistration() public yetToKill {
//         require(registered[msg.sender], "Yet to register");
//         uint256 amountToSend = balances[msg.sender];
//         balances[msg.sender] = 0;
//         msg.sender.call{value: amountToSend}("");
//     }

//     function becomeKiller() public payable {
//         uint256 fee = balances[killer] / 10; // 0.5
//         require(msg.value < 0.1 ether, "Whooa, that's a lot of money"); // need to be less than 0.1 ok
//         balances[msg.sender] += msg.value;
//         if (balances[msg.sender] >= fee) {
//             killer = msg.sender;
//         }
//     }

//     function changeKiller(address _newKiller) public {
//         require(msg.sender == killer, "You have to be the killer to nominate");
//         killer = _newKiller;
//     }

//     function kill() public {
//         require(msg.sender == killer, "You need to be a kliler"); // i need to be a killer
//         require(timeToKill, "Patiently waiting for the right time"); // tiketokill need to be true
//         // selfdestruct(killer);
//         (bool sent, ) = killer.call{value: address(this).balance}("");
//         killed = true;
//     }
// }
