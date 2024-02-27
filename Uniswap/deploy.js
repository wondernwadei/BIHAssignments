const { ethers } = require("hardhat");

async function main() {
  // Replace these addresses with your actual ones
  const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
  const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
  
  // Deploying SimpleSwap contract
  const SimpleSwap = await ethers.getContractFactory("SimpleSwap");
  const swapRouterAddress = "0xe592427a0aece92de3edee1f18e0157c05861564"; 
  const simpleSwap = await SimpleSwap.deploy(swapRouterAddress);
  await simpleSwap.deployed();
  
  console.log("SimpleSwap deployed to:", simpleSwap.address);

  // Example of interacting with the contract
  const amountIn = ethers.utils.parseEther("1"); // Example: 1 WETH
  const swapTx = await simpleSwap.swapWETHForDAI(amountIn);
  await swapTx.wait();

  console.log("Swap executed successfully!");
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

