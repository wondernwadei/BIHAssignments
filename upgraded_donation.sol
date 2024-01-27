// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Charity {

    uint256 immutable target;
    uint256 public currentDonations;
    uint256 public deadline;
    address public charity;

    event donationMade(address indexed donor, uint amount);

     struct Donation {
        address donor;
        uint amount;
    }

     mapping(address => Donation) donations;

    constructor(uint256 target_, uint256 deadline_) {
        require(deadline_ > block.timestamp, "the timestamp is in the past");
        require(deadline_ < block.timestamp + 15 days, "the timestamp is the above 15 days limit");
        require(target_ >= 1 ether, "you can not set a target below 1 ether");

        charity = msg.sender;
        target = target_;
        deadline = deadline_;
        currentDonations = 0;
    }

    function makeDonation() public payable {
        require(msg.value > 0, "Donation amount must be greater than zero.");
        require(currentDonations < target || block.timestamp <= deadline, "target reached, thank you!");
        Donation memory donation = Donation(msg.sender, msg.value); 
        donations[msg.sender] = donation;
        currentDonations += msg.value;

        emit donationMade(msg.sender, msg.value);
    }

    function getDonation(address _donor) public view returns (uint) {
        Donation memory donation = donations[_donor];
        return (donation.amount); 
    }

    function withdraw() external {
        require(msg.sender == charity, "you are not the owner");
        require(currentDonations >= target || block.timestamp >= deadline, "target nor deadline met");

        uint balance = address(this).balance;
        payable(charity).transfer(balance);
    }
}