# On-Chain Crowdfunding Platform

## Overview

This is a decentralized crowdfunding platform built as part of the Seasons of Code program. It allows users to create and contribute to fundraising campaigns directly on the Ethereum blockchain using smart contracts.

## Features

- Create fundraising campaigns
- Contribute Ether to active campaigns
- Campaign creators can withdraw funds after successful completion
- Deadline and goal tracking

## What I Learned

- **Basics of Blockchain and Decentralized Ledgers**  
  I learned how blockchains store data across a distributed network, making the system transparent, tamper-proof, and independent of central control.

- **Cryptography in Blockchain**  
  I explored how hashing ensures data integrity, digital signatures verify user identities, and key-pair encryption enables secure transactions between users.

- **Decentralized Applications (dApps)**  
  I understood how dApps run on peer-to-peer networks like Ethereum. They are transparent, censorship-resistant, and operate using smart contracts instead of a central server.

- **Smart Contracts and Solidity**  
  I gained hands-on experience writing smart contracts in Solidity. These contracts define the rules and logic of the crowdfunding platform and are executed automatically on the blockchain.

- **Core Solidity Concepts**:
  
  - **State Variables, Structs, and Mappings**  
    I used state variables to store campaign data, structs to define the structure of a campaign, and mappings to track contributors and their donations efficiently.
  
  - **Constructors and Modifiers**  
    Constructors were used to initialize campaign data at the time of contract deployment. Modifiers helped enforce access control, such as restricting fund withdrawals to only the campaign creator.

  - **Payable Functions**  
    These functions allowed the contract to receive Ether. They made it possible for users to contribute funds to campaigns securely.

  - **Global Variables**  
    - `msg.sender`: Identifies the address calling the function (used to track contributors and creators).  
    - `msg.value`: Represents the amount of Ether sent with a transaction (used to validate contributions).  
    - `block.timestamp`: Returns the current block time (used to handle campaign deadlines and expiration logic).

## Tech Stack

- Solidity
- Ethereum
- Remix IDE

## Future Improvements

- Add a frontend interface using Web3.js or Ethers.js
- Improve campaign discovery and UI
- Add verification for campaign legitimacy
