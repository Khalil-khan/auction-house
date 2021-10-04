pragma solidity >=0.5.0<0.9.0;
contract SimpleAution{
    address payable public beneficiary;
    uint public auctionEndTime;
    
    
    address public highestBidder;
    uint public highestBid;
    
    mapping(address=>uint)public pendingReturn;
    bool ended= false;
    
    event HighestBidIncrease(address bidder, uint amount);
    event AuctionEnded(address winner , uint amount);
    
    constructor(uint _biddingTime ,address payable _beneficiary){
        beneficiary= _beneficiary;
        auctionEndTime= block.timestamp + _biddingTime;
    }
    
    function bid() public payable{
        if (block.timestamp> auctionEndTime){
            revert("The auction has already ended");
            }
            if (msg.value<= highestBid){
                revert("There is already a higher or equal bid");
            }
            if (highestBid !=0){
                pendingReturn[highestBidder]+=highestBid;
            }
            highestBidder = msg.sender;
            highestBid = msg.value;
            emit HighestBidIncrease(msg.sender , msg.value);
    }
     
     function withdraw() public returns(bool){
         uint amount = pendingReturn[msg.sender];
         if (amount >0){
             pendingReturn[msg.sender]=0;
             
             if(!payable (msg.sender).send(amount)){
                 pendingReturn[msg.sender]= amount;
                 return false;
             }
             
         }
         return true;
     }
     function auctionEnd() public {
         if (block.timestamp < auctionEndTime){
             revert ("The Auction has not ended yet");
             
         }
         if (ended){
             revert ("The function AuctionEnded has already been called");
         }
          ended= true;
           emit AuctionEnded( highestBidder, highestBid);
           beneficiary.transfer(highestBid);
     }
}
    
            
            
    
    
