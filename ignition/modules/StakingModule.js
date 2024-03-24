const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("StakingModule", (m) => {
  const initialSupply = m.getParameter("initialSupply", "1000000");
  const rewardPerBlock = m.getParameter("rewardPerBlock", "1");
  const defi = m.contract("DEFI", [initialSupply]);
  const staking = m.contract("Staking", [defi, rewardPerBlock]);

  return { defi, staking };
});