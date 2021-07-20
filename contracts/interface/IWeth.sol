// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IErc20 } from "@pefish/solidity-lib/contracts/interface/IErc20.sol";

interface IWeth is IErc20 {
  function withdraw(uint wad) external;
  function deposit() external payable;
}
