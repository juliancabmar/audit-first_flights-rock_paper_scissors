Conditions: states on that the entities will be available or not

Entities:

The process of <action>
The process execution of <action>
The function
The function execution
The contract
The balance
The property value
The variable value
The error
The event
The actor
The protocol
The relation of <property> between <entity>, ..., and <entity>
The state of the <entity>
The <property> of <entitie/s>


Promises:

allways will
    be
    have
    do
    <action>
    can
        be
        have
        do
        <action>

never will
    be
    have
    do
    <action>
    can
        be
        have
        do
        <action>



INVARIANT: If <condition> the <entity> <promise> <entity or action> unless what <exceptions>

Impact:
Likehood: see the code (the docs can lie, but not the code)

-------------------------------------------------------------------------------------------------------

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

--------------------------------------------------------------
Someone never will call a function without access for it
The protocol never will revert with an unexpected error
The contract balance never will be less than the previos run
For every game the max current turn will be: <= (totalTurns + 1) / 2


main doc: https://book.getfoundry.sh/forge/advanced-testing/invariant-testing
Gooood article: https://medium.com/@regis-graptin/fuzz-testing-invariants-in-solidity-secure-smart-contracts-with-foundry-1fb319204d95