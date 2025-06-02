### [S-#] TITLE (Root Cause + Impact)

**Description:**\

**Impact:**\

**Proof of Concept:**\

**Recommended Mitigation:**\

---------------------------------------------------------------

### [H-#] The games NOT ends with a unrecheable majority

**Description:**\
The game continues even when a majority of turns becomes unreachable, forcing players to interact unnecessarily.

**Impact:**\
* Increased gas costs for players.
* Confusion and poor user experience.

**Proof of Concept:**\
Add the following to the test suite
<details><summary>PoC</summary>

```solidity
function testGameNotFinishAfterMajority() public {
    bytes32 commitA;
    bytes32 commitB;

    // PlayerA create a new game with 3 turns
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
    commitB = keccak256(abi.encodePacked(RockPaperScissors.Move.Rock, bytes32("some salt")));
    vm.prank(playerB);
    game.commitMove(gameId, commitB);

    // Player A reveal his #2 move
    vm.prank(playerA);
    game.revealMove(gameId, uint8(RockPaperScissors.Move.Paper), "some salt");

    // Player B reveal his #2 move
    vm.expectEmit(false, false, false, false);
    emit GameFinished(0, address(0), 0);
    vm.prank(playerB);
    game.revealMove(gameId, uint8(RockPaperScissors.Move.Rock), "some salt");
    // Player A Will be win #2 turn and the game but the event is not trigger 
}
```
</details>
**Recommended Mitigation:**\
Check if some player wins is > `totalTurns / 2`

### [S-#] DoS attack on `RockPaperScissors::gameCounter` broke the protocol for futher players

**Description:**\
The gameCounter variable in the RockPaperScissors contract is incremented for every new game created, regardless of whether the game is completed or canceled. This opens the possibility for a Denial-of-Service (DoS) attack where malicious actors repeatedly create and cancel games, rapidly incrementing the gameCounter until it reaches its maximum value (uint256.max). Once this limit is reached, no new games can be created, effectively breaking the protocol for all future players.

**Impact:**
* Protocol Disruption: No new games can be created once gameCounter overflows, rendering the contract unusable for all players.
* Economic Loss: Players are unable to participate in games, leading to loss of functionality and potential financial impact for users relying on the protocol.
* Exploitation Risk: Malicious actors can exploit this vulnerability to disrupt the protocol intentionally, causing reputational damage and loss of trust in the system.

**Proof of Concept:**\
Add the following to the test suite
<details><summary>PoC</summary>

```solidity
function testDoSInCounter() public {
    address attackerA = makeAddr("attackerA");
    address attackerB = makeAddr("attackerB");

    vm.deal(attackerA, BET_AMOUNT);
    vm.deal(attackerB, BET_AMOUNT);

    vm.pauseGasMetering();

    for (uint256 i = 0; i < type(uint256).max; i++) {
        // attackerA create a new game
        vm.prank(attackerA);
        gameId = game.createGameWithEth{value: BET_AMOUNT}(1, 1 hours);

        // attackerB is join
        vm.prank(attackerB);
        game.joinGameWithEth{value: BET_AMOUNT}(gameId);

        // AttackerA cancel the game increasing gameCounter
        vm.prank(attackerA);
        game.cancelGame(gameId);
    }

    vm.resumeGasMetering();

    // Anyone who try to make a new game cause a revert for overflow
    vm.expectRevert();
    vm.prank(playerA);
    gameId = game.createGameWithEth{value: BET_AMOUNT}(1, 1 hours);
}
```
</details>

**Recommended Mitigation:**
* Create a "max number of games" check for avoid the overflow.
* Decrease `gameCounter` every time that a game is ended.
