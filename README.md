# Smart Contract Examples

This repository contains Solidity smart contracts that demonstrate vulnerabilities and attacks, specifically underflow attacks and reentrancy attacks, alongside their explanations and usage. These examples are intended for educational purposes only, to help developers understand common smart contract vulnerabilities and how to mitigate them.

## Contents

1. Contracts:
   - `underflow.sol`: Demonstrates an underflow attack where an attacker exploits arithmetic underflow to drain funds from a vulnerable smart contract.
   - `denial.sol`: Demonstrates a reentrancy attack where an attacker repeatedly calls a vulnerable contract's function to drain its funds before its state is updated.

2. Key Concepts:
   - Underflow Attack: Occurs when a subtraction operation wraps around due to insufficient checks, causing large unintended balances.
   - Reentrancy Attack: Happens when a malicious contract calls back into the vulnerable contract before it finishes execution, exploiting the sequence of operations.

## Getting Started

### Requirements
- Solidity Compiler: Version `0.8.x` (preferably `^0.8.26` for full compatibility).
- Remix IDE: [https://remix.ethereum.org](https://remix.ethereum.org).
- Hardhat (optional): For local development and testing.

### Deployment and Testing

1. Deploying `underflow.sol`:
   - Open `underflow.sol` in Remix or your preferred Solidity IDE.
   - Deploy the `babyDAO` contract.
   - Fund the `babyDAO` contract with Ether (e.g., 10 ETH).
   - Deploy the `attacker` contract, passing the `babyDAO` contract's address to its constructor.
   - Call the `attack()` function in the `attacker` contract to execute the underflow attack.

2. Deploying `denial.sol`:
   - Open `denial.sol` in Remix or your preferred Solidity IDE.
   - Deploy the `Victim` contract.
   - Fund the `Victim` contract with Ether (e.g., 10 ETH).
   - Deploy the `Attacker` contract, passing the `Victim` contract's address to its constructor.
   - Call the `attack()` function in the `Attacker` contract to execute the reentrancy attack.

## Key Vulnerabilities and Mitigations

1. Underflow Vulnerability:
   - Issue: Arithmetic operations without validation can result in an underflow, where values wrap around to very large numbers.
   - Mitigation: Use Solidity 0.8+, which includes built-in arithmetic checks. Use SafeMath for older versions of Solidity.

2. Reentrancy Vulnerability:
   - Issue: Calling an external contract before updating the internal state allows attackers to re-enter the function and drain funds.
   - Mitigation: Update the contract’s state before transferring Ether. Use a reentrancy guard, such as OpenZeppelin's `ReentrancyGuard`.

## Example Code Snippets

Underflow in `babyDAO`:
```solidity
if (credit[msg.sender] == 0) {
    credit[msg.sender] = 999; // Causes underflow, giving the attacker a huge balance
} else {
    credit[msg.sender] -= amount;
}
```

Reentrancy in `Victim`:
```solidity
(bool sent, bytes memory data) = payable(msg.sender).call{value: owedToAttacker * 10**18}("Completed!");
owedToAttacker = 0; // State is updated *after* sending Ether
```
