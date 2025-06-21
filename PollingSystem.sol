// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollingSystem {

    struct Poll {
        string title;
        string[] options;
        mapping(uint => uint) voteCount; // option index => votes
        uint endTime;
        mapping(address => bool) voters; // track who has voted
        bool exists;
    }

    uint public pollId;
    mapping(uint => Poll) public polls;

    // Event for logging
    event PollCreated(uint id, string title, uint endTime);
    event Voted(uint pollId, uint optionIndex);

    // Function to create a poll
    function createPoll(string memory _title, string[] memory _options, uint _durationInSeconds) public {
        require(_options.length >= 2, "Need at least 2 options");

        pollId++;
        Poll storage newPoll = polls[pollId];
        newPoll.title = _title;
        newPoll.options = _options;
        newPoll.endTime = block.timestamp + _durationInSeconds;
        newPoll.exists = true;

        emit PollCreated(pollId, _title, newPoll.endTime);
    }

    // Vote on a poll
    function vote(uint _pollId, uint _optionIndex) public {
        require(polls[_pollId].exists, "Poll doesn't exist");
        Poll storage poll = polls[_pollId];
        require(block.timestamp <= poll.endTime, "Voting ended");
        require(!poll.voters[msg.sender], "You already voted");
        require(_optionIndex < poll.options.length, "Invalid option");

        poll.voters[msg.sender] = true;
        poll.voteCount[_optionIndex]++;

        emit Voted(_pollId, _optionIndex);
    }

    // Get vote count for an option
    function getVotes(uint _pollId, uint _optionIndex) public view returns (uint) {
        return polls[_pollId].voteCount[_optionIndex];
    }

    // Get winner of the poll
    function getWinningOption(uint _pollId) public view returns (string memory) {
        require(polls[_pollId].exists, "Poll doesn't exist");
        require(block.timestamp > polls[_pollId].endTime, "Voting still active");

        Poll storage poll = polls[_pollId];
        uint winningVoteCount = 0;
        uint winningOptionIndex = 0;

        for (uint i = 0; i < poll.options.length; i++) {
            uint votes = poll.voteCount[i];
            if (votes > winningVoteCount) {
                winningVoteCount = votes;
                winningOptionIndex = i;
            }
        }

        return poll.options[winningOptionIndex];
    }

    // Helper: Get poll options
    function getOptions(uint _pollId) public view returns (string[] memory) {
        require(polls[_pollId].exists, "Poll doesn't exist");
        return polls[_pollId].options;
    }
}