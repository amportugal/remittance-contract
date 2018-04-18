pragma solidity ^0.4.2;

contract Remittance {

    bytes32  private solution; //solution is a keccak256 hash to both otp1 and otp2 so that
                               // only 32 bits is stored as the solution to the puzzle
    address public owner;
    uint    public amountToSend;

    function Remittance(string otp1, string otp2) public payable{
        require(msg.value > 0);

        owner = msg.sender;
        amountToSend = msg.value;
        solution = keccak256(otp1, otp2);
    }

    function yieldAmount(string otp1, string otp2) public returns(bool){
        require(amountToSend > 0);
        require(keccak256(otp1, otp2) == solution);

        msg.sender.transfer(amountToSend);

        return true;
    }
}