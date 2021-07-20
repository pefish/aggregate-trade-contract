// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Domain.sol";

contract Store {
  string[] public exchangeNames;
  mapping(string => Domain.ExchangeInfo) public exchanges;
  uint256 public fee;
  address public feeAddress;
}
