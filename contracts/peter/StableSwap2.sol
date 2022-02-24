// // SPDX-License-Identifier: UNLICENSED
// pragma solidity >=0.8.4;
// import {ERC20PresetFixedSupply} from "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// import "../../interfaces/ISetup.sol";

// contract StableSwap2 is Ownable, ReentrancyGuard {
//     uint256 public supply;
//     IERC20[] public underlying;
//     mapping(address => bool) public hasUnderlying;
//     mapping(address => uint256) public balances;
//     mapping(address => mapping(address => uint256)) public approvals;

//     struct MintVars {
//         uint256 totalSupply;
//         uint256 totalBalanceNorm;
//         uint256 totalInNorm;
//         uint256 amountToMint;
//         IERC20 token;
//         uint256 has;
//         uint256 preBalance;
//         uint256 postBalance;
//         uint256 deposited;
//     }
//     struct BuyBack {
//         address sender;
//     }

//     function mint(uint256[] memory amounts)
//         public
//         nonReentrant
//         returns (uint256)
//     {
//         MintVars memory v; // x1 , x2 , x3
//         v.totalSupply = supply; // 0 now -- 30_000 NOW

//         for (uint256 i = 0; i < underlying.length; i++) {
//             v.token = underlying[i];

//             v.preBalance = v.token.balanceOf(address(this)); // b1

//             v.has = v.token.balanceOf(msg.sender); // X1

//             if (amounts[i] > v.has) amounts[i] = v.has; // X3 > x3

//             v.token.transferFrom(msg.sender, address(this), amounts[i]); // Transfering = X3 = 0

//             v.postBalance = v.token.balanceOf(address(this)); // b3

//             v.deposited = v.postBalance - v.preBalance; //

//             v.totalBalanceNorm += v.preBalance; //  b1 + b2 + b3
//             v.totalInNorm += v.deposited; // x1 + x2 + x3
//         }
//         if (v.totalSupply == 0) {
//             // 0
//             v.amountToMint = v.totalInNorm; // happens only once
//         } else {
//             v.amountToMint =
//                 (v.totalInNorm * v.totalSupply) / // ((x1 + x2 + x3) * supply ) / b1 + b2 + b3
//                 v.totalBalanceNorm;
//         }

//         supply += v.amountToMint; // supply += mintAmount  --> supply < true balance ?
//         balances[msg.sender] += v.amountToMint; // mintAmount < x1 + x2 + x3
//         return v.amountToMint;
//     }

//     // checks
//     // adding x1 + x2 + x3 to total balance of contract
//     // balance increase by (x1 + x2 + x3) * (totalSupply)  /(b1 + b2 + b3)

//     struct BurnVars {
//         uint256 supply;
//         uint256 haveBalance;
//         uint256 sendBalance;
//     }

//     // here i make supply < total balance
//     function burn(uint256 amount) public nonReentrant {
//         require(balances[msg.sender] >= amount, "burn/low-balance"); // burning  where the fun should happen
//         BurnVars memory v;
//         v.supply = supply;
//         for (uint256 i = 0; i < underlying.length; i++) {
//             v.haveBalance = underlying[i].balanceOf(address(this));
//             v.sendBalance = (v.haveBalance * amount) / v.supply;

//             underlying[i].transfer(msg.sender, v.sendBalance); // v send v1 = (b1 * myBalance) / (supply)
//         }

//         supply -= amount;
//         balances[msg.sender] -= amount;
//         // total sent balance < amount
//         // v1 + v2 + v3 < amount
//         // - amount < - (v1 + v2 + v3)
//         // supply < total balance
//     }

//     function donate(uint256 amount) public nonReentrant {
//         require(balances[msg.sender] >= amount, "donate/low-balance");
//         require(amount > 0, "donate/zero-amount");
//         BuyBack memory buyBack;
//         buyBack.sender = address(msg.sender);
//         supply -= amount;
//         balances[buyBack.sender] -= amount;
//     }

//     struct SwapVars {
//         uint256 preBalance;
//         uint256 postBalance;
//         uint256 input;
//         uint256 output;
//         uint256 sent;
//     }

//     // cant create token
//     // swap only gives u back tokens so can swap to make balance 9_000

//     function swap(
//         address src,
//         uint256 srcAmt,
//         address dst
//     ) public nonReentrant {
//         require(hasUnderlying[src], "swap/invalid-src");
//         require(hasUnderlying[dst], "swap/invalid-dst");

//         SwapVars memory v;

