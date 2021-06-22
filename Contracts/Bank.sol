pragma solidity 0.7.5;
import './Destroyable.sol';

interface GovernmentInterface{
    function addTransaction(address _from, address _to,uint _amount) external payable;
}

contract Bank is Destroyable{
    
    // Here argument of GovernmentInterface is the address of Government contract
    GovernmentInterface govtInstance = GovernmentInterface(0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d);
    mapping(address => uint) balance;
    event BalanceDeposited(uint amount, address indexed depositedTo);
    event AmountTransferred(address from , address to , uint amount);
    
    function deposit() public  payable returns(uint){
        balance[msg.sender] += msg.value;
        emit BalanceDeposited(msg.value,msg.sender);
        return balance[msg.sender];
    }
    
    function withdraw (uint amount) public onlyOwner returns(uint){
        require(balance[msg.sender] >= amount , 'Withdrawal is more than a deposit');
        uint oldBlance = balance[msg.sender];
        balance[msg.sender] -= amount;
        msg.sender.transfer(amount);
        assert(balance[msg.sender] == oldBlance - amount);
        return balance[msg.sender];
       
    }
    
    function transfer(address recipient, uint amount) public {
        require(balance[msg.sender] >= amount, 'Insufficient Balance');
        require(msg.sender != recipient);
        uint previousSenderBalance = balance[msg.sender];
        _transfer(msg.sender,recipient,amount);
        govtInstance.addTransaction{value: 1 ether}(msg.sender, recipient,amount);
        assert(balance[msg.sender] == previousSenderBalance - amount);
        emit AmountTransferred(msg.sender,recipient,amount);
    }
    
    function _transfer(address from, address to,uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    } 
    
    function getBalance () public view returns(uint){
        return balance[msg.sender];
    }
}


