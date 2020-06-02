pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './ERC721.sol';

contract property is ERC721{
    
    uint256 private _tokenId;
    uint256 private buyerID;
    
    enum offer_approval{pending,approved,rejected}
    
    //details about property
    struct property_details{
        uint id;
        string property_address;
        uint acre;
        uint price;
        address seller_addr;
        bool isOnSale;
    }
    
    // details of buyer data
    struct buyer_data{
        uint id;
        address buyer_addr;
        uint buyer_offer;
        offer_approval offer_request;
    }
    

    modifier property_owner(){
        require(for_property[msg.sender].seller_addr == msg.sender,"ERROR: only property of owner can run this operation");
        _;
    }
    
    mapping(address => property_details) public for_property;
    mapping(uint256 => address) public id_list;
    mapping(address => buyer_data) public buyer_list;
    mapping(uint256 => buyer_data[]) public buyer_arr;
    // mapping(uint256 => bool) public buyer_request;
    
    constructor() ERC721('Zain Town','SZT') public {
        
    }
    
    //@dev this function register property and mint token of that protpert
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
            seller_addr: msg.sender,
            isOnSale: false
        });
        
        for_property[msg.sender] = memory_property_details;
        id_list[tempId] = msg.sender;
        return true;
    }
    
    //function will enable property/token for sale
    function enable_property(uint token_or_Property_ID) public property_owner() returns(bool){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        
        for_property[id_list[token_or_Property_ID]].isOnSale = true;
        return true;
    }
    
    //function will return the price of property/token
    function price_of_property(uint token_or_Property_ID) public view returns(uint256){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        return for_property[id_list[token_or_Property_ID]].price;
    }
    
    //this function will give offer aginst property for owner of property and add data buyer into contract
    function buy_request(uint token_or_Property_ID,uint _your_offer_inether) public returns(bool){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        require(for_property[id_list[token_or_Property_ID]].isOnSale, "ERROR: this property is currently not available for sale");
        buyerID++;
    
        buyer_data memory temp_buyer_data;
        temp_buyer_data = buyer_data({
            id: buyerID,
            buyer_addr: msg.sender,
            buyer_offer: _your_offer_inether,
            offer_request: offer_approval.pending
        }); 
        
        buyer_arr[token_or_Property_ID].push(temp_buyer_data);
    
        buyer_list[msg.sender] = temp_buyer_data;
        buyer_list[msg.sender].offer_request = offer_approval.pending ;
    }
    
    //check offers of buyers for approval
    function check_offers(uint token_or_Property_ID) public view property_owner returns(buyer_data[] memory){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        
        buyer_data[] memory arr;
        arr = buyer_arr[token_or_Property_ID];
        return arr;
        
    }
    
    //this function will accept the buyer offer request and buyer can buy the property
    function accept_buyer_offer(address _buyer_address,uint token_or_Property_ID) public property_owner returns(bool){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        require(buyer_list[_buyer_address].buyer_addr == _buyer_address, "Error: invailid Buyers Address");
        
        buyer_list[_buyer_address].offer_request = offer_approval.approved;

        return true;
    }
    
    //this function will rejects the buyer offer request
    function reject_buyers_offer(address _buyer_address,uint token_or_Property_ID) public property_owner returns(bool){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        require(buyer_list[_buyer_address].buyer_addr == _buyer_address, "Error: invailid Buyers Address");
        
        buyer_list[_buyer_address].offer_request = offer_approval.rejected;
        
        return true;
    }
    
    //buyer who are approved from owner can buy the property with this function
    function buy_property(uint256 token_or_Property_ID) public payable returns(bool){
        require(_exists(token_or_Property_ID),"ERROR: invailed token id");
        require(buyer_list[msg.sender].buyer_addr == msg.sender,"ERROR: you haven'y submited your buy request");
        require(buyer_list[msg.sender].offer_request  ==  offer_approval.approved,"ERROR: your offer is not approved");
        require(msg.value > 0,"ERROR: Ether not privided");
        uint price_of = buyer_list[msg.sender].buyer_offer.mul(1*10**18);
        require(price_of == msg.value, "ERROR: invailed price this price doesnot match with your given offer in buyer Request");
    
        address buyer_adrress = for_property[id_list[token_or_Property_ID]].seller_addr;
        
        _transfer(buyer_adrress,msg.sender,token_or_Property_ID);
        
         emit Transfer(buyer_adrress, msg.sender, token_or_Property_ID);
    }
    
 
    
}

