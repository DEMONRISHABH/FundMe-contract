//SPDX-License-Identifier: MIT
pragma solidity >=0.7.10;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    uint256 MINIMUM_AMOUNT = 2e18;
    address[] public funders;
    mapping(address => uint256)public addressToAmountFunded;

    function getVersion() public view returns(uint256){
        return priceFeed.version();
    }

    function getLatestPrice() public view returns(uint256){
        (,int price,,,)=priceFeed.latestRoundData();
        return uint(price)*1e10;
    }

    function getConversionRate(uint ethAmount) internal view returns(uint256){
        return (getLatestPrice()*ethAmount)/1e18;
    }

    function fund() public payable{
        require(getConversionRate(msg.value)>MINIMUM_AMOUNT,"Please send minimum Eth!!!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]+=msg.value;
    }
}