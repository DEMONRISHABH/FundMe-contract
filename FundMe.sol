//SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    error NotOwner();
    error SendFailed();
    error MinimumEthNotSend();

    uint256 constant MINIMUM_AMOUNT = 2e18;
    address[] public funders;
    mapping(address => uint256)public addressToAmountFunded;

    address public immutable i_owner;
    constructor(){
        i_owner = msg.sender;
    }


    function fund() public payable{
        //require(PriceConverter.getConversionRate(msg.value)>MINIMUM_AMOUNT,"Please send minimum Eth!!!");
        if(PriceConverter.getConversionRate(msg.value)<MINIMUM_AMOUNT)
        revert MinimumEthNotSend();
        addressToAmountFunded[msg.sender]+=msg.value;
        funders.push(msg.sender);
    }


    receive() external payable{
        fund();
    }
    fallback() external payable{
        fund();
    }


    modifier onlyowner{
        // require(msg.sender == i_owner,"You must be a owner of this contract to withdraw!");
        if(msg.sender!=i_owner)
        revert NotOwner();
        _;
    }

    function withdraw() public onlyowner{
        for(uint256 fundersIndex=0;fundersIndex<funders.length;fundersIndex++){
            addressToAmountFunded[funders[fundersIndex]] = 0;
        }
        delete funders;
        (bool success,) = payable(msg.sender).call{value:address(this).balance}("");
        //require(success,"Send failed!");
        if(success != true)
        revert SendFailed();
    }
}