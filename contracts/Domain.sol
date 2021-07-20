// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IUniRouter.sol";

contract Domain {
  struct ExchangeInfo {
    bool exist;
    bool enable;
    IUniRouter router;
  }
}
