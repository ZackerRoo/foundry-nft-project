//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUrl;
    string private s_happlySvgImageUrl;
    enum Mood {
        sad,
        happly
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageUrl, string memory happlySvgImageUrl) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUrl = sadSvgImageUrl;
        s_happlySvgImageUrl = happlySvgImageUrl;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.happly;
        s_tokenCounter++;
    }

    //改变心情
    function flipMood(uint256 tokenId) public {
        if (!_isAuthorized(_ownerOf(tokenId), msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.happly) {
            s_tokenIdToMood[tokenId] = Mood.sad;
        } else {
            s_tokenIdToMood[tokenId] = Mood.happly;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // if (!_exists(tokenId)) {
        //     revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        // }

        string memory imageURI = s_happlySvgImageUrl;
        if (s_tokenIdToMood[tokenId] == Mood.sad) {
            imageURI = s_sadSvgImageUrl;
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getHappySVG() public view returns (string memory) {
        return s_happlySvgImageUrl;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSvgImageUrl;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
