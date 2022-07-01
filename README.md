# MultiParty Wallet Smart Contract
## Description
This smart contract can be described as a donation wallet contract that accepts ETH from any address, but as a multi-party can only allow withdrawals based on approval of the contract owners which can be assigned by the admin(the contract deployer and also owner).

#### How It Works
Admin #12 creates a withdrawal proposal with a specific withdrawal amount. The admins votes either YAY or NAY on the proposal within the time limit of 10 minutes. After 10 minutes, admin #12 can execute the proposal and get ETH transferred to his address IF there is a larger number of YAY votes.
