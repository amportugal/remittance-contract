pragma solidity ^0.4.2;

contract Remittance {

    bytes32  private solution; //solution is a keccak256 hash to both otp1 and otp2 so that
                               // only 32 bits is stored as the solution to the puzzle
    address public owner;
    uint    public amountToSend;

    //event LogWithdrawal(uint amountToSend, address receiverOfAmount);

    function Remittance(bytes32 _solution) public payable{
        require(msg.value > 0);

        owner = msg.sender;
        amountToSend = msg.value;
        solution = _solution;
    }

    function yieldAmount(string otp1, string otp2) public returns(bool){
        require(amountToSend > 0);
        require(keccak256(otp1, otp2) == solution);

        uint _amountToSend = amountToSend;
        amountToSend = 0;

        //LogWithdrawal(_amountToSend, msg.sender);

        msg.sender.transfer(_amountToSend);

        return true;
    }
}