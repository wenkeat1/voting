# SMU Blockchain Dev assignemnt 1 - Wen Keat
This is a smart contract for a simple voting system for two candidates and here is the description of the code and how it works.
The start of the voting contract is first to set up a structure to store data of the candidates - ID, name and votecount.
Then use mappings to store voters(to ensure one vote per address) and candidates(predefined candidates).

Next is variables:
candidatesCount: This stores the number of predefined candidates (2 in this case).
electionOfficial: Stores the address of the election official (the account that deploys the contract).
electionStarted: A boolean flag to manage the election's state (whether it's active or ended).

Next is Events which are triggered at various points in the election process such as when votes are cast, when the election starts, and when the election ends.

