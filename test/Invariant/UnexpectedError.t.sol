// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Handler} from "./HandlerUnexpectedError.sol";
import "src/RockPaperScissors.sol";
import "src/WinningToken.sol";

contract SecATests is StdInvariant, Test {
    Handler handler;
    RockPaperScissors game;

    uint256 prevBalance;

    // Setup before each test
    function setUp() public {
        // Deploy contracts
        handler = new Handler();
        game = handler.game();

        targetContract(address(handler));
    }

    function invariant_testBalanceNeverGoesDown() public {
        assert(address(game).balance >= prevBalance);
        prevBalance = address(game).balance;
    }

    function invariant_testUnexpectedError() public view {
        assert(!handler.isPanic());
    }
}
