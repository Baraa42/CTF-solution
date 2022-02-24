// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0;

interface IPadlock {
    function passHash() external view returns (bytes32);

    function tumbler1() external view returns (bool);

    function tumbler2() external view returns (bool);

    function tumbler3() external view returns (bool);

    function tries() external view returns (uint256);

    function pick1(string memory) external;

    function pick2() external payable;

    function pick3(bytes16) external;

    function open() external;
}
