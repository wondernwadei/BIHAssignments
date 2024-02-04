// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/* This contract is intentionally made susceptible to a potential reentrancy vulnerability. In the
"send" function, the balance updates occur after the external call to
"IERC20Permit (token) -transferFrom(sender, receiver, amount)". If the
'transferFrom' operation involves an external contract, that contract might
 execute malicious code and call back into the 'GaslessTokenTransfer' contract before the balance updates are completed.
 Transfer logic is implemented before deducting users balance*/


interface IERC20Permit {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external; // returns (uint256);
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);    
}

contract GaslessTokenTransfer {
    mapping(address => uint256) private _userBalances;

    function getUserBalance(address user) external view returns (uint256) {
        return _userBalances[user];
    }

    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount, 
        uint fee, 
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        IERC20Permit(token).permit(
            sender,
            address(this),
            amount + fee,
            deadline,
            v, r, s
        );

        // Perform the actual token transfer
        IERC20Permit(token).transferFrom(sender, receiver, amount);

        // Update sender's balance
        require(_userBalances[sender] >= amount + fee, "Insufficient balance");
        _userBalances[sender] -= amount + fee;

        // Update receiver's balance
        _userBalances[receiver] += amount;

        // Transfer fee to msg.sender 
        _userBalances[msg.sender] += fee;
    }
}
