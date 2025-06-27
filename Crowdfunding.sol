// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Fundraiser {
    uint public fundraiserCount;
    bool private reentrancyLock;

    struct Fundraiser {
        uint id;
        address payable owner;
        string name;
        string purpose;
        uint goal;
        uint deadline;
        uint balance;
        bool withdrawn;
        mapping(address => uint) donors;
    }

    mapping(uint => Fundraiser) public fundraisers;
    mapping(uint => address[]) public donorList;

    event FundraiserCreated(uint id, address indexed owner, uint goal, uint deadline);
    event DonationReceived(uint id, address indexed donor, uint amount);
    event FundsWithdrawn(uint id, address indexed owner);
    event DonationReturned(uint id, address indexed donor, uint amount);

    modifier onlyOwner(uint _id) {
        require(msg.sender == fundraisers[_id].owner, "Only fundraiser owner can call this");
        _;
    }

    modifier isActive(uint _id) {
        require(block.timestamp < fundraisers[_id].deadline, "Fundraiser has ended");
        _;
    }

    modifier noReentrant() {
        require(!reentrancyLock, "Reentrancy not allowed");
        reentrancyLock = true;
        _;
        reentrancyLock = false;
    }

    function createFundraiser(
        string calldata _name,
        string calldata _purpose,
        uint _goal,
        uint _durationDays
    ) external {
        require(_goal > 0, "Goal must be greater than 0");
        require(_durationDays > 0 && _durationDays <= 180, "Duration must be between 1 and 180 days");

        fundraiserCount++;
        uint id = fundraiserCount;

        Fundraiser storage f = fundraisers[id];
        f.id = id;
        f.owner = payable(msg.sender);
        f.name = _name;
        f.purpose = _purpose;
        f.goal = _goal;
        f.deadline = block.timestamp + (_durationDays * 1 days);

        emit FundraiserCreated(id, msg.sender, _goal, f.deadline);
    }

    function donate(uint _id) external payable isActive(_id) {
        require(msg.value > 0, "Donation must be greater than 0");

        Fundraiser storage f = fundraisers[_id];
        if (f.donors[msg.sender] == 0) {
            donorList[_id].push(msg.sender);
        }

        f.donors[msg.sender] += msg.value;
        f.balance += msg.value;

        emit DonationReceived(_id, msg.sender, msg.value);
    }

    function withdraw(uint _id) external onlyOwner(_id) noReentrant {
        Fundraiser storage f = fundraisers[_id];

        require(block.timestamp >= f.deadline, "Cannot withdraw before deadline");
        require(f.balance >= f.goal, "Goal not reached");
        require(!f.withdrawn, "Funds already withdrawn");

        f.withdrawn = true;
        uint amount = f.balance;
        (bool success, ) = f.owner.call{value: amount}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(_id, msg.sender);
    }

    function refund(uint _id) external noReentrant {
        Fundraiser storage f = fundraisers[_id];

        require(block.timestamp >= f.deadline, "Fundraiser still ongoing");
        require(f.balance < f.goal, "Goal was met, cannot refund");

        uint donation = f.donors[msg.sender];
        require(donation > 0, "No donation found");

        f.donors[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: donation}("");
        require(success, "Refund failed");

        emit DonationReturned(_id, msg.sender, donation);
    }

    function viewMyDonation(uint _id, address _donor) external view returns (uint) {
        return fundraisers[_id].donors[_donor];
    }

    function getDonors(uint _id) external view returns (address[] memory) {
        return donorList[_id];
    }
}
