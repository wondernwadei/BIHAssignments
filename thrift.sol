// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MonthlyContribution {
    address[] public participants;
    uint256 public currentReceiverIndex;
    uint256 public totalContributions;

    // Mapping to track contributions of each participant
    mapping(address => uint256) public contributions;

    // Modifier to ensure only registered participants can contribute
    modifier onlyParticipants() {
        require(isParticipant(msg.sender), "You are not a registered participant");
        _;
    }

    // Modifier to ensure only the contract owner can perform certain actions
    modifier onlyOwner() {
        require(msg.sender == participants[0], "Only the contract owner can perform this action");
        _;
    }

    // Event to log contributions
    event Contribution(address indexed contributor, uint256 amount);

    // Event to log distribution to a participant
    event Distribution(address indexed receiver, uint256 amount);

    constructor(address[] memory _participants) {
        require(_participants.length == 4, "There must be exactly 4 participants");
        
        // Assign participants and initialize currentReceiverIndex
        participants = _participants;
        currentReceiverIndex = 0;
    }

    // Function to check if an address is a participant
    function isParticipant(address _address) public view returns (bool) {
        for (uint256 i = 0; i < participants.length; i++) {
            if (participants[i] == _address) {
                return true;
            }
        }
        return false;
    }

    // Function to contribute 1 ether
    function contribute() external payable onlyParticipants {
        require(msg.value == 1 ether, "Contribution must be exactly 1 ether");

        // Update the contribution balance for the participant
        contributions[msg.sender] += msg.value;

        // Update the total contributions
        totalContributions += msg.value;

        // Emit Contribution event
        emit Contribution(msg.sender, msg.value);

        // Check if it's time to distribute funds
        if (totalContributions >= 4 ether) {
            distributeFunds();
        }
    }

    // Function to distribute funds to the current receiver
    function distributeFunds() internal {
        require(totalContributions >= 4 ether, "Not enough funds to distribute");

        // Calculate the amount to distribute to the current receiver
        uint256 amountToDistribute = totalContributions / 4;

        // Transfer funds to the current receiver
        payable(participants[currentReceiverIndex]).transfer(amountToDistribute);

        // Reset total contributions
        totalContributions = 0;

        // Emit Distribution event
        emit Distribution(participants[currentReceiverIndex], amountToDistribute);

        // Move to the next receiver
        currentReceiverIndex = (currentReceiverIndex + 1) % 4;
    }

    // Function to get the current receiver
    function getCurrentReceiver() external view returns (address) {
        return participants[currentReceiverIndex];
    }

    // Function to withdraw remaining funds (only owner)
    function withdrawRemainingFunds() external onlyOwner {
        require(totalContributions > 0, "No remaining funds to withdraw");
        payable(participants[0]).transfer(totalContributions);
        totalContributions = 0;
    }

    // Fallback function to receive ether
    receive() external payable {
    }
}
