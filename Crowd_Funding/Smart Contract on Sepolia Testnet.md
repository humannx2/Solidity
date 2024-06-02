**The smart contract is deployed on the Sepolia testnet. You can interact with it using the following contract address:** 
"0xda157fc3b31152f296ccffdddfd7f60aae659c12"

  
### How to Interact
1. **Metamask**:
   - Add the Sepolia testnet to your Metamask wallet.
   - Use the contract address above to interact with the contract via Metamask.

2. **Using Remix**:
   - Open [Remix](https://remix.ethereum.org/).
   - Connect to the Sepolia testnet.
   - Load the contract ABI and the contract address to start interacting.

3. **Using Web3**:
   - Use Web3.js or Web3.py to interact with the contract programmatically. Here is a basic example using Web3.js:
   
   ```javascript
   const Web3 = require('web3');
   const web3 = new Web3('https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID');

   const contractAddress = 'ContractAddressMentionedAbove';
   const contractABI = [copy 'crowd_fund.json' file contents];

   const contract = new web3.eth.Contract(contractABI, contractAddress);

   // Example: Calling a read-only function
   contract.methods.yourReadFunction().call()
     .then(console.log)
     .catch(console.error);


