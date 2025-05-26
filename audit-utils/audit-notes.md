# Title: Weather NFT

## Protocol About

## Roles:

## Audit Scope

## Project Stats

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
only ETH and token-based game
10% protocol fee on all ETH games
No fees on token-only games
Final winner receives prize and winner token
Player can create a game for ETH or winner tokens
Join timeout: 24 hours by default
Reveal timeout: Set when creating game
Reveal timeout: min 5 minutes




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

1. first read
    take notes about unknows
2. answer unknows
3. second read
    take notes about unknows
.
.   (if some question depends of the code answer before the manual analisis)
.
4. get processes and actors
    deploy contracts (contract owner)
    game flow (user A, user B)
    updating time outs params (admin)
    withdraw accumulated fees (admin)
    set new admin (contract owner)
5. search restrictions
6. search invariants
7. automated analisis

    