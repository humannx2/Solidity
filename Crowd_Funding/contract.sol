pragma solidity >=0.7.0 <0.9.0;

contract crowd_fund{

    // struct for storing the details of the fund
    struct fund_details{
        string description;
        uint value;
        address payable recipient;
        bool completed;
    }
    uint public deadline;
    uint public target;
    uint public raised_amt;
    uint public min_donation;
    uint public no_of_donors;
    uint public num_requests;
    address public Owner;
    mapping (address=>uint) public donation;//amount donated
    mapping (uint=>fund_details) public funds; //mapping for multiple funds and the key to identify them

    // creating target and deadline 
    constructor(uint _target, uint _deadline){
        target=_target;
        deadline=block.timestamp+_deadline; //add the deadline period to the current timestamp
        min_donation=1 ether;
        Owner=msg.sender;
    }

    // modifier for manager request 
    modifier ownerReq(){
        require(msg.sender==Owner,"Can only be used by Contract Owner!");
        _;
    }

    // creating a fund request by the owner
    function createFund (string calldata _desc,address payable _recipient, uint _value) public ownerReq {
        // obj to access the elements of fund_details, pointing to one specific fund in funds using the number of requests. 
        fund_details storage fund_obj = funds[num_requests];
        num_requests++;
        fund_obj.description=_desc;
        fund_obj.recipient=_recipient;
        fund_obj.value=_value;
        fund_obj.completed=false;
    }

    // payinng the contract
    function donate() public payable {
        require(block.timestamp<deadline,"This Fund has expired!");
        require(msg.value>=min_donation,"Minimun Donation required is 1 Ether ");
        if(donation[msg.sender]==0) //checks if the address already exists by checking the amount, and for every new address, we increase the number of donars
            no_of_donors++;
        donation[msg.sender]+=msg.value; //updates the total donation value of the donar in the mapping
        raised_amt+=msg.value; 
    }

    // check balance of the contract fund
    function checkBalance () public view returns(uint){
        return address(this).balance;
    }

    // option for refund if desired target isn't met
    function requestRefund() public {
        require(block.timestamp>deadline && raised_amt<target,"You're not eligible for Refund");
        require(donation[msg.sender]>0,"You are not a donor"); //checks if the address calling has donated or not using the donation mapping
        payable (msg.sender).transfer(donation[msg.sender]); //transfers all the amount donated back
        donation[msg.sender]=0; //resets it to 0
    }

    //transfer the amount if everything is good :)
    function transfer(uint fund_num) public ownerReq{
        require(raised_amt>=target,"Target isn't met!");
        fund_details storage obj = funds[fund_num]; //creating object for fund details as above
        require(obj.completed==false,"The Funds have already been transferred");
        obj.recipient.transfer(obj.value);
        obj.completed=true;
    }
}