pragma solidity ^0.4.2;

contract Remittance {

    bytes32 public solution; //solution is a keccak256 hash to both otp1 and otp2 so that
                               // only 32 bits is stored as the solution to the puzzle
    address public owner;
    uint    public amountToSend;
    uint    public blockTimeout;

    mapping (bytes32 => uint) public alreadySubmittedSolutions;

    event LogWithdrawal(uint amountToSend, address receiverOfAmount);

    function Remittance()
        public
    {
        owner = msg.sender;
    }

    function yieldAmount(bytes32 otp1, bytes32 otp2) public returns(bool){
        require(amountToSend > 0);
        require(calculateHash(msg.sender, otp1, otp2) == solution);

        uint _amountToSend = amountToSend;
        amountToSend = 0;
        solution = bytes32(0);

        LogWithdrawal(_amountToSend, msg.sender);

        msg.sender.transfer(_amountToSend);

        return true;
    }

    function uploadSolution(bytes32 _solution, uint _blockTimeout)
        public
        payable
    {
        require(owner == msg.sender);
        require(msg.value > 0);
        require(_solution > 0);
        //require(solution == 0); The next condition already verifies this
        require(alreadySubmittedSolutions[_solution] == 0);

        blockTimeout = block.number + _blockTimeout;

        amountToSend = msg.value;
        solution = _solution;
        alreadySubmittedSolutions[_solution] = 1;
    }

    function withdrawEtherForOwner()
        public
        returns(bool)
    {
        require(owner == msg.sender);
        require(amountToSend > 0);
        require(block.number >= blockTimeout);

        uint _amountToSend = amountToSend;
        amountToSend = 0;
        solution = bytes32(0);

        msg.sender.transfer(_amountToSend);

        return true;
    }

    function calculateHash(address remittedTo, bytes32 otp1, bytes32 otp2) 
        public 
        view 
        returns(bytes32) 
    {
        return keccak256(remittedTo, otp1, otp2, address(this));
    }
}