//         v.preBalance = IERC20(src).balanceOf(address(this)); // balance of source token
//         IERC20(src).transferFrom(msg.sender, address(this), srcAmt); // send x1 to contract
//         v.postBalance = IERC20(src).balanceOf(address(this)); // post - pre
//         // transfer amt src to stableswap

//         v.input = ((v.postBalance - v.preBalance) * 997) / 1000; // input = 97% of amount
//         v.output = v.input;

//         v.preBalance = IERC20(dst).balanceOf(address(this));
//         IERC20(dst).transfer(msg.sender, v.output); // get 97% of amount
//         v.postBalance = IERC20(dst).balanceOf(address(this)); //

//         v.sent = (v.preBalance - v.postBalance);
//         require(v.sent <= v.output, "swap/bad-token"); // swapping im always getting less
//         // swapping makes total balance way higher than total supply
//     }

//     // 10k 10k 10k
//     // mint burn swap
//     // i want output > input
//     // contract has q1 q2 q3, i want q3 < 100
//     // at start i have 1000 usdc
//     // i can mint or swap
//     // if i mint i get 1000 balance no lose no win
//     // if i swap

//     function transfer(address to, uint256 amount) public returns (bool) {
//         require(balances[msg.sender] >= amount, "transfer/low-balance");
//         unchecked {
//             balances[msg.sender] -= amount;
//             balances[to] += amount;
//         }
//         return true;
//     }

//     function transferFrom(
//         address from,
//         address to,
//         uint256 amount
//     ) public returns (bool) {
//         require(
//             approvals[from][msg.sender] >= amount,
//             "transferFrom/low-approval"
//         );
//         require(balances[from] >= amount, "transferFrom/low-balance");
//         approvals[from][msg.sender] -= amount;
//         balances[from] -= amount;
//         balances[to] += amount;
//         return true;
//     }

//     // approve myself myself a lot
//     function approve(address who, uint256 amount) public returns (bool) {
//         approvals[msg.sender][who] = amount;
//         return true;
//     }

//     function totalValue() public view returns (uint256) {
//         uint256 value = 0;
//         for (uint256 i = 0; i < underlying.length; i++) {
//             value += underlying[i].balanceOf(address(this));
//         }
//         return value;
//     }

//     function addCollateral(address collateral) public onlyOwner {
//         underlying.push(IERC20(collateral));
//         hasUnderlying[collateral] = true;
//     }
// }

// contract Setup is ISetup {
//     StableSwap2 public instance;
//     ERC20PresetFixedSupply public USDC;
//     ERC20PresetFixedSupply public USDT;
//     ERC20PresetFixedSupply public BUSD;

//     constructor() payable {
//         // require(msg.value == 0.0000374 ether);
//         USDC = new ERC20PresetFixedSupply(
//             "USDC Stablecoin",
//             "USDC",
//             11000,
//             address(this)
//         );
//         USDT = new ERC20PresetFixedSupply(
//             "USDT Stablecoin",
//             "USDT",
//             10000,
//             address(this)
//         );
//         BUSD = new ERC20PresetFixedSupply(
//             "BUSD Stablecoin",
//             "BUSD",
//             10000,
//             address(this)
//         );
//         // Setup has
//         // 11_0000 USDC
//         // 10_0000 USDT
//         // 10_0000 BUSD
//         instance = new StableSwap2();
//         // register IERC20 of these tokens in contract
//         instance.addCollateral(address(USDC));
//         instance.addCollateral(address(USDT));
//         instance.addCollateral(address(BUSD));
//         // Approve instance to spend
//         // 10_0000 USDC
//         // 10_0000 USDT
//         // 10_0000 BUSD
//         USDC.approve(address(instance), 100_000);
//         USDT.approve(address(instance), 100_000);
//         BUSD.approve(address(instance), 100_000);
//         // declare an array
//         uint256[] memory amounts = new uint256[](3);
//         // all amounst are 10_000
//         amounts[0] = USDC.balanceOf(address(this)) - 1000;
//         amounts[1] = USDT.balanceOf(address(this));
//         amounts[2] = BUSD.balanceOf(address(this));
//         // mint 10_000 for setup
//         instance.mint(amounts);
//         emit Deployed(address(instance));
//     }

//     function isSolved() external view override returns (bool) {
//         uint256 totalValue = USDC.balanceOf(address(instance));
//         totalValue = USDT.balanceOf(address(instance));
//         totalValue = BUSD.balanceOf(address(instance)); // we need to put BUSD balance of instance to under 100
//         return totalValue < 100;
//     }

//     function faucet(uint256 amount) public {
//         // I can have 1_000 USDC now
//         USDC.transfer(msg.sender, amount);
//     }
// }

// // MINT 1_000 USDC from faucet
// //
