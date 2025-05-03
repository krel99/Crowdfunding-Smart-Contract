//SPDX-License-Identifier: free

pragma solidity ^0.8.7;


contract Campaign {
    address payable public creator;
    string public title;
    uint256 public goal;
    uint256 public deadline; // Unix timestamp for when campaign ends
    uint256 public totalRaised; // Total amount of funds raised for this campaign
    mapping(address => uint256) public contributions;

    event ContributionReceived(address contributor, uint256 amount);
    
    constructor(
        string memory _title, // "Help Crowdfund First O'Neill Cylinder (!! double 'l')"
        uint256 _goal,
        uint256 _durationInDays
    ) {

        require(_goal > 0, "Goal must be greater than zero");
        require(_durationInDays >= 1, "Campaign must run for at least 1 day");


        creator = payable(msg.sender); // Sets creator as the address deploying the contract
        title = _title;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days); // Current time + duration
        totalRaised = 0;
   
    }

    function contribute() public payable {
        require(!campaignActive(), "Campaign not active");
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
        emit ContributionReceived(msg.sender, msg.value);
    }

    function claimFunds() public {
        require(msg.sender == creator, "Only creator can claim");
        require(block.timestamp > deadline, "Campaign not ended");
        require(goalReached(), "Goal not reached");
        require(address(this).balance > 0, "No funds to claim");
        
        uint256 amount = address(this).balance;
        (bool success, ) = creator.call{value: amount}("");
        require(success, "Transfer failed");
    }

    function getRefund() public {
        require(block.timestamp > deadline, "Campaign not ended");
        require(!goalReached(), "Goal was reached");
        require(contributions[msg.sender] > 0, "No contribution found");
        
        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");
    }

    function goalReached() public view returns (bool) {
        return totalRaised >= goal;
    }

    function campaignActive() public view returns (bool) {
        return block.timestamp <= deadline;
    } 
}

