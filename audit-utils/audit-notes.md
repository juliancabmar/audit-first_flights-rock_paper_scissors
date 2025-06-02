# Title: Weather NFT

## Protocol About

## Roles:

## Audit Scope

## Project Stats
Checked | Code | Files
    -   | 14   | [](../src/WinningToken.sol)
    -   | 335  | [](../src/RockPaperScissors.sol)

## Compatibilities
- Solc versions: ^0.8.13
- Chains for production: EVM compatible
- Tokens: ERC20 (Winning token)


--------------------------------------------------------------------

# LISTS:

## Restrictions:
### Scope
```
src/
├── RockPaperScissors.sol - Main game contract
└── WinningToken.sol - ERC20 token awarded to winners
```
### Known Issues
None

## Unknows:
+ Commit-reveal mechanism
+ Multiple-turn matches with best-of-N scoring (b = 2t - 1)

## Invariants

### Not Testeables Invariants:

### Confirmed Invariants

### Not Confirmed Invariants
+10% protocol fee on all ETH games
Final winner receives prize and winner token
Player can create a game for ETH or winner tokens
Join timeout: 24 hours by default
Reveal timeout: Set when creating game
Reveal timeout: min 5 minutes
b = 2t - 1




----------------------------------------------------------------------

# Audit Process

### 1. (+) Onboarding
### 2. (+) Research unknows
### 3. (+) Search restrictions
### 4. (+) Automated analisis
### 5. (+) Increase Kwnoledge
### 6. (+) Search the invariants
### 6. (-) Manual analisis
### 7. (-) Fuzzing
### 8. (-) Answering
### 9. (-) Analisis-Answer loop
### 10. (-) Reporting

----------------------------------------------------------------------

# Auxiliary Notes

1. first doc read
    take notes about unknows
2. answer unknows
3. second doc read
    take notes about unknows
.
.   (if some question depends of the code answer before the manual analisis)
.


4. search restrictions
5. search invariants
6. automated analisis
7. get stats
8. manual analisis A-B
9. Get macro processes with actors
deploy contracts (contract owner)
    game flow (users)
    updating time outs params (admin)
    withdraw accumulated fees (admin)
    set new admin (contract owner)
10. Explodes macro
deploy contracts:
    deploy RockPaperScissors [A: contract owner / T: RockPaperScissors::constructor]
    deploy WinningToken [A: contract owner / T: WinnigToken::constructor]

game flow:
    participate
        play
            reward winner

participate:
    An user create a game betting ETH [A: user(X) / T: createGameWithEth]
    An user create a game betting WinnerTokens [A: user(X) / T: createGameWithToken]
        Another user join the game with ETH [A: user(!X) / T: joinGameWithEth]
        Another user join the game with Token [A: user(!X) / T: joinGameWithToken]

play:
    LOOP (until some get the majority of N) {
        commit moves
            reveal moves
                }END LOOP

commit moves:
    first commit move [A: user in game / T: commitMove]
        second commit move [A: the other user in game / T: commitMove]

reveal moves:
    first reveal move [A: user in game / T: revealMove]
        second reveal move [A: the other user in game / T: revealMove]
                    
reward winner:
    send to the winner prize and/or winner tokens [A: user in game / T: revealMove]

11. Get the protocol map (micro processes with actors and triggers)
[deploy contracts]
deploy RockPaperScissors [A: contract owner / T: RockPaperScissors::constructor]
deploy WinningToken [A: contract owner / T: WinnigToken::constructor]

    set new admin [A: contract owner / T: RockPaperScissors::setAdmin]
    
    withdraw accumulated fees [A: admin / T: RockPaperScissors::withdrawFees]
    
    updating time outs params [A: admin / T: RockPaperScissors::setJoinTimeout]
    
    set the join timeout period [A: admin / T: RockPaperScissors::setJoinTimeout]

    on receive ETH [A: all / T: RockPaperScissors::receive]

    [game flow]
    An user create a game betting ETH [A: user(X) / T: RockPaperScissors::createGameWithEth]
    An user create a game betting WinnerTokens [A: user(X) / T: RockPaperScissors::createGameWithToken]
        Another user join the game with ETH [A: user(!X) / T: RockPaperScissors::joinGameWithEth]
        Another user join the game with Token [A: user(!X) / T: RockPaperScissors::joinGameWithToken]
            LOOP (until some get the majority of N) {
                first commit move [A: user in game / T: RockPaperScissors::commitMove]
                    second commit move [A: the other user in game / T: RockPaperScissors::commitMove]
                        first reveal move [A: user in game / T: RockPaperScissors::revealMove]
                            second reveal move [A: the other user in game / T: RockPaperScissors::revealMove]
                                }END LOOP
                                    send to the winner prize and/or winner tokens [A: user in game / T: RockPaperScissors::revealMove]

                            claim win if opponent didn't reveal in time [A: user in game / T: RockPaperScissors::timeoutReveal]
            
                cancel game and refund if still in created state [A: user who create the game / T: RockPaperScissors::cancelGame]

        cancel game if timeout of joined reach [A: all / T: RockPaperScissors::timeoutJoin]

12. Add the other external/public functions to the map (not view and pure)
13. Manual analisis
14. Fuzzing  
15. Answering   <---------------I'M HERE
16. Analisis-Answer loop
17. Reporting


```solidity
function testBaseWithEth() public {
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
```

```solidity
function testBaseWithToken() public {
    address owner = address(this);
    bytes32 commitA;
    bytes32 commitB;

    uint256 bet = BET_AMOUNT;
    uint256 feePercent = game.PROTOCOL_FEE_PERCENT();

    uint256 playerAInitBalance = token.balanceOf(playerA);
    uint256 playerBInitBalance = token.balanceOf(playerB);
    uint256 protocolInitBalance = token.balanceOf(address(game));

    console.log("Player A before: ", playerAInitBalance);
    console.log("Player B before: ", playerBInitBalance);
    console.log("Protocol before: ", protocolInitBalance);

    // PlayerA create a new game
    vm.startPrank(playerA);
    token.approve(address(game), 1);
    gameId = game.createGameWithToken(3, 1 hours);
    vm.stopPrank();

    vm.warp(block.timestamp + (30 minutes));

    // PlayerB is join
    vm.startPrank(playerB);
    token.approve(address(game), 1);
    game.joinGameWithToken(gameId);
    vm.stopPrank();

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

    uint256 playerAExpectedBalance = playerAInitBalance + 1;
    uint256 playerBExpectedBalance = playerBInitBalance - 1;
    uint256 protocolExpectedBalance = protocolInitBalance + 2;

    assertEq(playerAExpectedBalance, token.balanceOf(playerA));
    assertEq(playerBExpectedBalance, token.balanceOf(playerB));
    assertEq(protocolExpectedBalance, token.balanceOf(address(game)));

    console.log("Player A after: ", token.balanceOf(playerA));
    console.log("Player B after: ", token.balanceOf(playerB));
    console.log("Protocol after: ", token.balanceOf(address(game)));
}
```
    