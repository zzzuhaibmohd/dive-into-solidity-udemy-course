//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract Lottery {
    // declaring the state variables
    address[] public players; //dynamic array of type address payable
    address[] public gameWinners;
    address public owner;

    // declaring the constructor
    constructor() {
        // TODO: initialize the owner to the address that deploys the contract
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner,"ONLY_OWNER");
        _;
    }

    // declaring the receive() function that is necessary to receive ETH
    receive() external payable {
        // TODO: require each player to send exactly 0.1 ETH
        // TODO: append the new player to the players array
        require(msg.value == 0.1 ether, "Incorrect Value");
        players.push(msg.sender);
    }

    // returning the contract's balance in wei
    function getBalance() onlyOwner public view returns (uint256) {
        // TODO: restrict this function so only the owner is allowed to call it
        // TODO: return the balance of this address
        return address(this).balance;
    }

    // selecting the winner
    function pickWinner() onlyOwner public {
        // TODO: only the owner can pick a winner 
        // TODO: owner can only pick a winner if there are at least 3 players in the lottery

        require(players.length >=3, "NOT_ENOUGH_PLAYERS");
        uint256 r = random();
        address winner;

        // TODO: compute an unsafe random index of the array and assign it to the winner variable
        winner = players[r % players.length];

        // TODO: append the winner to the gameWinners array
        gameWinners.push(winner);

        // TODO: reset the lottery for the next round
        delete players;

        // TODO: transfer the entire contract's balance to the winner
        (bool success,) = winner.call{value: getBalance()}("");
        require(success,"FAIL_TRANSFER");
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }
}
