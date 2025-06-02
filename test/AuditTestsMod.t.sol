// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console, stdStorage, StdStorage} from "forge-std/Test.sol";
import "../src/RockPaperScissors.sol";
import "../src/WinningToken.sol";

contract AuditTestsMod is Test {
    // Contracts
    RockPaperScissors public game;
    WinningToken public token;

    // Test accounts
    address public admin;
    address public playerA;
    address public playerB;

    // Test constants
    uint256 constant BET_AMOUNT = 0.1 ether;
    uint256 constant TIMEOUT = 10 minutes;
    uint256 constant TOTAL_TURNS = 3; // Must be odd

    // Game ID for tests
    uint256 public gameId;

    // Events
    event GameFinished(uint256 indexed gameId, address winner, uint256 prize);

    // Setup before each test
    function setUp() public {
        // Set up addresses
        admin = address(this);
        playerA = makeAddr("playerA");
        playerB = makeAddr("playerB");

        // Fund the players
        vm.deal(playerA, 10 ether);
        vm.deal(playerB, 10 ether);

        // Deploy contracts
        game = new RockPaperScissors();
        token = WinningToken(game.winningToken());

        // Mint some tokens for players for token tests
        vm.prank(address(game));
        token.mint(playerA, 10);

        vm.prank(address(game));
        token.mint(playerB, 10);
    }

    function testDoSInCounterMod() public {
        address attackerA = makeAddr("attackerA");
        address attackerB = makeAddr("attackerB");

        vm.deal(attackerA, BET_AMOUNT);
        vm.deal(attackerB, BET_AMOUNT);

        // INIT LOOP
        // attackerA create a new game
        vm.prank(attackerA);
        gameId = game.createGameWithEth{value: BET_AMOUNT}(1, 1 hours);

        // attackerB is join
        vm.prank(attackerB);
        game.joinGameWithEth{value: BET_AMOUNT}(gameId);

        // AttackerA cancel the game increasing gameCounter
        vm.prank(attackerA);
        game.cancelGame(gameId);
        // END LOOP

        // Simulate loop repetition until the gameCounter var reach the uint256 max value
        vm.store(address(game), bytes32(uint256(1)), bytes32(type(uint256).max));

        // Anyone who try to make a new game cause a revert for overflow
        vm.expectRevert();
        vm.prank(playerA);
        gameId = game.createGameWithEth{value: BET_AMOUNT}(1, 1 hours);
    }
}
