require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const ROPSTEN_URL = 'https://eth-ropsten.alchemyapi.io/v2/xxx'
const BSCTEST_URL = 'https://speedy-nodes-nyc.moralis.io/xxx/bsc/testnet'
const MUMBAI_URL = 'https://polygon-mumbai.g.alchemy.com/v2/xxx'
const FUJI_URL = 'https://speedy-nodes-nyc.moralis.io/xxx/avalanche/testnet'
const FANTOMTEST_URL = 'https://speedy-nodes-nyc.moralis.io/xxx/fantom/testnet'
const ARBTEST_URL = 'https://speedy-nodes-nyc.moralis.io/xxx/arbitrum/testnet'
const OPTTEST_URL = 'https://opt-kovan.g.alchemy.com/v2/Q-xxx'
const PRIVATE_KEY = 'xxx'
const ETHERSCAN_API_KEY = "xxx"

module.exports = {
  solidity: "0.8.7",
  networks: {
    hardhat: {},
    ropsten: {
      url: ROPSTEN_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    bsctest: {
      url: BSCTEST_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    mumbai: {
      url: MUMBAI_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    fuji: {
      url: FUJI_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    fantomtest: {
      gasPrice: 350000000000,
      saveDeployments: true,
      url: FANTOMTEST_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    arbtest: {
      url: ARBTEST_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    opttest: {
      url: OPTTEST_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};