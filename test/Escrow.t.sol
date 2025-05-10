// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow escrow;
    address payer = address(1);
    address payee = address(2);
    address lawyer = address(this);

    function setUp() public {
        escrow = new Escrow(payer, payee, 1 ether);
    }

    function testDepositFromPayer() public {
        vm.deal(payer, 1 ether); // fund payer
        vm.prank(payer);
        escrow.deposit{value: 1 ether}();
        assertEq(address(escrow).balance, 1 ether);
    }

    function testCannotDepositFromOther() public {
        vm.deal(address(3), 1 ether); // fund address(3) to avoid revert on sending zero
        vm.prank(address(3));
        vm.expectRevert("sender must be payer");
        escrow.deposit{value: 1 ether}();
    }

    function testReleaseFunds() public {
        vm.deal(payer, 1 ether); // fund payer
        vm.prank(payer);
        escrow.deposit{value: 1 ether}();

        vm.prank(lawyer);
        escrow.release();
        assertEq(payee.balance, 1 ether);
    }

    function testFuzzDeposit(uint256 value) public {
        vm.assume(value <= 1 ether);
        vm.deal(payer, 1 ether); // fund payer with max amount
        vm.prank(payer);
        escrow.deposit{value: value}();
        assertLe(address(escrow).balance, 1 ether);
    }
}
