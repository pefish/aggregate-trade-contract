const AggregatorProxy = artifacts.require("AggregatorProxy");
const Aggregator = artifacts.require("Aggregator");
import Web3 from "web3"

declare var web3: Web3;

module.exports = async function (deployer,network, accounts) {
  await deployer.deploy(Aggregator);

  // deploy proxy
  await deployer.deploy(AggregatorProxy);

  const proxyAddress = AggregatorProxy.address
  // @ts-ignore
  let proxyContract: web3.eth.Contract = new web3.eth.Contract(AggregatorProxy.abi, proxyAddress)
  // set implement
  await proxyContract.methods["upgradeTo"](Aggregator.address).send({
    from: accounts[0],
  })

  // init
  let proxyContract1 = new web3.eth.Contract(Aggregator.abi, proxyAddress)
  await proxyContract1.methods["__Aggregator_init"]().send({
    from: accounts[0],
  })
} as Truffle.Migration;

export {};