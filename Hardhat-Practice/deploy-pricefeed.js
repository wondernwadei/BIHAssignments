const hre = require("hardhat");

const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const contract = require("../artifacts/contracts/PriceFeed.sol/PriceConsumer.json");

const web3Provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();


async function main() {
  
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Token = await ethers.getContractFactory("PriceConsumer");
  const token = await Token.deploy();

  console.log("Token address:", token.address);
 
  let price = await token.getETHUSD();
  console.log(`Eth price is: ${price}`);
}

main();


olloha
