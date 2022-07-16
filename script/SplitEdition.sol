// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {IMetadataRenderer} from "zora-drops-contracts/interfaces/IMetadataRenderer.sol";
import {ZoraNFTCreatorV1} from "zora-drops-contracts/ZoraNFTCreatorV1.sol";

// FIXME: can't import bc it's hardcoded to 0.8.4;
// import {ISplitMain} from "splits-contracts/../contracts/interfaces/ISplitMain.sol";

import {ISplitMain} from "./interfaces/ISplitMain.sol";

/**
 * @title SplitEdition
 * @author @ZORAEngineering + @0xSplits
 * @notice Create an edition with a Split as the fundsRecepient
 * @dev get current deployment addresses from:
 *      https://github.com/ourzora/zora-drops-contracts/tree/main/deployments
 *      + https://docs.0xsplits.xyz/smartcontracts/overview
 */
contract SplitEdition is Script {
    function run() public {
        // get up to date addresses from
        address creatorAddress = vm.envAddress("CREATOR_ADDRESS");
        address splitMainAddress = vm.envAddress("SPLIT_MAIN_ADDRESS");

        // TODO: these need to be ordered?
        address[] calldata accounts = [
            address(msg.sender),
            address(0x42069),
            address(0x69420)
        ];

        // TODO: not certain if this is supposed to be in BPS
        uint32[] calldata percentAllocations = [42_0, 69, 95_11];
        uint32 distributorFee = 5_00;
        address split = ISplitMain(splitMainAddress).createSplit(
            accounts,
            percentAllocations,
            distributorFee,
            payable(msg.sender) // controller
        );

        address dropAddress = ZoraNFTCreatorV1(creatorAddress).createEdition(
            "Split Drop", // name
            "SPLT", // symbol
            111, // editionSize
            42_00, // royaltyBPS
            split, // fundsRecepient
            msg.sender, // defaultAdmin
            IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                publicSaleEnd: 0,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0.69 ether,
                maxSalePurchasePerAddress: 1,
                presaleMerkleRoot: 0x0
            }),
            "DESCRIPTION",
            "animationURI",
            "imageURI"
        );
    }
}
