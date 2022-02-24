// // SPDX-License-Identifier: MIT

// pragma solidity >=0.8.4;

// // uint public constant inflationRate = 10;
// //uint public constant initialSupply = 1000;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/utils/Context.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract InflationaryToken is Context, ERC20, Ownable {
//     uint256 private _rate;
//     bool private print;

//     constructor(
//         string memory name_,
//         string memory symbol_,
//         uint256 rate_,
//         uint256 initialSupply
//     ) ERC20(name_, symbol_) {
//         print = true;
//         _rate = rate_;
//         _print(initialSupply);
//     }

//     modifier switchPrinting() {
//         print = !print;
//         _;
//     }

//     modifier whenPrinting() {
//         if (print) {
//             _;
//         }
//     }

//     function _print(uint256 amount) internal {
//         _mint(owner(), amount);
//     }

//     function burn(uint256 amount) public virtual {
//         _burn(_msgSender(), amount);
//     }

//     function burnFrom(address account, uint256 amount) public virtual {
//         _spendAllowance(_msgSender(), account, amount);
//         _burn(account, amount);
//     }

//     function _beforeTokenTransfer(
//         address from,
//         address to,
//         uint256 amount
//     ) internal virtual override {
//         super._beforeTokenTransfer(from, to, amount);
//         if (totalSupply() > 0) {
//             _goBrr(); // add 10% to supply if totalsupply > 0
//         }
//     }

//     function _goBrr() internal whenPrinting switchPrinting {
//         _print((_rate * totalSupply()) / 100); // add 10%
//     }

//     function rate() public view returns (uint256) {
//         return _rate;
//     }
// }

// contract Inflation {
//     InflationaryToken public token;
//     string private constant name = "Inflationary Token";
//     string private constant symbol = "INF";

//     constructor(uint256 rate, uint256 initialSupply) {
//         token = new InflationaryToken(name, symbol, rate, initialSupply);
//     }

//     function isEmpty() public view returns (bool _isEmpty) {
//         _isEmpty = (token.balanceOf(address(this)) == 0);
//         return _isEmpty;
//     }

//     function tokenAddress() public view returns (address tokenAddr) {
//         tokenAddr = address(token);
//         return tokenAddr;
//     }
// }

// // i need to empty the contract from tokens
// // inflationRate = 10;
// // initialSupply = 1000;
