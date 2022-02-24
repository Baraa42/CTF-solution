// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

interface IChallenge {
    function faucet() external;

    function govTokens(uint256) external view returns (address);
}
