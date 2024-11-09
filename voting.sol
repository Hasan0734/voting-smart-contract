// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Voting {

    uint public startingTime;
    uint public endingTime;
    bool public isVoting;
    address public owner;
    address[] public candidates;
    mapping(address => bool) private candidateExists;

    struct Vote {
        address receiver;
        uint256 timestamp;
    }

    struct CandidateVote {
        address candidate;
        uint256 votesCount; 
    } 
    
    mapping(address => Vote) public votes;
    mapping(address => uint) public candidatesVotes;

    event VoteCast(address indexed voter, address receiver, uint256 timestamp);
    event VoteRemoved(address voter);
    event VotingStatusChanged(bool isVoting, address triggeredBy);
    event CandidateAdded(address candidate);

    constructor(uint _startingTime, uint _endingTime) {
        owner = msg.sender;
        startingTime = _startingTime;
        endingTime = _endingTime;
    }

    modifier onlyOwner() { 
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier votingActive() {
        require(isVoting, "Voting is not active");
        _;
    }

    modifier withinVotingPeriod() {
        require(block.timestamp >= startingTime, "Voting has not started yet");
        require(block.timestamp <= endingTime, "Voting has ended");
        _;
    }

    function addCandidate(address _candidate) external onlyOwner {
        require(_candidate != msg.sender, "Owner cannot be a candidate");
        require(!isVoting, "Cannot add candidates after voting has started");
        require(!candidateExists[_candidate], "Candidate already exists");

        candidates.push(_candidate);
        candidateExists[_candidate] = true;
        emit CandidateAdded(_candidate);
    }

    function toggleVoting() external onlyOwner {
        if (!isVoting) {
            require(block.timestamp >= startingTime, "Too early to start voting");
            isVoting = true;
        } else {
            require(block.timestamp >= endingTime, "Too early to end voting");
            isVoting = false;
        }
        emit VotingStatusChanged(isVoting, msg.sender);
    }

    function castVote(uint _candidateIndex) external votingActive withinVotingPeriod {
        require(_candidateIndex < candidates.length, "Candidate not found");

        Vote storage vote = votes[msg.sender];
        require(vote.receiver == address(0), "Vote already cast");

        address candidateAddress = candidates[_candidateIndex];
        vote.receiver = candidateAddress;
        vote.timestamp = block.timestamp;
        candidatesVotes[candidateAddress] += 1;

        emit VoteCast(msg.sender, candidateAddress, vote.timestamp);
    }

    function removeVote(address _voter) external onlyOwner votingActive withinVotingPeriod {
        Vote storage vote = votes[_voter];
        require(vote.receiver != address(0), "No vote to remove");

        candidatesVotes[vote.receiver] -= 1;
        delete votes[_voter];

        emit VoteRemoved(_voter);
    }

    function getCandidate(uint _index) external view returns (address) {
        return candidates[_index];
    }

    function getCandidatesVotes() public view returns (CandidateVote[] memory) {
        CandidateVote[] memory totalVotes = new CandidateVote[](candidates.length);

        for (uint i = 0; i < candidates.length; i++) {
            address candidate = candidates[i];
            totalVotes[i] = CandidateVote(candidate, candidatesVotes[candidate]);
        }

        return totalVotes;
    }
}
