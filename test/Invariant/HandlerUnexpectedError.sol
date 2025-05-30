// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import "src/RockPaperScissors.sol";
import "src/WinningToken.sol";

contract Handler {
    // Contracts
    RockPaperScissors public game;
    WinningToken public token;

    bytes4 panicSel = bytes4(keccak256("Panic(uint256)"));
    bool public isPanic;

    // Setup before each test
    constructor() {
        // Deploy contracts
        game = new RockPaperScissors();
        token = WinningToken(game.winningToken());
    }

    function createGameWithEth(uint256 _totalTurns, uint256 _timeoutInterval) external payable returns (uint256) {
        try game.createGameWithEth(_totalTurns, _timeoutInterval) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function createGameWithToken(uint256 _totalTurns, uint256 _timeoutInterval) external returns (uint256) {
        try game.createGameWithToken(_totalTurns, _timeoutInterval) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function joinGameWithEth(uint256 _gameId) external payable {
        try game.joinGameWithEth(_gameId) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function joinGameWithToken(uint256 _gameId) external {
        try game.joinGameWithToken(_gameId) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function commitMove(uint256 _gameId, bytes32 _commitHash) external {
        try game.commitMove(_gameId, _commitHash) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function revealMove(uint256 _gameId, uint8 _move, bytes32 _salt) external {
        try game.revealMove(_gameId, _move, _salt) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function timeoutReveal(uint256 _gameId) external {
        try game.timeoutReveal(_gameId) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function cancelGame(uint256 _gameId) external {
        try game.cancelGame(_gameId) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function timeoutJoin(uint256 _gameId) external {
        try game.timeoutJoin(_gameId) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function setJoinTimeout(uint256 _newTimeout) external {
        try game.setJoinTimeout(_newTimeout) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function setAdmin(address _newAdmin) external {
        try game.setAdmin(_newAdmin) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }

    function withdrawFees(uint256 _amount) external {
        try game.withdrawFees(_amount) {}
        catch (bytes memory message) {
            if (bytes4(message) == panicSel) {
                isPanic = true;
                console.log("Is a panic message");
            }
        }
    }
}
