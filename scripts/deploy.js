const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  // URL from where we can extract the metadata for a TAW
  const metadataURL = "ipfs://Qmbygo38DWF1V8GttM1zy89KzyZTPU2FLUzQtiDvB7q6i5/";
  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so lw3PunksContract here is a factory for instances of our TAW contract.
  */
  const collectionContract = await ethers.getContractFactory("Collection");

  // deploy the contract
  const deployedcollectionContract = await collectionContract.deploy(metadataURL);

  await deployedcollectionContract.deployed();

  // print the address of the deployed contract
  console.log("TAW Contract Address:", deployedcollectionContract.address);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

