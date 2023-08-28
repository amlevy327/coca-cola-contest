const hre = require('hardhat');

async function main() {

  const CocaColaCodes = await hre.ethers.getContractFactory(
    'CocaColaCodes',
  );

  const name = "CocaColaCodes"
  const symbol = "CCC"

  const cocaColaCodes = await CocaColaCodes.deploy(
    name,
    symbol
  );

  await cocaColaCodes.waitForDeployment();

  console.log(`cocaColaCodes deployed to ${await cocaColaCodes.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});