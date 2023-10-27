//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract DasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    string public constant PUG = "ipfs://QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8";

    address Users = makeAddr("User");

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameisTheSame() public {
        string memory expectname = "doggie";
        string memory actualName = basicNft.name();
        assert(keccak256(abi.encodePacked(expectname)) == keccak256(abi.encodePacked(actualName)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(Users);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(Users) == 1);
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
