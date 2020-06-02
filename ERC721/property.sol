pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './ERC721.sol';

contract property is ERC721{
    
    uint256 private _tokenId;
    uint256 private buyerID;
    
    struct property_details{
        uint id;
        string property_address;
        uint acre;
        uint price;
        bool isOnSale;
    }
    
    struct buyer_data{
        uint id;
        address buyer_addr;
        uint buyer_offer;
    }
    
    buyer_data[] public buyer_array;

    modifier property_owner(uint256 _token_id){
        require(id_list[_token_id] == msg.sender,"ERROR: only property of owner can run this operation");
        _;
    }
    
    mapping(address => property_details)  for_property;
    mapping(uint256 => address) id_list;
    mapping(uint256 => buyer_data[]) public buyer_list;
    
    
    constructor() ERC721('Zain Town','SZT') public {
        
    }
    
    function register_property(string memory _propertyAddress, uint256 _acres_of_lane, uint256 _price_in_ether, string memory _tokenURi) public returns(bool){
        _tokenId++;
        uint256 tempId = _tokenId;
        _mint(msg.sender, tempId);
        _setTokenURI(tempId, _tokenURi);

        property_details memory memory_property_details;
        
        memory_property_details = property_details({
            id: tempId,
            property_address: _propertyAddress,
            acre: _acres_of_lane,
            price: _price_in_ether,
            isOnSale: false
        });
        
        for_property[msg.sender] = memory_property_details;
        id_list[tempId] = msg.sender;
        return true;
    }
    
    function enable_property(uint token_or_Property_ID) public property_owner(token_or_Property_ID) returns(bool){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        
        for_property[id_list[token_or_Property_ID]].isOnSale = true;
        return true;
    }
    
    function price_of_property(uint token_or_Property_ID) public view returns(uint256){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        return for_property[id_list[token_or_Property_ID]].price;
    }
    
    function buy_request(uint token_or_Property_ID,uint _your_offer_inether) public returns(bool){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        require(for_property[id_list[token_or_Property_ID]].isOnSale, "ERROR: this property is currently not available for sale");
        buyerID++;
    
        buyer_data memory temp_buyer_data;
        temp_buyer_data = buyer_data({
            id: buyerID,
            buyer_addr: msg.sender,
            buyer_offer: _your_offer_inether
        }); 
        
        buyer_array.push(temp_buyer_data);
        
        buyer_list[token_or_Property_ID].push(temp_buyer_data);
        
    }
    
    
    function check_offers(uint token_or_Property_ID) public view property_owner(token_or_Property_ID) returns(buyer_data[] memory){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        
        buyer_data[] memory arr;
        arr = buyer_list[token_or_Property_ID];
        return arr;
        
    }
    
    
}

