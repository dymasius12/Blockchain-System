// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CrowdSale {
    ERC20 public token;
    address payable public wallet;
    uint256 public amountRaised;

    constructor(ERC20 _token) {
        wallet = payable(msg.sender);
        token = _token;
    }

    function buyTokens() public payable {
        uint256 numTokens = msg.value / 1 ether;
        amountRaised += msg.value;

        // Transfer tokens from the wallet to the buyer
        token.transferFrom(wallet, msg.sender, numTokens);

        // Transfer Ether to the wallet
        wallet.transfer(msg.value);
    }
}
