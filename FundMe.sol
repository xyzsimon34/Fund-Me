// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    uint256 public minimumUsd = 5e18;

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent $
        // 1. How to we send ETH to this contract？
        require(getConversionRate(msg.value) >= minimumUsd,"didn't send enough ETH");
    }

    function getPrice() public view returns (uint256) {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI

        // Chainlink ETH/USD 預言機地址
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        // 獲取最新價格數據
        (,int256 price,,,) = priceFeed.latestRoundData();

        // Price of ETH in terms of USD
        // 2XXX.00000000

        // 返回的價格可能是 8 位小數，所以乘以 1e10 來標準化為 18 位小數
        return uint256( price * 1e10 );

    }

    function getConversionRate(uint _ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = ( ethPrice * _ethAmount ) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() public view returns(uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}