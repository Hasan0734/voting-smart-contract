# Voting Smart Contract

This Solidity smart contract implements a simple decentralized voting system where an owner can add candidates, manage voting periods, and users can vote for candidates. It securely counts votes, prevents duplicate voting, and provides a transparent view of the results.

## Features

- **Owner Management**: Only the owner can add candidates and control voting periods.
- **Voting Period Control**: The owner can start or stop the voting within a specified period.
- **Vote Casting**: Each user can vote for a candidate only once.
- **Result Transparency**: Vote counts for each candidate are publicly viewable.

## Contract Details

### Key Variables

- **`startingTime`** (`uint`): The start timestamp for the voting period.
- **`endingTime`** (`uint`): The end timestamp for the voting period.
- **`isVoting`** (`bool`): Indicates if voting is currently active.
- **`owner`** (`address`): The address of the contract owner.
- **`candidates`** (`address[]`): Array storing candidate addresses.
- **`candidateExists`** (`mapping(address => bool)`): Mapping to check if a candidate already exists.

### Structs

- **Vote**: Tracks the details of each voter’s vote.
  - `receiver` (`address`): Candidate receiving the vote.
  - `timestamp` (`uint256`): Timestamp when the vote was cast.

- **CandidateVote**: Contains candidate address and their vote count.
  - `candidate` (`address`): Address of the candidate.
  - `votesCount` (`uint256`): Total number of votes received by the candidate.

### Mappings

- **votes** (`mapping(address => Vote)`): Maps a voter's address to their vote details.
- **candidatesVotes** (`mapping(address => uint)`): Maps each candidate's address to their total votes.

### Events

- **VoteCast**: Emitted when a vote is cast.
- **VoteRemoved**: Emitted when a vote is removed by the owner.
- **VotingStatusChanged**: Emitted when voting status is toggled.
- **CandidateAdded**: Emitted when a new candidate is added by the owner.

## Functions

### Constructor

```solidity
constructor(uint _startingTime, uint _endingTime)
