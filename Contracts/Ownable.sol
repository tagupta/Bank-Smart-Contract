pragma solidity 0.7.5;

contract Ownable {
    address payable owner;
  
    modifier onlyOwner {
       require(msg.sender == owner,'Accessible by owner only');
       _;
    }
    constructor(){
        owner = msg.sender;
       
    }
}
