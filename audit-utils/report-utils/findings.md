### [S-#] TITLE (Root Cause + Impact)

**Description:**\

**Impact:**\

**Proof of Concept:**\

**Recommended Mitigation:**\

---------------------------------------------------------------

### [S-#] TITLE (Root Cause + Impact)

**Description:**\

**Impact:**\

**Proof of Concept:**\

```solidity
// !the games ends if a unrecheable majority is reached
function testGameNotFinishAfterMajority() public {
    bytes32 commitA;
    bytes32 commitB;

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
    // Player A Will be win #2 turn and the game 
}
```

**Recommended Mitigation:**\