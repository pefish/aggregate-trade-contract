import {AggregatorInstance, AggregatorProxyInstance} from "../types/truffle-contracts";
import Web3 from "web3"

declare var web3: Web3;

const AggregatorProxy = artifacts.require("AggregatorProxy");
const Aggregator = artifacts.require("Aggregator");

contract('AggregatorProxy', (accounts) => {
  let aggregatorProxyInstance: AggregatorProxyInstance
  let aggregatorInstance: AggregatorInstance

  beforeEach(async function () {
    aggregatorInstance = await Aggregator.new()
    aggregatorProxyInstance = await AggregatorProxy.new();
    await aggregatorProxyInstance["upgradeTo"](aggregatorInstance.address)
    // @ts-ignore
    let aggregatorProxyContract: web3.eth.Contract = new web3.eth.Contract(Aggregator.abi, aggregatorProxyInstance.address)
    await aggregatorProxyContract.methods["__Aggregator_init"]().send({
      from: accounts[0],
    })
  });


  it('editExchange', async () => {
    // @ts-ignore
    let aggregatorProxyContract: web3.eth.Contract = new web3.eth.Contract(Aggregator.abi, aggregatorProxyInstance.address)

    await aggregatorProxyContract.methods["editExchange"](
      "pancake",
      {
        enable: true,
        router: "0x2465176C461AfB316ebc773C61fAEe85A6515DAA"
      }
    ).send({
      from: accounts[0],
      gasLimit: 3000000,
    })
    const result1 = await aggregatorProxyContract.methods["exchanges"]("pancake").call()
    // console.log(result1)
    assert.equal(result1["enable"], true);
    assert.equal(result1["router"], "0x2465176C461AfB316ebc773C61fAEe85A6515DAA");
  });

});
