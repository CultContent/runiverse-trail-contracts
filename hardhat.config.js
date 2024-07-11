require("dotenv").config();
require("@nomiclabs/hardhat-ethers"); // Ensure this is the correct package
require('@nomicfoundation/hardhat-toolbox')
const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.24",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    // sepolia: {
    //   url: API_URL,
    //   accounts: [`0x${PRIVATE_KEY}`],
    // },
  },
};