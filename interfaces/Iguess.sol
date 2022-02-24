// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

interface IGuess {
    function initialize(address) external;

    function guess(uint256) external payable;
}
