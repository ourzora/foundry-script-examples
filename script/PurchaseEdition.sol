// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";

contract PurchaseEdition is Script {
    function run(address dropAddress, uint256 quantity) public {
        IERC721Drop drop = IERC721Drop(dropAddress);

        vm.startBroadcast();

        IERC721Drop.SaleDetails memory details = drop.saleDetails();

        console.log("totalMinted:", details.totalMinted);
        console.log("maxSupply:", details.maxSupply);
        console.log("publicSalePrice:", details.publicSalePrice);

        drop.purchase(quantity);

        vm.stopBroadcast();
    }
}
