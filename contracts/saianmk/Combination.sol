// //SPDX-License-Identifier: MIT
// pragma solidity >=0.8.0;

// /**
//  *  A simple implementation of combination lock that contains a number dial and key,
//  *  Send the correct combination using dial and enter the key to unlock
//  *  Use dial function to turn the dial clockwise or anticlockwise
//  *  Use any combination of rotation and direction
//  */
// contract Combination {
//     bool public unlocked; // need to turn it to locked // combination = new Combination(32,2,8,2,180);

//     uint8 public leverPos; // 32

//     uint8 private cam3Val; // 64 - > 32
//     uint8 private cam2Val; // 64 - > 32
//     uint8 private cam1Val; // 64 - > 32

//     uint8 public cam3Tab; // 2 // 1
//     uint8 public cam2Tab; // 8 // 4
//     uint8 public cam1Tab; // 2 // 1

//     uint8 public pins; // 180

//     mapping(uint8 => uint8) log2;

//     /**
//      * @param _leverPos Target position of the slots
//      * @param _val1 Initial position of tab1
//      * @param _val2 Initial position of tab2
//      * @param _val3 Initial position of tab3
//      * @param _pins Pin value of the key lock
//      */
//     constructor(
//         uint8 _leverPos,
//         uint8 _val1,
//         uint8 _val2,
//         uint8 _val3,
//         uint8 _pins
//     ) {
//         leverPos = _leverPos;
//         cam1Tab = _val1;
//         cam2Tab = _val2;
//         cam3Tab = _val3;

//         pins = _pins;

//         setCamValues(); // check this function

//         log2[128] = 7;
//         log2[64] = 6;
//         log2[32] = 5;
//         log2[16] = 4;
//         log2[8] = 3;
//         log2[4] = 2;
//         log2[2] = 1;
//         log2[1] = 0; // log2(x) = log2(x)
//     }

//     /**
//      * @dev Set notch values from tab position
//      */
//     function setCamValues() internal {
//         cam1Val = rotateLeft(cam1Tab, 5); // cam1 = 1
//         cam2Val = rotateLeft(cam2Tab, 3); // cam2 = 4
//         cam3Val = rotateLeft(cam3Tab, 5); // cam3 = 1
//     }

//     /**
//      * @dev Function to perform left rotation
//      */
//     function rotateLeft(uint8 _val, uint8 _count)
//         internal
//         pure
//         returns (uint8)
//     {
//         return (_val >> (8 - _count)) | (_val << _count); // _val / 2 ** (8 - _count) | _val * 2**_count
//     }

//     /**
//      * @dev Function to perform right rotation
//      */
//     function rotateRight(uint8 _val, uint8 _count)
//         internal
//         pure
//         returns (uint8)
//     {
//         return (_val << (8 - _count)) | (_val >> _count);
//     }

//     function cam3(uint8 _rotateVal, bool _direction) internal {
//         if (_direction) {
//             // rotate val = 4
//             cam3Tab = rotateRight(cam3Tab, _rotateVal);
//         } else {
//             cam3Tab = rotateLeft(cam3Tab, _rotateVal);
//         }
//     }

//     function cam2(uint8 _rotateVal, bool _direction) internal {
//         uint8 gap = 0;
//         uint8 _cam2Tab = cam2Tab;
//         uint8 _cam3Tab = cam3Tab;
//         // 5 , false
//         if (_direction) {
//             gap = _cam2Tab > _cam3Tab
//                 ? log2[_cam2Tab] - log2[_cam3Tab] - 1
//                 : 8 - log2[_cam3Tab] + log2[_cam2Tab] - 1;

//             cam2Tab = rotateRight(_cam2Tab, _rotateVal);
//         } else {
//             gap = _cam2Tab > _cam3Tab
//                 ? (8 - log2[_cam2Tab] + log2[_cam3Tab]) - 1
//                 : (log2[_cam3Tab] - log2[_cam2Tab]) - 1; // gap = 5

//             cam2Tab = rotateLeft(_cam2Tab, _rotateVal);
//         }

//         if (gap < _rotateVal) {
//             cam3(_rotateVal - gap, _direction);
//         }
//     }

//     function cam1(uint8 _rotateVal, bool _direction) internal {
//         uint8 gap = 0;
//         uint8 _cam1Tab = cam1Tab; //2
//         uint8 _cam2Tab = cam2Tab; //8

//         if (_direction) {
//             gap = _cam1Tab > _cam2Tab
//                 ? log2[_cam1Tab] - log2[_cam2Tab] - 1
//                 : 8 - log2[_cam2Tab] + log2[_cam1Tab] - 1; // 5

//             cam1Tab = rotateRight(_cam1Tab, _rotateVal); // rotatevale = 1, cam1 = 1
//         } else {
//             gap = _cam1Tab > _cam2Tab
//                 ? 8 - log2[_cam1Tab] + log2[_cam2Tab] - 1
//                 : log2[_cam2Tab] - log2[_cam1Tab] - 1; // gap = 1

//             cam1Tab = rotateLeft(_cam1Tab, _rotateVal); // rorate val = 7 , direction = false
//         }

//         if (gap < _rotateVal) {
//             cam2(_rotateVal - gap, _direction); // 5, false
//         }
//     }

//     /**
//      * @dev Main function
//      * @param _rotateVal - Number of rotation to perform
//      * @param _direction - Direction of rotation ( right => true, left => false)
//      */
//     function dial(uint8 _rotateVal, bool _direction) public {
//         require(
//             _rotateVal > 0 && _rotateVal < 8,
//             "Rotate values out of bounds"
//         );

//         cam1(_rotateVal, _direction);

//         setCamValues();
//     }

//     /**
//      * @dev Function to unlock and lock, enter key to unlock
//      * @param _key Key value
//      */
//     function unlock(uint8 _key) public {
//         unlocked =
//             ((cam1Val & cam2Val & cam3Val) == leverPos) &&
//             (pins ^ _key == type(uint8).max);

//         // uint8 public cam3Val; // 64 = 01000000
//         // uint8 public cam2Val; // 64
//         // uint8 public cam1Val; // 64
//         // lever = 32
//         // pins = 180
//         // pins xor key = 255 easy
//         // 3 and = 32 = 00100000
//         // Simple reset
//         dial(7, false);
//         dial(7, true);
//         dial(3, false);
//     }
// }
