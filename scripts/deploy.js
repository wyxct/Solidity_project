const { ethers, upgrades } = require("hardhat");

async function main() {
    const Funding = await ethers.getContractFactory("Funding");
    const proxy = await upgrades.deployProxy(Funding, []);

    console.log("代理合约地址:", await proxy.getAddress());
    console.log("请复制这个地址给Go程序使用！");
}

main();