// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import {TestnetTestToken} from "../src/TestnetTestToken.sol";

contract TestnetTestTokenTest is Test {
    TestnetTestToken internal token;
    address internal deployer = makeAddr("deployer");
    address internal alice = makeAddr("alice");

    function setUp() public {
        vm.prank(deployer);
        token = new TestnetTestToken();
    }

    function test_Metadata() public view {
        assertEq(token.name(), "TestnetTestToken");
        assertEq(token.symbol(), "TTT");
        assertEq(token.decimals(), 18);
    }

    function test_MintsInitialSupplyToDeployer() public view {
        assertEq(token.totalSupply(), token.INITIAL_SUPPLY());
        assertEq(token.balanceOf(deployer), token.INITIAL_SUPPLY());
    }

    function test_Transfer() public {
        vm.prank(deployer);
        assertTrue(token.transfer(alice, 100 ether));

        assertEq(token.balanceOf(alice), 100 ether);
        assertEq(token.balanceOf(deployer), token.INITIAL_SUPPLY() - 100 ether);
    }

    function test_RevertWhen_TransferExceedsBalance() public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, alice, 0, 1));
        // forge-lint: disable-next-line(erc20-unchecked-transfer)
        token.transfer(deployer, 1);
    }
}
