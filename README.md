# SMU Blockchain Dev assignment 1 - Wen Keat
This is a smart contract for a simple voting system for two candidates and here is the description of the code and how it works.
Contract address:
https://sepolia.etherscan.io/address/0xF1f7f0eF6aD81383197657DD4Eef7587E27AD1Ee

The start of the voting contract is first to set up a structure to store data of the candidates - ID, name and votecount.
Then use mappings to store voters(to ensure one vote per address) and candidates(predefined candidates).

Next is variables:
candidatesCount: This stores the number of predefined candidates (2 in this case).
electionOfficial: Stores the address of the election official (the account that deploys the contract).
electionStarted: A boolean flag to manage the election's state (whether it's active or ended).

Next is Events which are triggered at various points in the election process such as when votes are cast, when the election starts, and when the election ends.

Modifiers
onlyOfficial(): This ensures that only the election official (the person who deployed the contract) can call specific functions like startElection() and endElection().
electionActive(): This ensure that voting can only happen when election has started.

Constructor
Sets election official as the person who deployed the contract and call addPredefinedCandidates() function to set predefined candidates when contract is deployed.

Functions
addPredefinedCandidates()
This function defines and stores two candidates. It assigns:
Candidate A with an id of 1.
Candidate B with an id of 2.
Each candidate starts with a voteCount of 0. Since it is called inside the constructor, this function executes automatically upon deployment.

startElection()
This function can only be called by the election official and is used to start the election process:
It sets the electionStarted boolean to true, signaling that the election is active and votes can now be cast.
An ElectionStarted event is emitted, which could be useful for off-chain systems tracking election progress.

vote()
This is the core function where users cast their votes. 
Here's how it works:
Check if election is active: The function ensures that the election has started using the electionActive modifier.
Check if the voter has already voted: Using the voters mapping, the contract checks whether the voter's address has already been recorded. Each address is allowed to vote only once.
Validate the candidate ID: It verifies that the selected candidate’s ID is valid (either 1 for Candidate A or 2 for Candidate B).
Record the vote:
The voter's address is marked as having voted.
The selected candidate’s voteCount is incremented by 1.
Emit a VoteCast event: This broadcasts the voting event to the blockchain.

endElection()
The election official can call this function to end the voting process:
It sets the electionStarted boolean to false, preventing further voting.
An ElectionEnded event is emitted, signaling the election's conclusion.

getCandidate()
This function returns details of a specific candidate based on their id. It provides:
The candidate's name.
The candidate's current vote count.
This function is useful for anyone wanting to check how many votes a particular candidate has received at any point.

getVoteCount()
Similar to getCandidate(), but it only returns the voteCount for a given candidate. It’s a simple way to check how many votes a candidate has without needing other candidate details like name.

getWinner()
This function calculates and returns the winner of the election:
It loops through both candidates and checks which one has the highest vote count.
The name of the candidate with the most votes is returned.
If there is a tie, the candidate who appears first in the list (Candidate A) will be returned as the winner by default since the code doesn’t handle ties explicitly.

Flow of election process using this contract:
1. Contract Deployment:
The election official deploys the contract, automatically setting their address as the election official and adding Candidate A and Candidate B.

2. Starting the Election:
The election official calls startElection() to begin the voting process.

3. Voting:
Any voter address that has not voted can vote for either Candidate A (ID 1) or Candidate B (ID 2) by calling vote(). Each voter can only vote once.

4. Ending the Election:
Once the voting period is over, the election official calls endElection() to stop further voting.

5. Result Reporting:
Anyone can check the current vote count using getVoteCount() or view the election winner by calling getWinner().

