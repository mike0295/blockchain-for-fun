// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Hello} from "../src/Hello.sol";

contract HelloTest is Test {
    Hello public helloContract;

    function setUp() public {
        helloContract = new Hello();
    }

    function test_helloWorld() public view {
        assertEq(helloContract.hello(), "Hello, World!");
    }

    function test_changeNameToCallerAddr() public {
        vm.prank(address(0x1));
        helloContract.changeNameToCallerAddr();
        assertEq(
            helloContract.name(),
            "0x0000000000000000000000000000000000000001"
        );
    }

    function test_changeNameToString() public {
        helloContract.changeNameToString("Wafflestudio");
        assertEq(helloContract.name(), "Wafflestudio");
        assertEq(helloContract.hello(), "Hello, Wafflestudio!");
    }
}
