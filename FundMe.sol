// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    uint256 public minimumUsd = 5e18;

    address[] public funders;

    //mapping 是 Solidity 中的一種哈希表，允許將地址映射到他們所捐助的金額。
    mapping ( address => uint256 amountFunded) public addressToAmountFunded; // addressToAmountFunded 是該映射的名稱，用來記錄每個地址向合約捐助了多少。

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent $
        // 1. How to we send ETH to this contract？
        require(getConversionRate(msg.value) >= minimumUsd,"didn't send enough ETH");

        funders.push(msg.sender); // msg.sender 是一個全局變量，表示調用此函數的地址

        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value; // 代表該用戶以前發送的總額，然後加上這次發送的金額，將其更新為新的總額。
    }
    
    // 允許用戶向合約發送 ETH，並記錄每個用戶發送的金額。每當一個用戶發送資金，系統會檢查發送的 ETH 是否達到了最低美元值，並將該用戶的地址和發送金額記錄在對應的資料結構中。
    // address 是鍵（User的地址）。
    // uint256 amountFunded 是值（User捐助的 ETH 數量）。




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