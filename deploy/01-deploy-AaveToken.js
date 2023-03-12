const {network, getNamedAccounts} = require("hardhat");
//const{networkConfig, developmentChains} = require("../helper-hardhat-config");

module.exports = async ({deployments, getNamedAccounts}) => {
    const{deploy, log} = deployments;
    const{deployer} = await getNamedAccounts();
    const args = [10000];

    const aaveToken = await deploy("AaveToken", {
        from: deployer,
        args: args,
        log: true,
    })

    log(`Aave token was deployed at ${aaveToken.address}`);
    log(`-------------------------`);

}

module.exports.tags = ["AaveToken", "all"];