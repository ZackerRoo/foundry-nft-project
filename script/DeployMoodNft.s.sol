//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    MoodNft moodnft;

    function run() external returns (MoodNft) {
        // vm.startBroadcast();
        // moodnft = new MoodNft(SAD_SVG_URI, HAPPLY_SVG_URI);
        // vm.stopBroadcast();
        // return moodnft;
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happlySvg = vm.readFile("./img/happly.svg");
        vm.startBroadcast();
        moodnft = new MoodNft(svgToImageURI(sadSvg), svgToImageURI(happlySvg));
        vm.stopBroadcast();
        return moodnft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory prefixBaseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(prefixBaseURL, svgBase64Encoded));
    }
}
