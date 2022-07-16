// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ISplitMain {
    function createSplit(
        address[] calldata accounts,
        uint32[] calldata percentAllocations,
        uint32 distributorFee,
        address controller
    ) external returns (address);
}
