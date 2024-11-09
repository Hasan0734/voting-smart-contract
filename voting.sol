// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Voting {

    uint public startTime;
    uint public endingTime;
    bool public isVoting;
    address public owner;
    address[] public  candidates;

    struct Vote{
        address receiver;
        uint256 timestamp;
    }

    struct CandidateVote{
        address candidate;
        uint256 votesCount; 
    } 
    
    mapping (address => Vote) public votes;
    mapping (address => uint) public  candidatesVotes;

    // defineing events

    event AddVote(address indexed voter, address receiver, uint256 timestamp);
    event RemoveVote(address voter);
    event StartVoting(address startBy);
    event StopVoting(address stoppedBy);
    event AddCandidate(address candidate);

    constructor(uint _startTime, uint _endTime) {
        owner = msg.sender;
        startTime = _startTime;
        endingTime = _endTime;
    }

    modifier onlyOwner(){ 
        require(msg.sender == owner, "not owner");
        _;
    }

    function isInCandidates(address _candidate) private view  returns(bool){

        for (uint i = 0; i < candidates.length; i++)   {
            
            if(candidates[i] == _candidate) {
                return true;
            }
        }
        return  false;
    }

    function addCandidate(address _candidate) external onlyOwner{
        require(msg.sender != _candidate, "You cant be candidate!");
        require(!isVoting, "Already voting started, cant add new candiate");
        require(!isInCandidates(_candidate) , "Already exists");
     
        candidates.push(_candidate);
        emit AddCandidate(_candidate);
    }

    function startAndStopVoting() external onlyOwner{
        if(!isVoting) {
            require(block.timestamp >= startTime, "Voting time is comming!");
            isVoting = true;
            emit StartVoting(msg.sender);
        }else  {
            require(block.timestamp >= endingTime, "Voting time is not ended!");
            isVoting = false;
            emit StopVoting(msg.sender); 
        }
    }

    function castVote(uint _receiver) external{
        require(isVoting, "Vote not started");
        require(block.timestamp <= endingTime, "Voting time is ended!");
        require(_receiver < candidates.length && _receiver >= 0, "Candidate not found!");

        Vote storage vote = votes[msg.sender];
        require(vote.receiver == address(0), "Already, casted your vote!");
        
        vote.receiver = candidates[_receiver];
        vote.timestamp = block.timestamp;
        candidatesVotes[candidates[_receiver]] += 1;
        emit AddVote(msg.sender, vote.receiver, vote.timestamp);
    }

    function removeVote(address _voter) external onlyOwner {
        Vote storage vote = votes[_voter];
        require(vote.receiver != address(0), "Not vote available");
        
        delete votes[_voter];
        emit  RemoveVote(_voter);
    }

    function findCandidate (uint _index) external view returns (address){
        return candidates[_index];
    }

    function getCandidatesVote() public view returns( CandidateVote[] memory) {

        CandidateVote[] memory totalCastedVote = new CandidateVote[](candidates.length);
        
        for (uint i=0; i < candidates.length;i++){
            totalCastedVote[i].candidate  =   candidates[i];
            totalCastedVote[i].votesCount = candidatesVotes[candidates[i]];
        }

        return totalCastedVote;

    }


}