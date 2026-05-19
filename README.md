FundingMonitor 众筹监控系统 ⚠️当前仓库只有Solidity部分，Go部分的代码详见仓库：https://github.com/wyxct/FundingMonitor
基于 Solidity + Hardhat 构建的去中心化众筹项目，支持资金筹集、退款、分账，并配套链上事件监控服务，可实时统计用户捐款排行榜。

✨ 项目亮点
安全可靠：使用 UUPS 可升级模式，结合 ReentrancyGuard 防重入，避免资金风险

状态可控：众筹过程分为 Active/Success 状态，防止分账后再退款

资金保护：支持全额退款、按比例分账，所有操作都有数学溢出保护

链上可追溯：关键操作（捐款 / 退款 / 分账）都触发事件，可通过监控服务写入数据库

数据可视化：配套后端服务统计捐款总额，自动生成实时排行榜

🛠️ 技术栈
模块	技术 / 工具

智能合约	Solidity 0.8.28, OpenZeppelin, Hardhat

合约模式	UUPS 可升级，Ownable, ReentrancyGuard

后端服务	Go + GORM + PostgreSQL

链上交互	ethclient 轮询监听事件

部署与测试	Hardhat, Mocha/Chai

📂 项目结构

plaintext

.

├── contracts/           # 智能合约源码

│   ├── base/            # 基础合约（权限、状态管理）

│   │   ├── FundAccess.sol    # 权限控制基类

│   │   └── FundState.sol     # 众筹状态管理

│   ├── core/            # 核心业务合约

│   │   └── Funding.sol       # 主众筹合约（核心逻辑）

│   ├── interfaces/      # 合约接口定义

│   │   └── IFunding.sol

│   └── libraries/       # 工具库

│       ├── AddressUtils.sol  # 地址/ETH转账工具

│       └── FundingMath.sol   # 金额计算工具

├── scripts/             # 部署与交互脚本

│   ├── deploy.js        # 合约部署脚本

│   └── callfunding.js   # 合约调用/测试脚本

├── test/                # 合约单元测试

│   ├── funding.js       # 众筹功能测试

│   └── Lock.js          # Hardhat 示例测试

├── hardhat.config.js    # Hardhat 网络与编译配置

└── package.json         # 项目依赖配置

🚀 合约功能说明

1. 资金筹集（fund()）
用户可在 1 ETH ~ 10 ETH 区间内捐款
捐款记录实时写入链上，触发 Funded 事件
当总金额达到目标 100 ETH 时，状态自动变为 Success
2. 退款机制（refund()）
仅在 Active 状态可退款，分账后禁止退款
用户可全额取回自己的捐款，同时更新合约余额
退款成功触发 ReFunded 事件
3. 自动分账（distribute()）
仅管理员可调用，按预设比例分配资金给多个接收方
分账后清空合约余额，避免数据不一致
每笔转账触发 Distribute 事件，方便链上追踪
📦 部署与运行
1. 安装依赖
bash
运行
npm install
2. 编译合约
bash
运行
npx hardhat compile
3. 部署合约
bash
运行
# 部署到 Hardhat 本地节点
npx hardhat run scripts/deploy.js --network hardhat

# 部署到 Sepolia 测试网
npx hardhat run scripts/deploy.js --network sepolia
4. 运行单元测试
bash
运行
npx hardhat test

🔍 链上监控服务
配套的 Go 后端服务会监听以下事件，并写入 PostgreSQL：
Funded：记录每笔捐款详情（地址、金额、交易哈希）
ReFunded：记录退款操作
Distribute：记录分账明细
自动维护 user_fund_totals 统计表，支持实时捐款排行榜查询
⚠️ 安全说明
所有敏感配置（私钥、RPC 节点）请通过 .env 文件配置，并已加入 .gitignore
合约使用 OpenZeppelin 标准库实现防重入、权限控制和可升级逻辑
退款和分账操作都有状态校验和数学溢出保护，避免资金损失
