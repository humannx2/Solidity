// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract lottery{
    // defining entities for the game
    address public manager;
    address payable [] public players;
    address payable public winner;
    // made all addresses public, for everyone to know

    // assign the person who runs the contract as manager

    constructor(){
        manager=msg.sender;
    }

    function participants() public payable {
        require(msg.value==1 ether,"Please Pay 1 ether to enter");
        players.push(payable (msg.sender));
    }

    // check the balance of the smart contract or total money up for winning
    function balance() public view returns (uint){
        require(manager==msg.sender,"This can be acesssed by the Manager");
        return address(this).balance; // address(this) -> address of contract itself
    }

    // function to pick up a random player as winner
    function random() internal view returns (uint){
         return uint((block.prevrandao)%players.length); // not a secure method, use oracle instead
    }

    // function to pick winner
    function pick_winner() public {
        require(manager==msg.sender,"YOu are not the manager");
        require(players.length>=3,"Atleast 3 Players are needed");

        uint randomNum=random(); //calls random function to get a random number
        uint index=randomNum%players.length; // gets a smaller number out of that random number
        winner=players[index]; // access the player address
        winner.transfer(balance()); // transfer all the balance to them
        players=new address payable [](0); // initializes the players array back to zero
    }
}