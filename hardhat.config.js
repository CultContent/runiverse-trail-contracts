/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  compilers: [
    {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
  ]
};
