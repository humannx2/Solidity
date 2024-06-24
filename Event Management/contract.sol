// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

contract EventOrg{
    struct Details{
        address organiser;
        string name_of_event;
        uint32 price;
        uint16 tickets;
        uint16 tickets_remaining;
        uint64 date;
    }

    // mapping for multiple events
    mapping (uint=>Details) public no_of_events;
    // mapping for tickets
    mapping (address=>mapping (uint=>uint)) public tickets;
    // counter for number of events
    uint public eventId;

    // function to create an event
    function create_event(string calldata _name_of_event, uint32 _price, uint16 _num_tickets, uint64 _date) public {
        require(block.timestamp<_date,"Event cannot be created for a past date.");
        require(_num_tickets!=0,"Number of Tickets cannot be equal to zero.");
        no_of_events[eventId]=Details(msg.sender,_name_of_event,_price,_num_tickets,_num_tickets,_date);
        eventId++;
    }
    // function to buy tickets
    function buy_tickets(uint _eventId, uint16 _ticketQuantity) public payable {
        require(no_of_events[_eventId].date!=0,"Event does not exist!"); // checks if event with the provided id exists or not
        require(no_of_events[_eventId].date>block.timestamp,"Event has ended.");
        Details storage _current_event=no_of_events[_eventId]; //variable points towards current event
        require(_ticketQuantity<=no_of_events[_eventId].tickets_remaining,"Not enough tickets left");
        require(msg.value==(no_of_events[_eventId].price*_ticketQuantity),"Not enough Ether present in Account");
        //update the tickets count
        _current_event.tickets_remaining-=_ticketQuantity;
        tickets[msg.sender][_eventId]+=_ticketQuantity; //tells us this address for this event bought these many tickets
        // the same address can buy tickets to multiple events, mapping helps to track that.
    }

    // function to transfer the tickets
    function transfer(uint16 _quantity, address _to, uint _eventId) public {
        require(no_of_events[_eventId].date!=0,"Event does not exist!"); // checks if event with the provided id exists or not
        require(no_of_events[_eventId].date>block.timestamp,"Event has ended.");
        require(tickets[msg.sender][_eventId]>=_quantity,"Quantity exceeds the number of tickets you have in account");
        tickets[msg.sender][_eventId]-=_quantity; //deducts the tickets from sender
        tickets[_to][_eventId]+=_quantity; //updates the ticket at receiver
    }
}
