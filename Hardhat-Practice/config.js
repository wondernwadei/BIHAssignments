// used this in hardhat for both the callee deployment and the caller deployment
require('dotenv').config();
require("@nomicfoundation/hardhat-toolbox");

const { API_URL, PRIVATE_KEY } = process.env;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

module.exports = {
  solidity: "0.8.0",
  defaultNetwork: "arbitrumSepolia",
  networks: {
      hardhat: {},
      arbitrumSepolia: {
         url: API_URL,
         chainId: 421614,
         accounts: [`0x${PRIVATE_KEY}`]
      }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: ETHERSCAN_API_KEY
  },
  sourcify: {
    enabled: true
  }
};



