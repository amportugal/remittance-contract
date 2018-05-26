pragma solidity ^0.4.2;

contract Remittance {

    bytes32 public solution; //solution is a keccak256 hash to both otp1 and otp2 so that
                               // only 32 bits is stored as the solution to the puzzle
    address public owner;
    uint    public amountToSend;

    event LogWithdrawal(uint amountToSend, address receiverOfAmount);

    function Remittance()
        public
    {
        owner = msg.sender;
    }

    function yieldAmount(string otp1, string otp2) public returns(bool){
        require(amountToSend > 0);
        require(calculateHash(msg.sender, otp1, otp2) == solution);

        uint _amountToSend = amountToSend;
        amountToSend = 0;
        solution = bytes32(0);

        LogWithdrawal(_amountToSend, msg.sender);

        msg.sender.transfer(_amountToSend);

        return true;
    }

    function uploadSolution(bytes32 _solution)
        public
        payable
    {
        require(owner == msg.sender);
        require(msg.value > 0);
        require(_solution > 0);
        require(solution == 0);

        amountToSend = msg.value;
        solution = _solution;
    }

    function calculateHash(address remittedTo, string otp1, string otp2) 
        public 
        pure 
        returns(bytes32) 
    {
        return keccak256(remittedTo, otp1, otp2);
    }
}