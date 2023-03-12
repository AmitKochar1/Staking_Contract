const { assert } = require("chai");
const{ deployments, ethers, getNamedAccounts, network} = require("hardhat");

describe("AaveToken", () => {
    let deployer, aaveToken, userOne, userTwo;
    beforeEach(async function() {
        deployer = (await getNamedAccounts()).deployer;
        userOne = (await getNamedAccounts()).userOne;
        userTwo = (await getNamedAccounts()).userTwo;
        await deployments.fixture("all");
        aaveToken = await ethers.getContract("AaveToken", deployer);

    })

    describe("Constructor", () => {
        it("check constructor values", async function(){
            const initialSupply = await aaveToken.totalSupply();
            //console.log(`total supply: ${initialSupply}`)
            assert.equal(initialSupply.toString(), 10000);
            const name = await aaveToken.name();
            const symbol = await aaveToken.symbol();
            assert.equal(name, "AaveToken");
            assert.equal(symbol, "AT");
        })
    })

    describe("Functionality of ERC20 token", () =>{
        let amount, amountToTranfer;

        it("mint function", async function(){
            amount = 50000;
            await aaveToken.mint( userOne ,amount);
            const totalSupply = await aaveToken.totalSupply();
            assert.equal(totalSupply.toString(), 60000);
            //console.log(`total supply ${totalSupply}`);
        })

        it("Transfer function", async function() {
            amountToTranfer = 2000;
            deployerBalanceBefore = await aaveToken.balanceOf(deployer);
            userOneBalanceBefore = await aaveToken.balanceOf(userOne);
            userTwoBalanceBefore = await aaveToken.balanceOf(userTwo);

            // console.log(`deployer balance before ${deployerBalanceBefore}`);
            // console.log(`userOne balance before ${userOneBalanceBefore}`);
            // console.log(`userTwo balance before ${userTwoBalanceBefore}`);
            
            await aaveToken.transfer(userOne, amountToTranfer);
            await aaveToken.transfer(userTwo, amountToTranfer);
            
            deployerBalanceAfter  = await aaveToken.balanceOf(deployer);
            userOneBalanceAfter = await aaveToken.balanceOf(userOne);
            userTwoBalanceAfter = await aaveToken.balanceOf(userTwo);

            // console.log(`deployer balance after ${deployerBalanceAfter}`);
            // console.log(`userOne balance after ${userOneBalanceAfter}`);
            // console.log(`userTwo balance after ${userTwoBalanceAfter}`);
        })

        it("Approve function", async function(){
            //transfer
            amountToTranfer = 2000; 
            await aaveToken.transfer(userOne, amountToTranfer);
            await aaveToken.transfer(userTwo, amountToTranfer);

            //Allowance
            let amt, amountToSpend;
            amountToSpend = 1000;
            await aaveToken.approve(userOne, amountToSpend);
            amountToSpend = 500;
            await aaveToken.approve(userTwo, amountToSpend);
            amt = await aaveToken.allowance(deployer, userOne);
            console.log(`deployer allows UserOne to allowance of: ${amt}`);
            amt = await aaveToken.allowance(deployer, userTwo);
            assert.equal(amt.toString(), amountToSpend);
            console.log(`deployer allows UserTwo to allowance of: ${amt}`);

        })

    })
        
})