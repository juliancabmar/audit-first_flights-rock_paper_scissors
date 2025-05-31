// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Handler} from "./HandlerTotalTurnsRel.sol";
import "src/RockPaperScissors.sol";
import "src/WinningToken.sol";

contract SecATests is StdInvariant, Test {
    Handler handler;
    RockPaperScissors game;

    uint256 numOfPlayers;
    address player;

    // Setup before each test
    function setUp() public {
        // Deploy contracts
        handler = new Handler();
        game = handler.game();
        numOfPlayers = 20;

        for (uint256 i = 0; i < numOfPlayers; i++) {
            player = address(uint160(i + 1));
            vm.deal(player, 10 ether);
            targetSender(player);
        }

        targetContract(address(handler));
    }

    function invariant_testTurnsRel() public view {
        assertEq(handler.relBroken(), false);
    }
}
