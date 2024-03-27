// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {AttendanceChecker} from "../src/AttendanceChecker.sol";

contract AttendanceCheckerTest is Test {
    AttendanceChecker public attendanceChecker;
    address public teacher;
    address public student;

    function setUp() public {
        teacher = address(0x1);
        student = address(0x2);

        vm.startPrank(teacher);
        attendanceChecker = new AttendanceChecker();
        vm.stopPrank();
    }

    function test_CheckIn() public {
        // Assume class is scheduled correctly and we're within class hours
        // Set the blockchain timestamp to Monday at a time within class hours
        uint256 mondayWithinClassHours = 1711366664; // Monday, 25 April 2024 within class hours
        vm.warp(mondayWithinClassHours);

        // Simulate student checking in
        vm.startPrank(student);
        attendanceChecker.checkIn();
        assertTrue(attendanceChecker.hasAttended(student));
        vm.stopPrank();
    }

    function testCheckInFailWrongDay() public {
        // Set the blockchain timestamp to a day that is not Monday
        uint256 notMonday = 1711452210; // Tuesday, 26 April 2022 11:00:00 GMT
        vm.warp(notMonday);

        // Simulate student attempting to check in
        vm.startPrank(student);
        vm.expectRevert("It is not the day of the class.");
        attendanceChecker.checkIn();
        vm.stopPrank();
    }

    function testUpdateClassSchedule() public {
        // Only the teacher can update the class schedule
        uint256 newClassDay = 2; // Tuesday
        uint256 newClassStartTime = 45000; // New start time
        uint256 newClassEndTime = 52200; // New end time

        vm.startPrank(teacher);
        attendanceChecker.updateClassSchedule(
            newClassDay,
            newClassStartTime,
            newClassEndTime
        );
        assertEq(attendanceChecker.classDay(), newClassDay);
        assertEq(attendanceChecker.classStartTime(), newClassStartTime);
        assertEq(attendanceChecker.classEndTime(), newClassEndTime);
        vm.stopPrank();
    }

    function testOpenToAllTime() public {
        // Only the teacher can open the class to all time
        vm.startPrank(teacher);
        attendanceChecker.openToAllTime();
        assertTrue(attendanceChecker.isOpenToAllTime());
        vm.stopPrank();

        // Check if student can check in at any time
        uint256 anyTime = 1234567890; // Some random time
        vm.warp(anyTime);
        vm.startPrank(student);
        attendanceChecker.checkIn();
        assertTrue(attendanceChecker.hasAttended(student));
    }

    function testCloseToAllTime() public {
        // Only the teacher can close the class to all time
        vm.startPrank(teacher);
        attendanceChecker.closeToAllTime();
        assertFalse(attendanceChecker.isOpenToAllTime());
        vm.stopPrank();

        // Check if student can check in at any time
        uint256 anyTime = 1234567890; // Some random time
        vm.warp(anyTime);
        vm.startPrank(student);
        vm.expectRevert("It is not the day of the class.");
        attendanceChecker.checkIn();
        vm.stopPrank();

        // Check if student can check in during class hours
        uint256 mondayWithinClassHours = 1711366664; // Monday, 25 April 2024 within class hours
        vm.warp(mondayWithinClassHours);
        vm.startPrank(student);
        attendanceChecker.checkIn();
        assertTrue(attendanceChecker.hasAttended(student));
        vm.stopPrank();
    }

    function testCheckInFailNotClassTime() public {
        // Set the blockchain timestamp to a time outside of class hours
        uint256 notClassTime = 1711452210; // Tuesday, 26 April 2022 11:00:00 GMT
        vm.warp(notClassTime);

        // Simulate student attempting to check in
        vm.startPrank(student);
        vm.expectRevert("It is not the day of the class.");
        attendanceChecker.checkIn();
        vm.stopPrank();
    }
}
