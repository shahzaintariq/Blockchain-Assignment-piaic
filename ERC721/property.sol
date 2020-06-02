pragma solidity ^0.6.0;

import './ERC721.sol';

contract property is ERC721{
    
    uint256 private _tokenId;
    
    struct property_details{
        string property_address;
        uint acre;
        uint price;
        bool isOnSale;
    }
    
    mapping(address => property_details)  for_property;

    constructor() ERC721('Zain Town','SZT') public {
        
    }
    
    function register_property(string memory _propertyAddress, uint _acres_of_lane, uint _price_in_ether) public returns(bool){
        _tokenId++;
        uint256 tempId = _tokenId;
        _mint(msg.sender, tempId);
        
        property_details memory memory_property_details;
        
        memory_property_details = property_details({
            property_address: _propertyAddress,
            acre: _acres_of_lane,
            price: _price,
            isOnSale: false
        });
        
        for_property[msg.sender] = memory_property_details;
        return true;
    }
    
    function enable_property() public returns(bool){
        
    }
}

