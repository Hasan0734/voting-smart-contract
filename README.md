# Voting Smart Contract

This Solidity-based smart contract facilitates a voting mechanism within a specified time period, allowing the contract's owner to manage the voting process by setting the start and end times, adding candidates, and enabling or disabling voting as needed. Once voting is active, users can cast their votes for a registered candidate; additionally, the owner has the power to remove votes if necessary. The contract is designed to return an accurate winner based on the vote counts, with error handling in place for tie cases.

## Contract Overview

The contract employs several state variables, events, and mappings to manage voting-related actions, with specific access restrictions and conditions applied to control access.

### State Variables

- **`startingTime`** - A timestamp representing the designated start time for voting, set by the contract owner.
- **`endingTime`** - A timestamp marking the end time for the voting period.
- **`isVoting`** - A boolean flag indicating whether the voting session is currently active.
- **`owner`** - The Ethereum address of the contract’s owner, typically set upon deployment.
- **`candidates`** - An array that holds the list of candidate addresses eligible to receive votes.
- **`candidateExists`** - A mapping utilized to ensure that duplicate candidates cannot be added to the `candidates` array.

### Structs

- **`Vote`** - Defines a struct with two fields: `receiver` (the candidate voted for) and `timestamp` (the time the vote was cast).
- **`CandidateVote`** - Represents a candidate with a `candidate` address and a `votesCount` to track their vote tally.

### Events

- **`VoteCast`** - Triggered when a vote is successfully cast, logging the voter's address, the candidate's address, and the timestamp.
- **`VoteRemoved`** - Triggered whenever the contract owner removes a vote.
- **`VotingStatusChanged`** - Logs whenever the voting status (active or inactive) changes, along with the address that triggered it.
- **`CandidateAdded`** - Emits a log each time a new candidate is added to the `candidates` array.

## Functions

### `constructor()`

Initializes the contract and assigns the deployer of the contract as the `owner`, granting them exclusive access to certain functionalities.

### Modifiers

- **`onlyOwner`** - Restricts function access to only the contract owner; any attempt by another address will result in an error.
- **`votingDate`** - Ensures that both `startingTime` and `endingTime` are set before certain actions are taken.
- **`votingActive`** - Requires that voting must be active for the function to execute.
- **`withinVotingPeriod`** - Confirms the current time falls within the designated voting period.

### Core Functions

1. **`setDate(uint _startingTime, uint _endingTime)`**
   - Sets the voting start and end times; only the owner can invoke this function.
   - **Requirements**: The caller must be the owner, and the times must be in the future.

2. **`addCandidate(address _candidate)`**
   - Allows the owner to add a candidate address to the `candidates` array before voting starts.
   - **Requirements**: The function can only be called by the owner, and only if voting has not yet started and the candidate is not already added.

3. **`toggleVoting()`**
   - Toggles the state of voting; can be called to start or stop voting based on the current timestamp and set voting period.
   - **Requirements**: Only the owner can toggle, and only if voting dates are set and the current time aligns with them.

4. **`castVote(uint _candidateIndex)`**
   - Enables a user to vote for a candidate specified by their index in the `candidates` array.
   - **Requirements**: Voting must be active and within the period, and each voter can vote only once.

5. **`removeVote(address _voter)`**
   - Allows the owner to delete a vote from a specific voter, decrementing the candidate's vote count.
   - **Requirements**: This function is limited to the owner and can only be called while voting is active and within the voting period.

6. **`getCandidatesVotes()`**
   - Retrieves an array of `CandidateVote` structs, listing all candidates along with their respective vote counts.
   - **Returns**: An array displaying each candidate’s address and vote count.

7. **`getWinner()`**
   - Determines the candidate with the highest vote count; if there's a tie, the function reverts with an error message.
   - **Returns**: The vote count of the candidate with the highest votes, or an error message in the case of a tie.

## Usage Example

1. Deploy the contract on the Ethereum blockchain.
2. Use `setDate` to define the voting period (start and end times).
3. Add candidates with `addCandidate`, specifying each candidate's address.
4. Start voting by invoking `toggleVoting` once the start time has been reached.
5. Voters can cast their votes using `castVote`, passing the index of the desired candidate.
6. If necessary, remove a vote with `removeVote`, specifying the address of the voter whose vote should be removed.
7. Use `getCandidatesVotes` to retrieve the list of candidates and their votes during or after voting.
8. Call `getWinner` to determine the candidate with the highest votes; if there's a draw, the function reverts with an error.

---




### Note:
In the event of a tie between two or more candidates, `getWinner` will revert with an error message, "It's a Draw!". For more complex draw-handling logic, additional modifications would be required.

### License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ethereum/solidity-examples/blob/master/LICENSE) file for details.

