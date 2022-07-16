// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {IMetadataRenderer} from "zora-drops-contracts/interfaces/IMetadataRenderer.sol";
import {ZoraNFTCreatorV1} from "zora-drops-contracts/ZoraNFTCreatorV1.sol";

/**
 * @title CustomRenderer
 * @author @ZORAEngineering
 * @notice Create a Drop with a custom renderer implementing IMetadataRenderer
 * @dev get current deployment addresses from:
 *      https://github.com/ourzora/zora-drops-contracts/tree/main/deployments
 */
contract CustomRenderer is Script {
    function run() public {
        address creatorAddress = vm.envAddress("CREATOR_ADDRESS");
        address payable sender = payable(msg.sender);

        // presume we've already deployed our renderer
        address rendererAddress = vm.envAddress("RENDERER_ADDRESS");
        IMetadataRenderer metadataRenderer = IMetadataRenderer(rendererAddress);

        // IMetadataRenderer can be passed arbitrary props via
        // initializeWithData(bytes memory initData)
        bytes memory metadataInitializer = abi.encode(
            "this is a custom renderer",
            "and it takes custom init data"
        );

        address dropAddress = ZoraNFTCreatorV1(creatorAddress)
            .setupDropsContract(
                "Custom Renderer", // name
                "CSTM", //symbol
                sender, // defaultAdmin
                111, // editionSize
                42_00, // royaltyBPS
                sender,
                IERC721Drop.SalesConfiguration({
                    publicSaleStart: 0,
                    publicSaleEnd: 0,
                    presaleStart: 0,
                    presaleEnd: 0,
                    publicSalePrice: 0.69 ether,
                    maxSalePurchasePerAddress: 1,
                    presaleMerkleRoot: 0x0
                }),
                metadataRenderer,
                metadataInitializer
            );
    }
}
