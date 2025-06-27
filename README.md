# SOC2025
.

🧱 On-Chain Crowdfunding Platform
📌 Overview
As part of the Seasons of Code program, I built an on-chain crowdfunding platform — a decentralized application (dApp) that allows users to create and contribute to fundraising campaigns using blockchain technology. This project gave me a hands-on introduction to Web3 and helped me grow as a developer through smart contract development and decentralized systems design.

🧠 What I Learned
🔗 Fundamentals of Blockchain
I started by understanding how blockchain works as a decentralized and tamper-proof ledger. I explored concepts like blocks, consensus mechanisms, and the role of distributed nodes in ensuring trust without central authority.

🔐 Cryptography in Blockchain
Key cryptographic principles — such as hashing, digital signatures, and key-pair encryption — played a vital role in my understanding of how data is secured and verified on-chain.

🌐 Decentralized Applications (dApps)
I learned how dApps function on peer-to-peer networks like Ethereum. Unlike traditional apps, dApps are resistant to censorship, transparent by default, and operate using smart contracts deployed on the blockchain.

⚙ Solidity and Smart Contracts
I gained practical experience with Solidity, the programming language used to write smart contracts. Here are a few core concepts I applied in my project:

State Variables & Data Types
Used to store campaign details, track contributions, and maintain platform state (e.g., uint, address, mapping, struct).

Constructors
Used to initialize contracts at the time of deployment.

Modifiers
Helped enforce rules like “only the campaign creator can withdraw funds” by using access control checks.

Structs and Mappings
Defined campaign logic and tracked each contributor’s donation using nested mappings for efficient storage and lookups.

Payable Functions
Enabled the contract to receive Ether, allowing users to fund campaigns directly.

Visibility Specifiers
Understood how to restrict access to internal logic (private, internal, public, external) based on usage needs.

🛠 Global Variables I Used
msg.sender: The address calling the function — useful for identifying campaign creators and contributors.

msg.value: The amount of Ether sent with a transaction — critical for contribution logic.

block.timestamp: Used to manage campaign deadlines and ensure time-based conditions.
