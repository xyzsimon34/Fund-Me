// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;

    //mapping 是 Solidity 中的一種哈希表，允許將地址映射到他們所捐助的金額。
    mapping ( address => uint256 amountFunded) public addressToAmountFunded; // addressToAmountFunded 是該映射的名稱，用來記錄每個地址向合約捐助了多少。

    function fund() public payable {
        msg.value.getConversionRate();
        //require(getConversionRate(msg.value) >= minimumUsd,"didn't send enough ETH");

        funders.push(msg.sender); // msg.sender 是一個全局變量，表示調用此函數的地址

        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value; // 代表該用戶以前發送的總額，然後加上這次發送的金額，將其更新為新的總額。
    }
    
    // 允許用戶向合約發送 ETH，並記錄每個用戶發送的金額。每當一個用戶發送資金，系統會檢查發送的 ETH 是否達到了最低美元值，並將該用戶的地址和發送金額記錄在對應的資料結構中。
    // address 是鍵（User的地址）。
    // uint256 amountFunded 是值（User捐助的 ETH 數量）。
    
    function withdraw() public {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];//取得當前資助者的地址
            addressToAmountFunded[funder] = 0;//資助我們時的$$重置為0，可以說是把錢全數取出的概念
        }

        // reset the array
        // withdraw the funds
        funders = new address[](0);//將 funders 陣列重新初始化為一個空陣列，刪除所有原本在 funders 中的地址。這通常用於清空資助者列表，可能在完成提款操作後重置狀態。

    }

   
}