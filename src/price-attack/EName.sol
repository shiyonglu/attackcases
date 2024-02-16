// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";


// 1.  Price might be changed by other registers by front-running

contract EName is ERC721{
    address public treasury;

    uint256 counter; 

    mapping(uint256 => string) public idToEName;  // mapping from NFT id to EName
    mapping(string => uint256) public eNameToId;  // mapping from EName to NFT id

    mapping (address => string) public ename;
    mapping (string => address) public eaddress;

    uint256 public price  = 0.1 ether;

    constructor(address _treasury) ERC721("EName", "EName"){
        treasury = _treasury;
    }   

    modifier onlyENameOwner(string memory _ename){
        uint256 id = eNameToId[_ename];
        require(msg.sender == ownerOf(id), "Not owner");
        _;
    }


     function register(string memory _ename) payable public {
        // checks
        _ename = _toLower(_ename);

        uint256 id = eNameToId[_ename];
        require(id == 0, "ename not available");

        require(msg.value >= price, "Fee too low.");
        uint256 change = msg.value - price; 
        uint256 currentPrice = price;

        // effects
        // bind id to ename
        id = ++counter;
        idToEName[id] = _ename;
        eNameToId[_ename] = id;  
        
        price = currentPrice + currentPrice / 100; // price incease by 1 percent

        // interactions
        _mint(msg.sender, id);
        (bool success, ) = treasury.call{value: currentPrice}("");
        require(success, "Sending fee fails. ");
     
        if(change > 0){
            (success, ) = msg.sender.call{value: change }("");
            require(success, "Sending change fails. ");
        }
    }

    function bindEName(string memory _ename, address account) onlyENameOwner(_ename) public {
        // delete old mappings, we only allow 1-1 mapping
        address exAddress = eaddress[_ename];
        delete ename[exAddress]; // this ename is not associated with an old address anymore
        string memory exEName = ename[account];
        delete eaddress[exEName];    // account has no other associated ename anymore, both of them need to divorce their ex
    
        eaddress[_ename] = account;
        ename[account] = _ename;
    }

    function _toLower(string memory str) internal pure returns (string memory) {
		bytes memory bStr = bytes(str);
		bytes memory bLower = new bytes(bStr.length);
		for (uint i = 0; i < bStr.length; i++) {
			// Uppercase character...
			if ((bStr[i] >= 'A') && (bStr[i] <= 'Z')) {
				// So we add 32 to make it lowercase
				bLower[i] = bytes1(uint8(bytes1(bStr[i])) + 32);
			} else {
				bLower[i] = bStr[i];
			}
		}
		return string(bLower);
	}
}
