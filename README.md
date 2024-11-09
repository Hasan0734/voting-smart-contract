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

### Modifiers
- **onlyOwner**: Restricts functions to be callable only by the contract owner
- **votingActive**: Ensures the voting period is active before allowing certain operations.
- **withinVotingPeriod**: Verifies the current time is within the designated voting period.

## Public and External Functions
- **addCandidate(address _candidate)**: Allows the owner to add a candidate before voting begins.
  - Requirements: 
    - `msg.sender` is the owner.
    - The candidate is not the owner.
    - Voting has not started.
    - The candidate does not already exist.
  - Emits `CandidateAdded`.
- **toggleVoting()**: Allows the owner to start or stop voting based on the current state.
  - Requirements:
    - If starting, `block.timestamp` must be at or after `startingTime`.
    - If stopping, `block.timestamp` must be at or after `endingTime`.
  - Emits `VotingStatusChanged`.
- **castVote(uint _candidateIndex**): Allows a voter to cast a vote for a candidate by index.
  - Requirements:
    - Voting is active and within the voting period.
    - Candidate index is valid.
    - Voter has not already voted.
  - Emits `VoteCast`.
- **removeVote(address _voter)**: Allows the owner to remove a voter's vote, reducing the candidate’s vote count.
  - Requirements:
    - Voting is active and within the voting period.
    - Voter has already cast a vote.
  - Emits `VoteRemoved`
- **getCandidate(uint _index)**: Returns the candidate address at a specific index.
- **getCandidatesVotes()**: Returns a list of `CandidateVote` structs containing each candidate’s address and their vote count.

### Constructor

```solidity
constructor(uint _startingTime, uint _endingTime)
```

# Usage Example


## Adding Candidates
- The owner calls `addCandidate` for each candidate's address.
- Each new candidate is recorded, and duplicates are prevented.

## Starting Voting
- The owner calls `toggleVoting` to start the voting period.
- Voting can only be toggled on or off based on `startingTime` and `endingTime`.

## Casting a Vote
- A voter calls `castVote` with the candidate index to vote.
- The contract checks if the voter hasn’t already voted.
- The vote count for the candidate is incremented.

## Viewing Results
- Anyone can call `getCandidatesVotes` to view current vote counts for all
- The results display an array of `CandidateVote` structs with candidate addresses and vote counts.

## Removing a Vote
- The owner calls removeVote to remove a voter's vote.
- The vote count for the chosen candidate is decremented.

## Security Considerations
- **Only the owner** can add candidates and manage the voting period.
- **One vote per person**: Once a vote is cast, it cannot be changed by the voter (only removed by the owner if necessary).
- **No tampering with results**: Voting data is securely stored on-chain, making results tamper-resistant.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ethereum/solidity-examples/blob/master/LICENSE) file for details.

