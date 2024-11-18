// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Voting {
    enum CandidateStatus {
        ACTIVE,
        PENDING,
        BLOCK
    }

    struct Vote {
        address receiver;
        uint256 timestamp;
    }
    struct Candidate {
        address _address;
        string name;
        string profession;
        CandidateStatus status;
    }
    struct CandidateVote {
        address _address;
        uint256 votesCount;
        Candidate profile;
    }

    uint256 public startingTime;
    uint256 public endingTime;
    bool public isVoting;
    address public owner;
    Candidate[] public candidatesData;
    mapping(address => Candidate) public candidates;
    mapping(address => bool) private candidateExists;
    mapping(address => Vote) public votes;
    mapping(address => uint256) public candidatesVotes;

    event VoteCast(address indexed voter, address receiver, uint256 timestamp);
    event VoteRemoved(address voter);
    event VotingStatusChanged(bool isVoting, address triggeredBy);
    event CandidateAdded(address candidate);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    modifier votingDate() {
        require(startingTime > 0, "Starting time is required!");
        require(endingTime > 0, "Ending time is required!");
        require(endingTime > block.timestamp, "Voting time is ended");
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

    modifier isCandidateExist(address _address) {
        Candidate storage candidate = candidates[_address];
        require(candidate._address == _address, "Candidate not found");
        _;
    }

    function setDate(uint256 _startingTime, uint256 _endingTime)
        external
        onlyOwner
    {
        require(
            _endingTime > _startingTime,
            "End Time should be greater than Start Time"
        );
        startingTime = _startingTime;
        endingTime = _endingTime;
    }

    function addCandidate(
        address _candidateAddress,
        string memory _name,
        string memory _profession
    ) external onlyOwner {
        require(_candidateAddress != msg.sender, "Owner cannot be a candidate");
        require(!isVoting, "Cannot add candidates after voting has started");
        Candidate storage candidate = candidates[_candidateAddress];
        require(
            candidate._address != _candidateAddress,
            "Candidate already exists"
        );

        candidates[_candidateAddress] = Candidate(
            _candidateAddress,
            _name,
            _profession,
            CandidateStatus.PENDING
        );
        candidatesData.push(
            Candidate(
                _candidateAddress,
                _name,
                _profession,
                CandidateStatus.PENDING
            )
        );
        // candidateExists[_candidateAddress] = true;
        emit CandidateAdded(_candidateAddress);
    }

    function updateCandidate(
        address _candidateAddress,
        string memory _name,
        string memory _profession
    ) external onlyOwner isCandidateExist(_candidateAddress) {
        require(!isVoting, "Cannot update candidates after voting has started");
        candidates[_candidateAddress] = Candidate(
            _candidateAddress,
            _name,
            _profession,
            CandidateStatus.PENDING
        );
        emit CandidateAdded(_candidateAddress);
    }

    function activateCandidate(address _address)
        external
        onlyOwner
        isCandidateExist(_address)
    {
        Candidate storage candidate = candidates[_address];
        require(
            candidate.status != CandidateStatus.ACTIVE,
            "Already Activated!"
        );
        candidate.status = CandidateStatus.ACTIVE;
    }

    function pendingCandidate(address _address)
        external
        onlyOwner
        isCandidateExist(_address)
    {
        Candidate storage candidate = candidates[_address];

        require(
            candidate.status != CandidateStatus.PENDING,
            "Already Pending!"
        );
        candidate.status = CandidateStatus.PENDING;
    }

    function blockCandidate(address _address)
        external
        onlyOwner
        isCandidateExist(_address)
    {
        Candidate storage candidate = candidates[_address];
        require(candidate.status != CandidateStatus.BLOCK, "Already Block!");
        candidate.status = CandidateStatus.BLOCK;
    }

    function toggleVoting() external onlyOwner votingDate {
        if (!isVoting) {
            require(
                block.timestamp >= startingTime,
                "Too early to start voting"
            );
            isVoting = true;
        } else {
            // require(block.timestamp >= endingTime, "Too early to end voting");
            isVoting = false;
        }
        emit VotingStatusChanged(isVoting, msg.sender);
    }

    function castVote(address _address)
        external
        votingActive
        withinVotingPeriod
        isCandidateExist(_address)
    {
        Candidate storage candidate = candidates[_address];

        Vote storage vote = votes[msg.sender];
        require(vote.receiver == address(0), "Vote already cast");

        require(
            candidate.status == CandidateStatus.ACTIVE,
            "Candidate is not active"
        );

        vote.receiver = candidate._address;
        vote.timestamp = block.timestamp;
        candidatesVotes[candidate._address] += 1;
        emit VoteCast(msg.sender, candidate._address, vote.timestamp);
    }

    function removeVote(address _voter)
        external
        onlyOwner
        votingActive
        withinVotingPeriod
    {
        Vote storage vote = votes[_voter];
        require(vote.receiver != address(0), "No vote to remove");

        candidatesVotes[vote.receiver] -= 1;
        delete votes[_voter];

        emit VoteRemoved(_voter);
    }

    function getCandidatesVotes() public view returns (CandidateVote[] memory) {
        CandidateVote[] memory totalVotes = new CandidateVote[](
            candidatesData.length
        );

        for (uint256 i = 0; i < candidatesData.length; i++) {
            Candidate memory candidate = candidatesData[i];
            totalVotes[i] = CandidateVote(
                candidate._address,
                candidatesVotes[candidate._address],
                candidate
            );
        }

        return totalVotes;
    }

    // function getWinner() public view returns (uint) {
    //     uint largest = 0;
    //     bool isDraw;

    //     for (uint i; i < candidates.length; i++)   {
    //         if(candidatesVotes[candidates[i].addr] > largest) {
    //           largest =  candidatesVotes[candidates[i].addr];
    //           isDraw = false;
    //         }else if(candidatesVotes[candidates[i].addr] == largest && candidatesVotes[candidates[i].addr] != 1){
    //               isDraw = true;
    //         }
    //     }
    //  if (!isDraw)
    //   return largest;

    // // If there's a draw, you can either throw an error or handle it in some other way
    // revert("It's a Draw!");
    // }
}
