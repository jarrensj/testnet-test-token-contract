// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title TestnetTestToken
/// @notice A plain ERC20 for testnet use. The full fixed supply is minted to the deployer.
contract TestnetTestToken is ERC20 {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 10 ** 18;

    constructor() ERC20("TestnetTestToken", "TTT") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}
