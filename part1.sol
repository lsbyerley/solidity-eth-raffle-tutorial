pragma solidity ^0.4.23;

contract Blocksplit {

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

}
