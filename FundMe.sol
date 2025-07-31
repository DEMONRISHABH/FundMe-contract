//SPDX-License-Identifier: MIT
pragma solidity >=0.7.10;

contract FundMe{
    function fund() public payable{
        require(msg.value>1e18,"Please send minimum Eth!!!");
    }
}