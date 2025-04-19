//SPDX-License-Identifier: free

pragma solidity ^0.8.7;


contract Campaign {
    address payable public creator;
    string public title;
    uint256 public goal;
    uint256 public deadline; // Unix timestamp for when campaign ends
    
    constructor(
        string memory _title, // "Help Crowdfund First O'Neill Cylinder (!! double 'l')"
        uint256 _goal,
        uint256 _durationInDays
    ) {
        creator = payable(msg.sender); // Sets creator as the address deploying the contract
        title = _title;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days); // Current time + duration
   
    }
}
