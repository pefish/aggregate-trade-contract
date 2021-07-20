// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { UpgradeabilityProxy } from "@pefish/solidity-lib/contracts/contract/UpgradeabilityProxy.sol";

contract AggregatorProxy is UpgradeabilityProxy {
  constructor() {
    UpgradeabilityProxy.__UpgradeabilityProxy_init();
  }
}
