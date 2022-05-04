const { BigNumber } = require("ethers");
const hre = require("hardhat");

async function main() {
  const MagicSquares = await hre.ethers.getContractFactory("MagicSquares");
  const magicSquares = await MagicSquares.deploy(
    "0x6Fcb97553D41516Cb228ac03FdC8B9a0a9df04A1",
    100,
    200
  );

  await magicSquares.deployed();

  console.log("Bsctest ----- MagicSquares deployed to:", magicSquares.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});