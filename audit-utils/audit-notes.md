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
14. Fuzzing  <---------------I'M HERE
15. Answering
16. Analisis-Answer loop
17. Reporting


property impact
The balance of the protocol



    