const { ethers } = require("hardhat");

async function main() {
    // ===================== 只需要改这里 =====================
    const CONTRACT_ADDRESS = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
    const SEND_ETH = "1"; // 打款 1 ETH
    const DISTRIBUTEARR = ["0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC", "0x90F79bf6EB2c4f870365E785982E1f101E93b906"]
    const DISTRIBUTEAMOUNT = [50, 50]
    // ======================================================

    console.log("正在调用 fund() 打款...");

    // 获取已部署的合约实例
    const funding = await ethers.getContractAt("Funding", CONTRACT_ADDRESS);

    // 调用 fund() 并发送 ETH
    const tx_fund = await funding.fund({
        value: ethers.parseEther(SEND_ETH),
    });

    await tx_fund.wait();

    console.log("✅ fund() 调用成功！");
    console.log("交易哈希:", tx_fund.hash);

    console.log("正在调用 refund() 退款...");
    const tx_refund = await funding.refund();

    await tx_refund.wait();

    console.log("✅ refund() 调用成功！");
    console.log("交易哈希:", tx_refund.hash);

    const tx_fund1 = await funding.fund({
        value: ethers.parseEther(SEND_ETH),
    });

    await tx_fund1.wait();

    console.log("✅ fund() 调用成功！");
    console.log("交易哈希:", tx_fund1.hash);

    const tx_set = await funding.setDistributeList(DISTRIBUTEARR, DISTRIBUTEAMOUNT);

    await tx_set.wait();

    console.log("✅ setDistributeList() 调用成功！");
    console.log("交易哈希:", tx_set.hash);
    console.log("正在调用 distribute() 分配...");

    const tx_distribute = await funding.distribute();

    await tx_distribute.wait();

    console.log("✅ distribute() 调用成功！");
    console.log("交易哈希:", tx_distribute.hash);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });