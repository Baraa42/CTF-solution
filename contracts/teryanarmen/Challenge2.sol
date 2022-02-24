// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// fix
import "@openzeppelin/contracts/utils/Address.sol";

interface ICalled {
    function sup() external returns (uint256);
}

contract Challenge2 {
    using Address for address;

    State public state;
    address public winner;

    modifier onlyWinner() {
        require(msg.sender == winner, "oops");
        _;
    }
    modifier onlyState(State _state) {
        require(state == _state, "no...");
        _;
    }
    modifier onlyContract() {
        require(Address.isContract(msg.sender), "try again");
        _;
    }
    modifier onlyNotContract() {
        require(!Address.isContract(msg.sender), "yeah, no");
        _;
    }

    enum State {
        THREE, // on est la
        TWO,
        ONE,
        ZERO
    }

    constructor() payable {
        require(msg.value == 1 ether, "cheap");
    }

    // call it again with some manip
    function first() public onlyWinner onlyNotContract onlyState(State.ONE) {
        state = State.ZERO;
    }

    // call it with a contract that has sup() return == 1337
    // contract already deployed
    // it has to be the address of a contract so msg sender need to be contract
    function second() public onlyWinner onlyContract onlyState(State.TWO) {
        require(ICalled(msg.sender).sup() == 1337, "not leet");
        state = State.ONE;
    }

    // call it with a contract constructor or address
    // we are going with contract constructor
    // now not deployed yet contract is the winner
    // now try different approach, calling from my address
    // now im the winner, need to go to second

    function third() public onlyNotContract onlyState(State.THREE) {
        winner = msg.sender;
        state = State.TWO;
    }

    // the sup has to be an updatable function
    function fourth() public onlyWinner onlyContract onlyState(State.ZERO) {
        require(ICalled(msg.sender).sup() == 80085, "not boobs");
        payable(msg.sender).transfer(address(this).balance);
    }
}

// wrap contract A inside a contract B
// contract A ( contract B)
// Contract B constructor set winner to be itself
// Contract B deployed now isContract
// Contract B has sup = 1337 and can call second
// self destruct
// recreate B again
// call fourth
// do some assembly
// bytes memory bytecode = type(UniswapV2Pair).creationCode;
// bytes32 salt = keccak256(abi.encodePacked(token0, token1));
// assembly {
//     pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
// }

// THIRD
// set winner by non contract : EOA or contract in construction

// SECOND
// only winner can call, only contract

// first

// fourth

// contract A doesnt
// contract B exist
// A . delegate B function f
// f executes code B   with address A
// code B call winner and set A = winner
// then call
