// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "../../interfaces/ISetup.sol";
import "./ChallengeL.sol";

contract Setup is ISetup {
    ChallengeL public instance;

    constructor() payable {
        instance = new ChallengeL();

        emit Deployed(address(instance));
    }

    function isSolved() external view override returns (bool) {
        address govToken = instance.govTokens(0);
        return GovToken(govToken).balanceOf(address(instance)) == 0;
    }
}
