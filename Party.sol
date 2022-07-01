// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Party {
    address public admin;

    struct Owner {
        address id;
        mapping(address => bool) isOwner;
    }

    mapping (address => Owner) public owner;

    constructor() {
        admin = payable(msg.sender);
        owner[admin].id = admin;
        owner[admin].isOwner[admin]= true;
    }

    struct Proposal {
        uint256 deadline;
        uint256 yayVotes;
        uint256 nayVotes;
        uint256 amount;
        bool executed;
    }

    // Create a mapping of ID to Proposal
    mapping(uint256 => Proposal) public proposals;
    // Number of proposals that have been created
    uint256 public numProposals;

    // Create an enum named Vote containing possible options for a vote
    enum Vote {
        YAY, // YAY = 0
        NAY // NAY = 1
    }

    modifier onlyAdmin {
        require(admin == msg.sender, "only the admin can call this function");
        _;
    }

    modifier onlyOwner {
        require(owner[msg.sender].id == msg.sender, "only the owner can call this function");
        _;
    }

    // Create a modifier which only allows a function to be called if the given proposal's deadline has not been exceeded yet
    modifier activeProposalOnly(uint256 proposalIndex) {
        require(
            proposals[proposalIndex].deadline > block.timestamp,
            "DEADLINE_EXCEEDED"
        );
        _;
    }

    modifier inactiveProposalOnly(uint256 proposalIndex) {
     require(
        proposals[proposalIndex].deadline <= block.timestamp,
        "DEADLINE_NOT_EXCEEDED"
      );
     require(
        proposals[proposalIndex].executed == false,
        "PROPOSAL_ALREADY_EXECUTED"
     );
     _;
    }

    receive() external payable {}

    function addOwner(address _addr) public onlyAdmin {
        owner[_addr].id = _addr;
        owner[_addr].isOwner[_addr] = true;
    }

    function removeOwner(address _addr) public onlyAdmin {
        delete owner[_addr];
    }

    function checkIfOwnerExists(address _addr) public view returns (bool) {
        return owner[_addr].isOwner[_addr];
    }

    function createProposal(uint256 _amount) external onlyOwner returns (uint256) {
        require(address(this).balance >= _amount, "Not Enough Ether");
        Proposal storage proposal = proposals[numProposals];
        proposal.deadline = block.timestamp + 5 minutes;
        proposal.amount = _amount;
        numProposals++;

        return numProposals - 1; 
    }

    function voteOnProposal(uint256 proposalIndex, Vote vote) external onlyOwner activeProposalOnly(proposalIndex){
        Proposal storage proposal = proposals[proposalIndex];
        uint256 numVotes = 0;
        numVotes++;


        require(numVotes < 0, "ALREADY_VOTED");
        if (vote == Vote.YAY) {
            proposal.yayVotes += numVotes;
        } else {
            proposal.nayVotes += numVotes;
        }
    }

    function executeProposal(uint256 proposalIndex) external onlyOwner inactiveProposalOnly(proposalIndex){
     Proposal storage proposal = proposals[proposalIndex];
        uint256 proposalAmount = proposal.amount;
     // If the proposal has more YAY votes than NAY votes
     if (proposal.yayVotes > proposal.nayVotes) {
         payable(msg.sender).transfer(proposalAmount);
     }
     proposal.executed = true;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

}
