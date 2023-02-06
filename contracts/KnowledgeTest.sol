//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
    string[] public tokens = ["BTC", "ETH"];
    address[] public players;

    address public owner;

    constructor (){
        owner = msg.sender;
    }

    function changeTokens() public  {
        string[] storage t = tokens;
        t[0] = "VET";
    }

    function getBalance() external view returns(uint256){
        return address(this).balance;
    }

    function transferAll(address payable to) external payable{
        require(msg.sender == owner, "ONLY_OWNER");
        to.send(address(this).balance);
    }

    function start() external{
        players.push(msg.sender);
    }

    function concatenate(string memory one, string memory two) external pure returns(string memory){
        return string(abi.encodePacked(one,two));
    }

    fallback() external payable {  }
}