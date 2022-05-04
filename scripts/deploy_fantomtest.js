const { BigNumber } = require("ethers");
const hre = require("hardhat");

async function main() {
  const MagicSquares = await hre.ethers.getContractFactory("MagicSquares");
  const magicSquares = await MagicSquares.deploy(
    "0x14dc79964da2c08b23698b3d3cc7ca32193d9955",
    0,
    BigNumber.from("100")
  );

  await magicSquares.deployed();

  console.log(
    "Fantom testnet ----- magicSquares deployed to:",
    magicSquares.address
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});