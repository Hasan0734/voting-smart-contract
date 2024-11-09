# Voting Smart Contract

This smart contract implements a decentralized voting system on the Ethereum blockchain. The contract allows the contract owner to add candidates, manage the voting period, and view the results. Participants can vote only once for a candidate of their choice, and the votes are counted securely.

## Contract Details

### Key Variables

- **startingTime**: The timestamp for when the voting period starts.
- **endingTime**: The timestamp for when the voting period ends.
- **isVoting**: A boolean value that shows if voting is currently active.
- **owner**: The address of the contract owner (the only one authorized to manage candidates and toggle voting).
- **candidates**: An array holding addresses of all candidates.
- **candidateExists**: A private mapping that checks if a candidate already exists.

### Structs

- **Vote**: Tracks each voter's selected candidate and the time of their vote.
  - `receiver`: Address of the candidate receiving the vote.
  - `timestamp`: The time when the vote was cast.

- **CandidateVote**: Represents a candidate's address and total votes.
  - `candidate`: Address of the candidate.
  - `votesCount`: The total number of votes received by the candidate.

### Mappings

- **votes**: Maps a voter's address to their vote details (if they've voted).
- **candidatesVotes**: Maps each candidate's address to their vote count.

### Events

- **VoteCast**: Emitted when a vote is cast, includes the voter's address, candidate's address, and timestamp.
- **VoteRemoved**: Emitted when a vote is removed by the owner.
- **VotingStatusChanged**: Emitted when the voting status changes, indicating if voting started or stopped.
- **CandidateAdded**: Emitted when a new candidate is added by the owner.

## Functions

### Constructor

```solidity
constructor(uint _startingTime, uint _endingTime)
