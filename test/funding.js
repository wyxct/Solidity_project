const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("Funding 测试", function () {
    let funding;
    let owner, user1, user2;

    // 部署合约
    beforeEach(async function () {
        // 获取测试账户
        [owner, user1, user2] = await ethers.getSigners();

        // 部署 UUPS 代理合约
        const Funding = await ethers.getContractFactory("Funding");
        funding = await upgrades.deployProxy(Funding, []);
        await funding.deployed();
    });

    // 测试 1：部署成功
    it("合约部署成功", async function () {
        expect(funding.address).to.properAddress;
    });

    // 测试 2：调用 fund() 打款 0.1 ETH
    it("用户可以调用 fund() 打款，并触发 Funded 事件", async function () {
        // 打款金额：0.1 ETH
        const amount = ethers.utils.parseEther("0.1");

        // 调用 fund()
        const tx = await funding.connect(user1).fund({ value: amount });
        const receipt = await tx.wait();

        // 验证事件
        const event = receipt.events.find((e) => e.event === "Funded");
        expect(event.args.sender).to.equal(user1.address);
        expect(event.args.amount).to.equal(amount);

        console.log("✅ 测试通过：成功调用 fund()，事件已触发");
    });

    // 测试 3：不能发送 0 ETH
    it("不能发送 0 ETH", async function () {
        await expect(
            funding.connect(user2).fund({ value: 0 })
        ).to.be.revertedWith("No ETH sent");

        console.log("✅ 测试通过：0 ETH 被拒绝");
    });
});