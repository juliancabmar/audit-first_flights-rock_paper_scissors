Summary
 - [unchecked-transfer](#unchecked-transfer) (2 results) (High)
 - [reentrancy-no-eth](#reentrancy-no-eth) (1 results) (Medium)
 - [reentrancy-benign](#reentrancy-benign) (1 results) (Low)
 - [reentrancy-events](#reentrancy-events) (6 results) (Low)
 - [timestamp](#timestamp) (8 results) (Low)
 - [pragma](#pragma) (1 results) (Informational)
 - [solc-version](#solc-version) (1 results) (Informational)
 - [low-level-calls](#low-level-calls) (4 results) (Informational)
 - [naming-convention](#naming-convention) (19 results) (Informational)
## unchecked-transfer
Impact: High
Confidence: Medium
 - [ ] ID-0
[RockPaperScissors.createGameWithToken(uint256,uint256)](src/RockPaperScissors.sol#L124-L148) ignores return value by [winningToken.transferFrom(msg.sender,address(this),1)](src/RockPaperScissors.sol#L131)

src/RockPaperScissors.sol#L124-L148


 - [ ] ID-1
[RockPaperScissors.joinGameWithToken(uint256)](src/RockPaperScissors.sol#L170-L184) ignores return value by [winningToken.transferFrom(msg.sender,address(this),1)](src/RockPaperScissors.sol#L180)

src/RockPaperScissors.sol#L170-L184


## reentrancy-no-eth
Impact: Medium
Confidence: Medium
 - [ ] ID-2
Reentrancy in [RockPaperScissors.joinGameWithToken(uint256)](src/RockPaperScissors.sol#L170-L184):
	External calls:
	- [winningToken.transferFrom(msg.sender,address(this),1)](src/RockPaperScissors.sol#L180)
	State variables written after the call(s):
	- [game.playerB = msg.sender](src/RockPaperScissors.sol#L182)
	[RockPaperScissors.games](src/RockPaperScissors.sol#L50) can be used in cross function reentrancies:
	- [RockPaperScissors._cancelGame(uint256)](src/RockPaperScissors.sol#L547-L574)
	- [RockPaperScissors._determineWinner(uint256)](src/RockPaperScissors.sol#L415-L465)
	- [RockPaperScissors._finishGame(uint256,address)](src/RockPaperScissors.sol#L472-L505)
	- [RockPaperScissors._handleTie(uint256)](src/RockPaperScissors.sol#L511-L541)
	- [RockPaperScissors.canTimeoutJoin(uint256)](src/RockPaperScissors.sol#L360-L364)
	- [RockPaperScissors.canTimeoutReveal(uint256)](src/RockPaperScissors.sol#L293-L312)
	- [RockPaperScissors.cancelGame(uint256)](src/RockPaperScissors.sol#L318-L325)
	- [RockPaperScissors.commitMove(uint256,bytes32)](src/RockPaperScissors.sol#L191-L221)
	- [RockPaperScissors.createGameWithEth(uint256,uint256)](src/RockPaperScissors.sol#L96-L117)
	- [RockPaperScissors.createGameWithToken(uint256,uint256)](src/RockPaperScissors.sol#L124-L148)
	- [RockPaperScissors.games](src/RockPaperScissors.sol#L50)
	- [RockPaperScissors.joinGameWithEth(uint256)](src/RockPaperScissors.sol#L154-L164)
	- [RockPaperScissors.joinGameWithToken(uint256)](src/RockPaperScissors.sol#L170-L184)
	- [RockPaperScissors.revealMove(uint256,uint8,bytes32)](src/RockPaperScissors.sol#L229-L256)
	- [RockPaperScissors.timeoutJoin(uint256)](src/RockPaperScissors.sol#L331-L339)
	- [RockPaperScissors.timeoutReveal(uint256)](src/RockPaperScissors.sol#L262-L285)

src/RockPaperScissors.sol#L170-L184


## reentrancy-benign
Impact: Low
Confidence: Medium
 - [ ] ID-3
Reentrancy in [RockPaperScissors.createGameWithToken(uint256,uint256)](src/RockPaperScissors.sol#L124-L148):
	External calls:
	- [winningToken.transferFrom(msg.sender,address(this),1)](src/RockPaperScissors.sol#L131)
	State variables written after the call(s):
	- [gameId = gameCounter ++](src/RockPaperScissors.sol#L133)
	- [game.playerA = msg.sender](src/RockPaperScissors.sol#L136)
	- [game.bet = 0](src/RockPaperScissors.sol#L137)
	- [game.timeoutInterval = _timeoutInterval](src/RockPaperScissors.sol#L138)
	- [game.creationTime = block.timestamp](src/RockPaperScissors.sol#L139)
	- [game.joinDeadline = block.timestamp + joinTimeout](src/RockPaperScissors.sol#L140)
	- [game.totalTurns = _totalTurns](src/RockPaperScissors.sol#L141)
	- [game.currentTurn = 1](src/RockPaperScissors.sol#L142)
	- [game.state = GameState.Created](src/RockPaperScissors.sol#L143)

src/RockPaperScissors.sol#L124-L148


## reentrancy-events
Impact: Low
Confidence: Medium
 - [ ] ID-4
Reentrancy in [RockPaperScissors._cancelGame(uint256)](src/RockPaperScissors.sol#L547-L574):
	External calls:
	- [(successA,None) = game.playerA.call{value: game.bet}()](src/RockPaperScissors.sol#L554)
	- [(successB,None) = game.playerB.call{value: game.bet}()](src/RockPaperScissors.sol#L558)
	- [winningToken.mint(game.playerA,1)](src/RockPaperScissors.sol#L566)
	- [winningToken.mint(game.playerB,1)](src/RockPaperScissors.sol#L569)
	External calls sending eth:
	- [(successA,None) = game.playerA.call{value: game.bet}()](src/RockPaperScissors.sol#L554)
	- [(successB,None) = game.playerB.call{value: game.bet}()](src/RockPaperScissors.sol#L558)
	Event emitted after the call(s):
	- [GameCancelled(_gameId)](src/RockPaperScissors.sol#L573)

src/RockPaperScissors.sol#L547-L574


 - [ ] ID-5
Reentrancy in [RockPaperScissors.createGameWithToken(uint256,uint256)](src/RockPaperScissors.sol#L124-L148):
	External calls:
	- [winningToken.transferFrom(msg.sender,address(this),1)](src/RockPaperScissors.sol#L131)
	Event emitted after the call(s):
	- [GameCreated(gameId,msg.sender,0,_totalTurns)](src/RockPaperScissors.sol#L145)

src/RockPaperScissors.sol#L124-L148


 - [ ] ID-6
Reentrancy in [RockPaperScissors._handleTie(uint256)](src/RockPaperScissors.sol#L511-L541):
	External calls:
	- [(successA,None) = game.playerA.call{value: refundPerPlayer}()](src/RockPaperScissors.sol#L528)
	- [(successB,None) = game.playerB.call{value: refundPerPlayer}()](src/RockPaperScissors.sol#L529)
	- [winningToken.mint(game.playerA,1)](src/RockPaperScissors.sol#L535)
	- [winningToken.mint(game.playerB,1)](src/RockPaperScissors.sol#L536)
	External calls sending eth:
	- [(successA,None) = game.playerA.call{value: refundPerPlayer}()](src/RockPaperScissors.sol#L528)
	- [(successB,None) = game.playerB.call{value: refundPerPlayer}()](src/RockPaperScissors.sol#L529)
	Event emitted after the call(s):
	- [GameFinished(_gameId,address(0),0)](src/RockPaperScissors.sol#L540)

src/RockPaperScissors.sol#L511-L541


 - [ ] ID-7
Reentrancy in [RockPaperScissors.withdrawFees(uint256)](src/RockPaperScissors.sol#L397-L409):
	External calls:
	- [(success,None) = adminAddress.call{value: amountToWithdraw}()](src/RockPaperScissors.sol#L405)
	Event emitted after the call(s):
	- [FeeWithdrawn(adminAddress,amountToWithdraw)](src/RockPaperScissors.sol#L408)

src/RockPaperScissors.sol#L397-L409


 - [ ] ID-8
Reentrancy in [RockPaperScissors.joinGameWithToken(uint256)](src/RockPaperScissors.sol#L170-L184):
	External calls:
	- [winningToken.transferFrom(msg.sender,address(this),1)](src/RockPaperScissors.sol#L180)
	Event emitted after the call(s):
	- [PlayerJoined(_gameId,msg.sender)](src/RockPaperScissors.sol#L183)

src/RockPaperScissors.sol#L170-L184


 - [ ] ID-9
Reentrancy in [RockPaperScissors._finishGame(uint256,address)](src/RockPaperScissors.sol#L472-L505):
	External calls:
	- [(success,None) = _winner.call{value: prize}()](src/RockPaperScissors.sol#L491)
	- [winningToken.mint(_winner,2)](src/RockPaperScissors.sol#L498)
	- [winningToken.mint(_winner,1)](src/RockPaperScissors.sol#L501)
	External calls sending eth:
	- [(success,None) = _winner.call{value: prize}()](src/RockPaperScissors.sol#L491)
	Event emitted after the call(s):
	- [GameFinished(_gameId,_winner,prize)](src/RockPaperScissors.sol#L504)

src/RockPaperScissors.sol#L472-L505


## timestamp
Impact: Low
Confidence: Medium
 - [ ] ID-10
[RockPaperScissors.timeoutJoin(uint256)](src/RockPaperScissors.sol#L331-L339) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(block.timestamp > game.joinDeadline,Join deadline not reached yet)](src/RockPaperScissors.sol#L335)

src/RockPaperScissors.sol#L331-L339


 - [ ] ID-11
[RockPaperScissors.joinGameWithToken(uint256)](src/RockPaperScissors.sol#L170-L184) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(block.timestamp <= game.joinDeadline,Join deadline passed)](src/RockPaperScissors.sol#L175)

src/RockPaperScissors.sol#L170-L184


 - [ ] ID-12
[RockPaperScissors.canTimeoutReveal(uint256)](src/RockPaperScissors.sol#L293-L312) uses timestamp for comparisons
	Dangerous comparisons:
	- [game.state != GameState.Committed || block.timestamp <= game.revealDeadline](src/RockPaperScissors.sol#L296)

src/RockPaperScissors.sol#L293-L312


 - [ ] ID-13
[RockPaperScissors.timeoutReveal(uint256)](src/RockPaperScissors.sol#L262-L285) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(block.timestamp > game.revealDeadline,Reveal phase not timed out yet)](src/RockPaperScissors.sol#L267)

src/RockPaperScissors.sol#L262-L285


 - [ ] ID-14
[RockPaperScissors.canTimeoutJoin(uint256)](src/RockPaperScissors.sol#L360-L364) uses timestamp for comparisons
	Dangerous comparisons:
	- [(game.state == GameState.Created && block.timestamp > game.joinDeadline && game.playerB == address(0))](src/RockPaperScissors.sol#L363)

src/RockPaperScissors.sol#L360-L364


 - [ ] ID-15
[RockPaperScissors.joinGameWithEth(uint256)](src/RockPaperScissors.sol#L154-L164) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(block.timestamp <= game.joinDeadline,Join deadline passed)](src/RockPaperScissors.sol#L159)

src/RockPaperScissors.sol#L154-L164


 - [ ] ID-16
[RockPaperScissors.revealMove(uint256,uint8,bytes32)](src/RockPaperScissors.sol#L229-L256) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(block.timestamp <= game.revealDeadline,Reveal phase timed out)](src/RockPaperScissors.sol#L234)

src/RockPaperScissors.sol#L229-L256


 - [ ] ID-17
[RockPaperScissors.commitMove(uint256,bytes32)](src/RockPaperScissors.sol#L191-L221) uses timestamp for comparisons
	Dangerous comparisons:
	- [require(bool,string)(msg.sender == game.playerA || msg.sender == game.playerB,Not a player in this game)](src/RockPaperScissors.sol#L194)
	- [require(bool,string)(game.state == GameState.Created || game.state == GameState.Committed,Game not in commit phase)](src/RockPaperScissors.sol#L195)
	- [require(bool,string)(game.playerB != address(0),Waiting for player B to join)](src/RockPaperScissors.sol#L199)
	- [require(bool,string)(game.state == GameState.Committed,Not in commit phase)](src/RockPaperScissors.sol#L203)
	- [require(bool,string)(game.moveA == Move.None && game.moveB == Move.None,Moves already committed for this turn)](src/RockPaperScissors.sol#L204)
	- [require(bool,string)(game.commitA == bytes32(0),Already committed)](src/RockPaperScissors.sol#L208)
	- [require(bool,string)(game.commitB == bytes32(0),Already committed)](src/RockPaperScissors.sol#L211)

src/RockPaperScissors.sol#L191-L221


## pragma
Impact: Informational
Confidence: High
 - [ ] ID-18
2 different versions of Solidity are used:
	- Version constraint ^0.8.20 is used by:
		-[^0.8.20](lib/openzeppelin-contracts/contracts/access/Ownable.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#L3)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Context.sol#L4)
	- Version constraint ^0.8.13 is used by:
		-[^0.8.13](src/RockPaperScissors.sol#L2)
		-[^0.8.13](src/WinningToken.sol#L2)

lib/openzeppelin-contracts/contracts/access/Ownable.sol#L4


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-19
Version constraint ^0.8.13 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- VerbatimInvalidDeduplication
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess
	- StorageWriteRemovalBeforeConditionalTermination
	- AbiReencodingHeadOverflowWithStaticArrayCleanup
	- DirtyBytesArrayToStorage
	- InlineAssemblyMemorySideEffects
	- DataLocationChangeInInternalOverride
	- NestedCalldataArrayAbiReencodingSizeValidation.
It is used by:
	- [^0.8.13](src/RockPaperScissors.sol#L2)
	- [^0.8.13](src/WinningToken.sol#L2)

src/RockPaperScissors.sol#L2


## low-level-calls
Impact: Informational
Confidence: High
 - [ ] ID-20
Low level call in [RockPaperScissors._finishGame(uint256,address)](src/RockPaperScissors.sol#L472-L505):
	- [(success,None) = _winner.call{value: prize}()](src/RockPaperScissors.sol#L491)

src/RockPaperScissors.sol#L472-L505


 - [ ] ID-21
Low level call in [RockPaperScissors._cancelGame(uint256)](src/RockPaperScissors.sol#L547-L574):
	- [(successA,None) = game.playerA.call{value: game.bet}()](src/RockPaperScissors.sol#L554)
	- [(successB,None) = game.playerB.call{value: game.bet}()](src/RockPaperScissors.sol#L558)

src/RockPaperScissors.sol#L547-L574


 - [ ] ID-22
Low level call in [RockPaperScissors._handleTie(uint256)](src/RockPaperScissors.sol#L511-L541):
	- [(successA,None) = game.playerA.call{value: refundPerPlayer}()](src/RockPaperScissors.sol#L528)
	- [(successB,None) = game.playerB.call{value: refundPerPlayer}()](src/RockPaperScissors.sol#L529)

src/RockPaperScissors.sol#L511-L541


 - [ ] ID-23
Low level call in [RockPaperScissors.withdrawFees(uint256)](src/RockPaperScissors.sol#L397-L409):
	- [(success,None) = adminAddress.call{value: amountToWithdraw}()](src/RockPaperScissors.sol#L405)

src/RockPaperScissors.sol#L397-L409


## naming-convention
Impact: Informational
Confidence: High
 - [ ] ID-24
Parameter [RockPaperScissors.joinGameWithToken(uint256)._gameId](src/RockPaperScissors.sol#L170) is not in mixedCase

src/RockPaperScissors.sol#L170


 - [ ] ID-25
Parameter [RockPaperScissors.timeoutReveal(uint256)._gameId](src/RockPaperScissors.sol#L262) is not in mixedCase

src/RockPaperScissors.sol#L262


 - [ ] ID-26
Parameter [RockPaperScissors.commitMove(uint256,bytes32)._gameId](src/RockPaperScissors.sol#L191) is not in mixedCase

src/RockPaperScissors.sol#L191


 - [ ] ID-27
Parameter [RockPaperScissors.createGameWithEth(uint256,uint256)._timeoutInterval](src/RockPaperScissors.sol#L96) is not in mixedCase

src/RockPaperScissors.sol#L96


 - [ ] ID-28
Parameter [RockPaperScissors.canTimeoutReveal(uint256)._gameId](src/RockPaperScissors.sol#L293) is not in mixedCase

src/RockPaperScissors.sol#L293


 - [ ] ID-29
Parameter [RockPaperScissors.createGameWithToken(uint256,uint256)._timeoutInterval](src/RockPaperScissors.sol#L124) is not in mixedCase

src/RockPaperScissors.sol#L124


 - [ ] ID-30
Parameter [RockPaperScissors.revealMove(uint256,uint8,bytes32)._move](src/RockPaperScissors.sol#L229) is not in mixedCase

src/RockPaperScissors.sol#L229


 - [ ] ID-31
Parameter [RockPaperScissors.setAdmin(address)._newAdmin](src/RockPaperScissors.sol#L386) is not in mixedCase

src/RockPaperScissors.sol#L386


 - [ ] ID-32
Parameter [RockPaperScissors.setJoinTimeout(uint256)._newTimeout](src/RockPaperScissors.sol#L345) is not in mixedCase

src/RockPaperScissors.sol#L345


 - [ ] ID-33
Parameter [RockPaperScissors.revealMove(uint256,uint8,bytes32)._gameId](src/RockPaperScissors.sol#L229) is not in mixedCase

src/RockPaperScissors.sol#L229


 - [ ] ID-34
Parameter [RockPaperScissors.withdrawFees(uint256)._amount](src/RockPaperScissors.sol#L397) is not in mixedCase

src/RockPaperScissors.sol#L397


 - [ ] ID-35
Parameter [RockPaperScissors.revealMove(uint256,uint8,bytes32)._salt](src/RockPaperScissors.sol#L229) is not in mixedCase

src/RockPaperScissors.sol#L229


 - [ ] ID-36
Parameter [RockPaperScissors.cancelGame(uint256)._gameId](src/RockPaperScissors.sol#L318) is not in mixedCase

src/RockPaperScissors.sol#L318


 - [ ] ID-37
Parameter [RockPaperScissors.createGameWithEth(uint256,uint256)._totalTurns](src/RockPaperScissors.sol#L96) is not in mixedCase

src/RockPaperScissors.sol#L96


 - [ ] ID-38
Parameter [RockPaperScissors.joinGameWithEth(uint256)._gameId](src/RockPaperScissors.sol#L154) is not in mixedCase

src/RockPaperScissors.sol#L154


 - [ ] ID-39
Parameter [RockPaperScissors.createGameWithToken(uint256,uint256)._totalTurns](src/RockPaperScissors.sol#L124) is not in mixedCase

src/RockPaperScissors.sol#L124


 - [ ] ID-40
Parameter [RockPaperScissors.commitMove(uint256,bytes32)._commitHash](src/RockPaperScissors.sol#L191) is not in mixedCase

src/RockPaperScissors.sol#L191


 - [ ] ID-41
Parameter [RockPaperScissors.timeoutJoin(uint256)._gameId](src/RockPaperScissors.sol#L331) is not in mixedCase

src/RockPaperScissors.sol#L331


 - [ ] ID-42
Parameter [RockPaperScissors.canTimeoutJoin(uint256)._gameId](src/RockPaperScissors.sol#L360) is not in mixedCase

src/RockPaperScissors.sol#L360


