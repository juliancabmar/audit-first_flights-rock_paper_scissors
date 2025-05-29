// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/RockPaperScissors.sol";
import "../src/WinningToken.sol";

contract AuditTests is Test {
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

    function testBase() public {
        address owner = address(this);
        bytes32 commitA;
        bytes32 commitB;

        uint256 bet = BET_AMOUNT;
        uint256 feePercent = game.PROTOCOL_FEE_PERCENT();

        uint256 playerAInitBalance = playerA.balance;
        uint256 playerBInitBalance = playerB.balance;
        uint256 protocolInitBalance = address(game).balance;

        console.log("Player A before: ", playerAInitBalance);
        console.log("Player B before: ", playerBInitBalance);
        console.log("Protocol before: ", protocolInitBalance);

        // PlayerA create a new game
        vm.prank(playerA);
        gameId = game.createGameWithEth{value: BET_AMOUNT}(3, 1 hours);

        vm.warp(block.timestamp + (30 minutes));

        // PlayerB is join
        vm.prank(playerB);
        game.joinGameWithEth{value: BET_AMOUNT}(gameId);

        // Player A commits his #1 move
        commitA = keccak256(abi.encodePacked(RockPaperScissors.Move.Rock, bytes32("some salt")));
        vm.prank(playerA);
        game.commitMove(gameId, commitA);

        // Player B commits his #1 move
        commitB = keccak256(abi.encodePacked(RockPaperScissors.Move.Scissors, bytes32("some salt")));
        vm.prank(playerB);
        game.commitMove(gameId, commitB);

        // Player A reveal his #1 move
        vm.prank(playerA);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Rock), "some salt");

        // Player B reveal his #1 move
        vm.prank(playerB);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Scissors), "some salt");

        // Player A Wins #1 turn

        // Player A commits his #2 move
        commitA = keccak256(abi.encodePacked(RockPaperScissors.Move.Paper, bytes32("some salt")));
        vm.prank(playerA);
        game.commitMove(gameId, commitA);

        // Player B commits his #2 move
        commitB = keccak256(abi.encodePacked(RockPaperScissors.Move.Scissors, bytes32("some salt")));
        vm.prank(playerB);
        game.commitMove(gameId, commitB);

        // Player A reveal his #2 move
        vm.prank(playerA);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Paper), "some salt");

        // Player B reveal his #2 move
        vm.prank(playerB);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Scissors), "some salt");

        // Player B Wins #2 turn

        // Player A commits his #3 move
        commitA = keccak256(abi.encodePacked(RockPaperScissors.Move.Rock, bytes32("some salt")));
        vm.prank(playerA);
        game.commitMove(gameId, commitA);

        // Player B commits his #3 move
        commitB = keccak256(abi.encodePacked(RockPaperScissors.Move.Scissors, bytes32("some salt")));
        vm.prank(playerB);
        game.commitMove(gameId, commitB);

        // Player A reveal his #3 move
        vm.prank(playerA);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Rock), "some salt");

        // Player B reveal his #3 move
        vm.prank(playerB);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Scissors), "some salt");

        // Player A Wins #3 turn and the game

        // Total Prize and fee calculation
        uint256 totalPrize = 2 * bet;
        uint256 fee = (totalPrize * feePercent) / 100;

        uint256 playerAExpectedBalance = playerAInitBalance - bet + (totalPrize - fee);
        uint256 playerBExpectedBalance = playerBInitBalance - bet;
        uint256 protocolExpectedBalance = protocolInitBalance + fee;

        assertEq(playerAExpectedBalance, playerA.balance);
        assertEq(playerBExpectedBalance, playerB.balance);
        assertEq(protocolExpectedBalance, address(game).balance);

        console.log("Player A after: ", playerA.balance);
        console.log("Player B after: ", playerB.balance);
        console.log("Protocol after: ", address(game).balance);
        console.log("Fee. ", fee);
    }

    function testFuzzBet(uint256 _bet) public {
        // address owner = address(this);
        bytes32 commitA;
        bytes32 commitB;

        uint256 bet = bound(_bet, 0.01 ether, playerA.balance);
        uint256 feePercent = game.PROTOCOL_FEE_PERCENT();

        uint256 playerAInitBalance = playerA.balance;
        uint256 playerBInitBalance = playerB.balance;
        uint256 protocolInitBalance = address(game).balance;

        console.log("Player A before: ", playerAInitBalance);
        console.log("Player B before: ", playerBInitBalance);
        console.log("Protocol before: ", protocolInitBalance);

        // PlayerA create a new game
        vm.prank(playerA);
        gameId = game.createGameWithEth{value: bet}(3, 1 hours);

        vm.warp(block.timestamp + (30 minutes));

        // PlayerB is join
        vm.prank(playerB);
        game.joinGameWithEth{value: bet}(gameId);

        // Player A commits his #1 move
        commitA = keccak256(abi.encodePacked(RockPaperScissors.Move.Rock, bytes32("some salt")));
        vm.prank(playerA);
        game.commitMove(gameId, commitA);

        // Player B commits his #1 move
        commitB = keccak256(abi.encodePacked(RockPaperScissors.Move.Scissors, bytes32("some salt")));
        vm.prank(playerB);
        game.commitMove(gameId, commitB);

        // Player A reveal his #1 move
        vm.prank(playerA);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Rock), "some salt");

        // Player B reveal his #1 move
        vm.prank(playerB);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Scissors), "some salt");

        // Player A Wins #1 turn

        // Player A commits his #2 move
        commitA = keccak256(abi.encodePacked(RockPaperScissors.Move.Paper, bytes32("some salt")));
        vm.prank(playerA);
        game.commitMove(gameId, commitA);

        // Player B commits his #2 move
        commitB = keccak256(abi.encodePacked(RockPaperScissors.Move.Scissors, bytes32("some salt")));
        vm.prank(playerB);
        game.commitMove(gameId, commitB);

        // Player A reveal his #2 move
        vm.prank(playerA);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Paper), "some salt");

        // Player B reveal his #2 move
        vm.prank(playerB);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Scissors), "some salt");

        // Player B Wins #2 turn

        // Player A commits his #3 move
        commitA = keccak256(abi.encodePacked(RockPaperScissors.Move.Rock, bytes32("some salt")));
        vm.prank(playerA);
        game.commitMove(gameId, commitA);

        // Player B commits his #3 move
        commitB = keccak256(abi.encodePacked(RockPaperScissors.Move.Scissors, bytes32("some salt")));
        vm.prank(playerB);
        game.commitMove(gameId, commitB);

        // Player A reveal his #3 move
        vm.prank(playerA);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Rock), "some salt");

        // Player B reveal his #3 move
        vm.prank(playerB);
        game.revealMove(gameId, uint8(RockPaperScissors.Move.Scissors), "some salt");

        // Player A Wins #3 turn and the game

        // Total Prize and fee calculation
        uint256 totalPrize = 2 * bet;
        uint256 fee = (totalPrize * feePercent) / 100;

        uint256 playerAExpectedBalance = playerAInitBalance - bet + (totalPrize - fee);
        uint256 playerBExpectedBalance = playerBInitBalance - bet;
        uint256 protocolExpectedBalance = protocolInitBalance + fee;

        assertEq(playerAExpectedBalance, playerA.balance);
        assertEq(playerBExpectedBalance, playerB.balance);
        assertEq(protocolExpectedBalance, address(game).balance);

        console.log("Player A after: ", playerA.balance);
        console.log("Player B after: ", playerB.balance);
        console.log("Protocol after: ", address(game).balance);
        console.log("Fee. ", fee);
    }
}
