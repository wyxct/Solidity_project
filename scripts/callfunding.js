const { ethers } = require("hardhat");

async function main() {
    // ===================== 只需要改这里 =====================
    const CONTRACT_ADDRESS = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
    const SEND_ETH = "0.01"; // 打款 0.01 ETH
    // ======================================================

    console.log("正在调用 fund() 打款...");

    // 获取已部署的合约实例
    const funding = await ethers.getContractAt("Funding", CONTRACT_ADDRESS);

    // 调用 fund() 并发送 ETH
    const tx = await funding.fund({
        value: ethers.parseEther(SEND_ETH),
    });

    await tx.wait();

    console.log("✅ fund() 调用成功！");
    console.log("交易哈希:", tx.hash);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });