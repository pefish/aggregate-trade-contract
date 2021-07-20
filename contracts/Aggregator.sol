// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Initializable } from "@pefish/solidity-lib/contracts/contract/Initializable.sol";
import { Ownable } from "@pefish/solidity-lib/contracts/contract/Ownable.sol";
import { IErc20 } from "@pefish/solidity-lib/contracts/interface/IErc20.sol";
import "./Domain.sol";
import "./Store.sol";

contract Aggregator is Initializable, Ownable, Store {

    function __Aggregator_init() external initializer {
        Ownable.__Ownable_init();
    }

    function initData (uint256 fee_, address feeAddress_) external onlyOwner {
        fee = fee_;
        feeAddress = feeAddress_;
    }

    function editExchange (string calldata name, Domain.ExchangeInfo calldata info) external onlyOwner {
        if (!exchanges[name].exist) {
            exchangeNames.push(name);
        }
        exchanges[name] = info;
        exchanges[name].exist = true;
    }

    function getAmountOut (uint256 amountIn, address[] calldata path) view external returns (string memory name, uint256 resultAmount) {
        for (uint256 i = 0; i < exchangeNames.length; i++) {
            string memory exchangeName = exchangeNames[i];
            Domain.ExchangeInfo memory info = exchanges[name];
            if (!info.enable) {
                continue;
            }
            uint[] memory amounts = info.router.getAmountsOut(amountIn, path);
            uint256 outAmount = amounts[amounts.length - 1];
            if (outAmount > resultAmount) {
                resultAmount = outAmount;
                name = exchangeName;
            }
        }
        return (name, resultAmount);
    }

    function getAmountIn (uint256 amountOut, address[] calldata path) view external returns (string memory name, uint256 resultAmount) {
        for (uint256 i = 0; i < exchangeNames.length; i++) {
            string memory exchangeName = exchangeNames[i];
            Domain.ExchangeInfo memory info = exchanges[name];
            if (!info.enable) {
                continue;
            }
            uint[] memory amounts = info.router.getAmountsIn(amountOut, path);
            uint256 inAmount = amounts[0];
            if (inAmount < resultAmount) {
                resultAmount = inAmount;
                name = exchangeName;
            }
        }
        return (name, resultAmount);
    }

    function swapExactTokensForTokens (
        string memory name,
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        Domain.ExchangeInfo memory info = exchanges[name];
        require(info.enable == true, "exchange not be enabled");

        IErc20 token = IErc20(path[0]);
        // 划转用户的 token
        require(token.transferFrom(msg.sender, address(this), amountIn), "failed transfer from user");
        // 扣掉手续费
        uint256 feeAmount = token.balanceOf(address(this)) * fee / 10000;
        require(token.transfer(feeAddress, feeAmount), "failed transfer fee");
        // 剩下的拿去交易
        uint256 inAmount = token.balanceOf(address(this));
        require(token.approve(address(info.router), inAmount), "failed to approve router");
        info.router.swapExactTokensForTokens(inAmount, amountOutMin, path, to, deadline);

    }
}
