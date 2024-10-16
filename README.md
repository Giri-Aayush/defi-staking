# DeFi Staking Project
This project demonstrates a basic DeFi staking mechanism using Solidity smart contracts. It includes a custom ERC20 token (DEFI) and a staking contract that allows users to stake their DEFI tokens and earn rewards.

## Contracts
### DEFI Token (DEFI.sol)
A simple ERC20 token contract for the DEFI token used in staking.
- Token Name: DEFI
- Token Symbol: DEFI
- Implements: ERC20 (OpenZeppelin)

### Staking Contract (Staking.sol)
A staking contract that allows users to stake DEFI tokens and earn rewards.

Features:
- Stake DEFI tokens
- Withdraw staked tokens and rewards
- View accumulated rewards
- Claim rewards without withdrawing stake
- Reentrancy protection

## Getting Started
1. Clone this repository
2. Install dependencies:
```npm install```
3. Compile contracts:
```npx hardhat compile```
4. Deploy contracts (adjust the script as needed):
```npx hardhat run scripts/deploy.js --network <your-network>```

## Usage
1. Deploy the DEFI token contract
2. Deploy the Staking contract, passing the DEFI token address and reward rate as constructor arguments
3. Users can then interact with the Staking contract to stake tokens, withdraw, and claim rewards

## Security
This project uses OpenZeppelin's contracts for enhanced security. However, it has not been audited and should not be used in production without proper review and testing.

## License
This project is licensed under the MIT License.
