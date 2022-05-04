//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/access/Ownable.sol";
import "interfaces/ILayerZeroReceiver.sol";
import "interfaces/ILayerZeroEndpoint.sol";
import "interfaces/ILayerZeroUserApplicationConfig.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "contracts/NonblockingReceiver.sol";

// File: contracts/MagicSquares.sol

contract MagicSquares is Ownable, ERC721, NonblockingReceiver {
    address public _owner;
    string private baseURI = "ipfs://xxx/";
    uint256 nextTokenId = 7456;
    uint256 MAX_MINT_Amount = 10000;
    uint256 gasForDestinationLzReceive = 350000;
    bool public paused = false;

    constructor(string memory baseURI_, address _layerZeroEndpoint)
        ERC721("MagicSquares", "MSQU")
    {
        _owner = msg.sender;
        endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
        baseURI = baseURI_;
    }

    // mint function
    // you can choose to mint 1 or 2
    // mint is free, but payments are accepted
    function mint(uint8 numTokens) external payable {
        require(!paused, "Sale hasn't not started yet");
        require(balanceOf(msg.sender) < 2, "Each address may only own 2 NFTs");
        require(numTokens < 3, "Magic Squares: Max 2 NFTs per transaction");
        require(
            nextTokenId + numTokens <= MAX_MINT_Amount,
            "Magic Squares: Mint exceeds supply"
        );
        _safeMint(msg.sender, ++nextTokenId);
        if (numTokens == 2) {
            _safeMint(msg.sender, ++nextTokenId);
        }
    }

    // This function transfers the nft from your address on the
    // source chain to the same address on the destination chain
    function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
        require(
            msg.sender == ownerOf(tokenId),
            "You must own the token to traverse"
        );
        require(
            trustedRemoteLookup[_chainId].length > 0,
            "This chain is currently unavailable for travel"
        );

        // burn NFT, eliminating it from circulation on src chain
        _burn(tokenId);

        // abi.encode() the payload with the values to send
        bytes memory payload = abi.encode(msg.sender, tokenId);

        // encode adapterParams to specify more gas for the destination
        uint16 version = 1;
        bytes memory adapterParams = abi.encodePacked(
            version,
            gasForDestinationLzReceive
        );

        // get the fees we need to pay to LayerZero + Relayer to cover message delivery
        // you will be refunded for extra gas paid
        (uint256 messageFee, ) = endpoint.estimateFees(
            _chainId,
            address(this),
            payload,
            false,
            adapterParams
        );

        require(
            msg.value >= messageFee,
            "Magic Squares: msg.value not enough to cover messageFee. Send gas for message fees"
        );

        endpoint.send{value: msg.value}(
            _chainId, // destination chainId
            trustedRemoteLookup[_chainId], // destination address of nft contract
            payload, // abi.encoded()'ed bytes
            payable(msg.sender), // refund address
            address(0x0), // 'zroPaymentAddress' unused for this
            adapterParams // txParameters
        );
    }

    function setBaseURI(string memory _URI) external onlyOwner {
        baseURI = _URI;
    }

    function donate() external payable {
        // thank you
    }

    // This allows the devs to receive kind donations
    function withdraw(uint256 amt) external onlyOwner {
        (bool sent, ) = payable(_owner).call{value: amt}("");
        require(sent, "Magic Squares: Failed to withdraw");
    }

    // just in case this fixed variable limits us from future integrations
    function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
        gasForDestinationLzReceive = newVal;
    }

    // ------------------
    // Internal Functions
    // ------------------

    function _LzReceive(
        uint16 _srcChainId,
        bytes memory _srcAddress,
        uint64 _nonce,
        bytes memory _payload
    ) internal override {
        // decode
        (address toAddr, uint256 tokenId) = abi.decode(
            _payload,
            (address, uint256)
        );

        // mint the tokens back into existence on destination chain
        _safeMint(toAddr, tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }
   } 