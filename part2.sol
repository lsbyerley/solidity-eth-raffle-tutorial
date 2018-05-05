pragma solidity ^0.4.23;

contract Blocksplit {

    // may 15 2018 https://www.epochconverter.com/
    uint256 startTime = 1526401466;

    uint256 drawnBlock = 0;

    address[] public players;

    mapping (address => bool) public uniquePlayers;

    address[] public winners;

    address public charity = 0xc39eA9DB33F510407D2C77b06157c3Ae57247c2A;

    function play(address _participant) payable public {

        // transaction contains an amount of ether bigger than or equal to 0.001 ether,
        // or less than or equal to 0.1 ether
        require (msg.value >= 1000000000000000 && msg.value <= 100000000000000000);

        // make sure the player isn't already in the game
        require (uniquePlayers[_participant] == false);

        // add the player to players address and set entry to true
        players.push(_participant);
        uniquePlayers[_participant] = true;

    }

    function() external payable {
        play(msg.sender);
    }

    function draw() external {

        require (winners.length < 2);
        require (block.number != drawnBlock);
        require (now - startTime > 2 weeks);

        drawnBlock = block.number;

        uint256 winningIndex = randomGen();
        address winner = players[winningIndex];
        winners.push(winner);

        players[winningIndex] = players[players.length - 1];
        players.length--;

        delete players[winningIndex];

        if (winners.length == 2) {
            charity.transfer(address(this).balance);
        }

    }

    function randomGen() constant internal returns (uint256 randomNumber) {
        uint256 seed = uint256(blockhash(block.number - 200));
        return(uint256(keccak256(blockhash(block.number-1), seed )) % players.length);
    }

}
