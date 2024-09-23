import {ethers} from "hardhat";
async function main() {
  const EtherWallet = await ethers.getContractFactory("EtherWallet");
  const EtherWallet1 = await EtherWallet.deploy();
  await EtherWallet1.deploymentTransaction();
  console.log("HelloWorld deployed to:", EtherWallet1);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
