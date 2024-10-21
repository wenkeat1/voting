// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Voting {
    //define structure to hold data of candidates
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

//store voters and candidates
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;

//variables
    uint public candidatesCount;

    address public electionOfficial;
    bool public electionStarted;

//events
    event VoteCast(address indexed voter, uint indexed candidateId);
    event ElectionStarted();
    event ElectionEnded();

//modifier to ensure that only election official address can start election
    modifier onlyOfficial() {
        require(msg.sender == electionOfficial, "Invalid. Only the election official can call this function.");
        _;
    }

//modifier to ensure that voting can only happen when election has started
    modifier electionActive() {
        require(electionStarted == true, "The election has not started. Election official needs to activate startElection");
        _;
    }

//define election official and call function to set predefined candidates when contract is deployed
    constructor() {
        electionOfficial = msg.sender;
        addPredefinedCandidates();
    }

//function to set two predefined candidates as Candidate A and B
    function addPredefinedCandidates() internal {
        candidatesCount = 2;
        candidates[1] = Candidate(1, "Candidate A", 0);
        candidates[2] = Candidate(2, "Candidate B", 0);
    }

//function to start election
    function startElection() public onlyOfficial {
        electionStarted = true;
        emit ElectionStarted();
    }

//function to vote and check to ensure that each address can only vote once
    function vote(uint _candidateId) public electionActive {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit VoteCast(msg.sender, _candidateId);
    }

//function to stop election
    function endElection() public onlyOfficial {
        electionStarted = false;
        emit ElectionEnded();
    }

//function to get info on candidate and his/her vote count by ID
    function getCandidate(uint _candidateId) public view returns (string memory, uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }

//function to get votecount for a candidate by ID
    function getVoteCount(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");
        return candidates[_candidateId].voteCount;
    }

//function to get winner based on highest vote count
    function getWinner() public view returns (string memory) {
        uint highestVotes = 0;
        uint winnerId = 0;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        return candidates[winnerId].name;
    }
}
