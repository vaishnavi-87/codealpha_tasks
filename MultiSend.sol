// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSend {
    
    // Function to receive Ether and distribute it
    function multiSend(address[] calldata recipients) external payable {
        // Total Ether sent must be greater than 0
        require(msg.value > 0, "Send some ETH");

        uint totalRecipients = recipients.length;
        require(totalRecipients > 0, "Recipient list is empty");

        // Amount to send to each address
        uint amountPerRecipient = msg.value / totalRecipients;

        // Loop through the array and send Ether
        for (uint i = 0; i < totalRecipients; i++) {
            // Ensure address is valid and send the amount
            (bool sent, ) = payable(recipients[i]).call{value: amountPerRecipient}("");
            require(sent, "Transfer failed");
        }
    }
}