// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Charity{

    enum DonationStatus {
        pending,
        acknowledged
    }

    struct Donation {
        uint amount;
        DonationStatus status;
    }

    mapping(address => Donation) public donations;
    address public charity;
    uint public totalDonations;

    event DonationMade(address indexed donor, uint amount);
    event DonationAcknowledged(address indexed donor);

    constructor() {
        charity = msg.sender;
        totalDonations = 0;
    }

    function makeDonation() public payable {
        require(msg.value > 0, "Donation amount must be greater than zero.");

        Donation storage donation = donations[msg.sender];
        donation.amount += msg.value;
        donation.status = DonationStatus.pending;

        totalDonations += msg.value;

        emit DonationMade(msg.sender, msg.value);
    }

    function acknowledgeDonation(address _donor) public {
        require(msg.sender == charity, "Only the charity can acknowledge donations");

        Donation storage donation = donations[_donor];
        require(donation.status == DonationStatus.pending, "Donation has already been acknowledged");

        donation.status = DonationStatus.acknowledged;

        emit DonationAcknowledged(_donor);
    }

    function getDonationStatus(address _donor) public view returns(DonationStatus) {
        return donations[_donor].status;
    }
}