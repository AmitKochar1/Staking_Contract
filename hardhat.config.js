require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require('hardhat-deploy');

/** @import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity:{ compilers: [{version: "0.8.18"}, {version: "0.8.0"}]},
  defaultNetwork: "hardhat",

  namedAccounts: {
    deployer:{
      default: 0, //local chain 
    },
    userOne: 1,
    userTwo: 2,
  },

};
