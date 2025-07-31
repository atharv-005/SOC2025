// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Crowdfund {
    uint public campaignCount;
    bool private reentrancyLock;

    struct Campaign {
        uint id;
        address payable owner;
        string title;
        string description;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool withdrawn;
    }

    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) public contributions;
    mapping(uint => address[]) public contributors;

    // Events
    event CampaignCreated(uint indexed id, address indexed owner, uint goal, uint deadline);
    event ContributionReceived(uint indexed id, address indexed contributor, uint amount);
    event FundsWithdrawn(uint indexed id, uint amount);
    event RefundIssued(uint indexed id, address indexed contributor, uint amount);

    // Modifiers
    modifier onlyOwner(uint _id) {
        require(msg.sender == campaigns[_id].owner, "Only campaign owner");
        _;
    }

    modifier noReentrant() {
        require(!reentrancyLock, "Reentrancy not allowed");
        reentrancyLock = true;
        _;
        reentrancyLock = false;
    }

    modifier campaignExists(uint _id) {
        require(_id > 0 && _id <= campaignCount, "Campaign does not exist");
        _;
    }

    modifier beforeDeadline(uint _id) {
        require(block.timestamp < campaigns[_id].deadline, "Deadline passed");
        _;
    }

    modifier afterDeadline(uint _id) {
        require(block.timestamp >= campaigns[_id].deadline, "Campaign still active");
        _;
    }

    // Week 2: Campaign Creation
    function createCampaign(
        string calldata _title,
        string calldata _description,
        uint _goal,
        uint _durationDays
    ) external {
        require(_goal > 0, "Goal must be > 0");
        require(_durationDays > 0 && _durationDays <= 90, "Duration must be 190 days");

        campaignCount++;
        uint id = campaignCount;

        campaigns[id] = Campaign({
            id: id,
            owner: payable(msg.sender),
            title: _title,
            description: _description,
            goal: _goal,
            deadline: block.timestamp + (_durationDays * 1 days),
            amountRaised: 0,
            withdrawn: false
        });

        emit CampaignCreated(id, msg.sender, _goal, campaigns[id].deadline);
    }

    // Week 3: Contributions
    function contribute(uint _id) external payable campaignExists(_id) beforeDeadline(_id) {
        require(msg.value > 0, "Contribution must be > 0");

        Campaign storage c = campaigns[_id];

        if (contributions[_id][msg.sender] == 0) {
            contributors[_id].push(msg.sender);
        }

        contributions[_id][msg.sender] += msg.value;
        c.amountRaised += msg.value;

        emit ContributionReceived(_id, msg.sender, msg.value);
    }

    // Week 4: Withdrawal Logic
    function withdrawFunds(uint _id) external onlyOwner(_id) afterDeadline(_id) noReentrant {
        Campaign storage c = campaigns[_id];

        require(!c.withdrawn, "Already withdrawn");
        require(c.amountRaised >= c.goal, "Goal not reached");

        c.withdrawn = true;
        uint amount = c.amountRaised;

        (bool sent, ) = c.owner.call{value: amount}("");
        require(sent, "Transfer failed");

        emit FundsWithdrawn(_id, amount);
    }

    // Week 4: Refund Logic
    function requestRefund(uint _id) external afterDeadline(_id) noReentrant campaignExists(_id) {
        Campaign storage c = campaigns[_id];
        require(c.amountRaised < c.goal, "Goal met, refund not allowed");

        uint donated = contributions[_id][msg.sender];
        require(donated > 0, "No contribution to refund");

        contributions[_id][msg.sender] = 0;

        (bool refunded, ) = msg.sender.call{value: donated}("");
        require(refunded, "Refund failed");

        emit RefundIssued(_id, msg.sender, donated);
    }

    // Week 6: View Helpers
    function getCampaign(uint _id) external view campaignExists(_id) returns (
        uint id,
        address owner,
        string memory title,
        string memory description,
        uint goal,
        uint deadline,
        uint amountRaised,
        bool withdrawn
    ) {
        Campaign storage c = campaigns[_id];
        return (
            c.id,
            c.owner,
            c.title,
            c.description,
            c.goal,
            c.deadline,
            c.amountRaised,
            c.withdrawn
        );
    }

    function getContributors(uint _id) external view returns (address[] memory) {
        return contributors[_id];
    }

    function getMyContribution(uint _id, address _addr) external view returns (uint) {
        return contributions[_id][_addr];
    }
}
