// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console, Vm} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import "src/RockPaperScissors.sol";
import "src/WinningToken.sol";

contract Handler is Test {
    // Contracts
    RockPaperScissors public game;
    WinningToken public token;

    mapping(address => uint256) playerToGameId;

    uint256 immutable i_bet;

    enum Move {
        None,
        Rock,
        Paper,
        Scissors
    }

    bytes32[4] fixture_commitHash;
    uint8[4] fixture_move;
    uint256[] gamesId;

    bool public relBroken;
    bool public passed;

    // Setup before each test
    constructor() {
        // Deploy contracts
        game = new RockPaperScissors();
        token = WinningToken(game.winningToken());

        fixture_commitHash[0] = keccak256(abi.encodePacked(Move.None, bytes32("some salt")));
        fixture_commitHash[1] = keccak256(abi.encodePacked(Move.Rock, bytes32("some salt")));
        fixture_commitHash[2] = keccak256(abi.encodePacked(Move.Paper, bytes32("some salt")));
        fixture_commitHash[3] = keccak256(abi.encodePacked(Move.Scissors, bytes32("some salt")));

        fixture_move[0] = uint8(Move.None);
        fixture_move[1] = uint8(Move.Rock);
        fixture_move[2] = uint8(Move.Paper);
        fixture_move[3] = uint8(Move.Scissors);

        i_bet = game.minBet();
    }

    function createGameWithEth(uint256 _totalTurns) external payable {
        uint256 totalTurns = _totalTurns;
        if ((totalTurns % 2) == 0) {
            totalTurns++;
        }
        vm.prank(msg.sender);
        game.createGameWithEth{value: i_bet}(totalTurns, 5 minutes);

        uint256 gameId = game.gameCounter();
        gamesId.push(gameId);
        playerToGameId[msg.sender] = gameId;
    }

    function joinGameWithEth() external payable {
        uint256 len = gamesId.length;
        if (len > 0) {
            uint256 gameId = gamesId[len - 1];
            gamesId.pop();
            vm.prank(msg.sender);
            game.joinGameWithEth{value: i_bet}(gameId);
            playerToGameId[msg.sender] = gameId;
        }
    }

    function commitMove(bytes32 _commitHash) external {
        if (playerToGameId[msg.sender] == 0) return;
        game.commitMove(playerToGameId[msg.sender], _commitHash);
    }

    function revealMove(uint8 _move) external {
        if (playerToGameId[msg.sender] == 0) return;
        vm.recordLogs();

        game.revealMove(playerToGameId[msg.sender], _move, "some salt");

        Vm.Log[] memory logs = vm.getRecordedLogs();

        for (uint256 i = 0; i < logs.length; i++) {
            Vm.Log memory log = logs[i];

            // Check if it's the event you're interested in (compare selector)
            if (log.topics[0] == keccak256("GameFinished(uint256,address,uint256)")) {
                // Get 'b' (2nd indexed param)
                uint256 gameId = uint256(log.topics[1]);

                (,,,,,,, uint256 totalTurns, uint256 currentTurn,,,,,,,) = game.games(gameId);

                relBroken = currentTurn < totalTurns;
            }
        }
    }

    function timeoutReveal() external {
        if (playerToGameId[msg.sender] == 0) return;
        game.timeoutReveal(playerToGameId[msg.sender]);
    }

    function cancelGame() external {
        if (playerToGameId[msg.sender] == 0) return;
        game.cancelGame(playerToGameId[msg.sender]);
    }

    function timeoutJoin() external {
        if (playerToGameId[msg.sender] == 0) return;
        game.timeoutJoin(playerToGameId[msg.sender]);
    }
}
