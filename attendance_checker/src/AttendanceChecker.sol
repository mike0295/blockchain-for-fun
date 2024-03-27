// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

contract AttendanceChecker {
    address public teacher;
    // 1 = Monday
    uint256 public classDay = 1;
    // Default: Monday 11 AM UTC (8 PM KST)
    uint256 public classStartTime = 39600;
    // Default: Monday 1 PM UTC (10 PM KST)
    uint256 public classEndTime = 46800;
    mapping(uint256 => mapping(address => bool)) public weeklyAttendance;

    bool public isOpenToAllTime = false;

    event AttendanceMarked(address indexed student, uint256 date);
    event ClassScheduleUpdated(uint256 day, uint256 startTime, uint256 endTime);

    constructor() {
        teacher = msg.sender;
    }

    modifier onlyTeacher() {
        require(
            msg.sender == teacher,
            "Only the teacher can perform this action."
        );
        _;
    }

    modifier onlyDuringClassHours() {
        if (isOpenToAllTime) {
            _;
            return;
        }

        require(
            (block.timestamp + (3 days)) % 1 weeks >= classStartTime &&
                (block.timestamp + (3 days)) % 1 weeks <= classEndTime,
            "It is not class time."
        );
        _;
    }

    modifier onlyOnClassDay() {
        if (isOpenToAllTime) {
            _;
            return;
        }

        require(
            (block.timestamp / 1 days + 4) % 7 == classDay,
            "It is not the day of the class."
        );
        _;
    }

    function updateClassSchedule(
        uint256 _classDay,
        uint256 _classStartTime,
        uint256 _classEndTime
    ) public onlyTeacher {
        require(_classDay >= 1 && _classDay <= 7, "Invalid day.");
        classDay = _classDay;
        classStartTime = _classStartTime;
        classEndTime = _classEndTime;
        emit ClassScheduleUpdated(_classDay, _classStartTime, _classEndTime);
    }

    function checkIn() public onlyOnClassDay onlyDuringClassHours {
        uint256 currentWeek = block.timestamp / 1 weeks;
        require(
            !weeklyAttendance[currentWeek][msg.sender],
            "Already checked in this week."
        );
        weeklyAttendance[currentWeek][msg.sender] = true;
        emit AttendanceMarked(msg.sender, block.timestamp);
    }

    function hasAttended(address student) public view returns (bool) {
        uint256 currentWeek = block.timestamp / 1 weeks;
        return weeklyAttendance[currentWeek][student];
    }

    function openToAllTime() public onlyTeacher {
        isOpenToAllTime = true;
    }

    function closeToAllTime() public onlyTeacher {
        isOpenToAllTime = false;
    }
}
