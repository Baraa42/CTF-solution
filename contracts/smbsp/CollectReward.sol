// // SPDX-License-Identifier:MIT
// pragma solidity >=0.8.4;

// /**
//  * @title CTF - CollectReward.
//  * @notice This is a rewards program.
//  * In this the user gets a reward based on a timestamp and block.
//  * You need to find a start time to collect the reward.
//  * */
// contract CollectReward {
//     uint256 public constant ONE_DAY = 86400;
//     uint256 public constant MULTIPLIER = 2;

//     uint256 public maxDuration;
//     uint256 public programStartTime;
//     uint256 public deploymentBlock;
//     mapping(uint256 => uint256) public blockDetails;

//     constructor() payable {
//         programStartTime = block.timestamp;
//         maxDuration = 3 * ONE_DAY;
//         deploymentBlock = block.number;
//         _setBlocks(programStartTime, programStartTime + (9 * ONE_DAY));
//     }

//     function collect(uint256 _startTime) external payable {
//         require(msg.value == 1 ether);

//         (uint256 withdrawTime, uint256 amount) = _getReward(_startTime);
//         require(withdrawTime > 0 && amount > 0, "no valid reward");
//         // Send all ether to user
//         (bool success, ) = msg.sender.call{value: address(this).balance}("");
//         require(success, "send fail");
//     }

//     // need (uint256 withdrawTime, uint256 amount) > 0 both
//     function _getReward(uint256 _startTime)
//         internal
//         view
//         returns (uint256 withdrawTime, uint256 amount)
//     {
//         uint256 reward;
//         uint256 currentTime = programStartTime + (8 * ONE_DAY) + 43200; // 8,5 days
//         uint256 lastInterval = _calculateTimestamp(currentTime); // 8 days + program start time

//         withdrawTime = programStartTime; //

//         if (lastInterval <= withdrawTime) return (0, 0); // useless unless lastinterval = withdratime
//         if (_startTime > 0) {
//             uint256 latestStartTime = _calculateTimestamp(_startTime); // {(_startTime - programStartTime) / ONE_DAY } * ONE_DAY + programStartTime
//             withdrawTime = latestStartTime; // _startTime = programStartTime + alpha * one day
//         }

//         // withdratime = alpha * one day + prog
//         uint256 newMaxDuration = withdrawTime + maxDuration; // (alpha + 3 )days + prog
//         uint256 duration = newMaxDuration < currentTime // curennt time = prog + 8,5 days , alpha < 6 or alpha > 6
//             ? _calculateTimestamp(newMaxDuration) // alpha + 3
//             : lastInterval;
//         // duration = (alpha + 3 days- programStartTime) / ONE_DAY or
//         for (uint256 i = withdrawTime; i < duration; i += ONE_DAY) {
//             // i from alpha + 3 days, i < duration
//             uint256 referenceBlock = blockDetails[i]; // need duration = last interval = need alpha >= 6 , NEED alpha = 6
//             reward = reward + _computeReward(referenceBlock, i);
//         }

//         withdrawTime = duration;
//         amount = reward * MULTIPLIER;
//     }

//     function _computeReward(uint256 _block, uint256 _date)
//         internal
//         view
//         returns (uint256 reward)
//     {
//         if (_block > deploymentBlock && _date == programStartTime + 518400) {
//             reward = _block + _date;
//         }
//     }

//     function _calculateTimestamp(uint256 timestamp)
//         internal
//         view
//         returns (uint256 validTimeStamp)
//     {
//         require(timestamp >= programStartTime, "invalid timestamp"); // 8,5 days +
//         uint256 period = (timestamp - programStartTime) / ONE_DAY; // 8,5 == 8
//         validTimeStamp = period * ONE_DAY + programStartTime;
//     }

//     // populate blockDetails mapping
//     function _setBlocks(uint256 _startTime, uint256 _endTime) internal {
//         uint8 k;
//         for (uint256 i = _startTime; i <= _endTime; i += ONE_DAY) {
//             uint256 checkpointBlock = deploymentBlock + (k * 5760);
//             blockDetails[i] = checkpointBlock;
//             k++;
//         }
//     }

//     function getProgramStartTime() external view returns (uint256) {
//         return programStartTime;
//     }
// }
