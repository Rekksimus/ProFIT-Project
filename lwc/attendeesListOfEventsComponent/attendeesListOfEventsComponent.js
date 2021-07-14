import { LightningElement, track, wire, api } from 'lwc';
import upcomingEvents from "@salesforce/apex/AttendeesListOfEvents.upcomingEvents";
import pastEvents from "@salesforce/apex/AttendeesListOfEvents.pastEvents";

export default class AttendeeDetails extends LightningElement {
    @api recordId;
    @track eventUpcomingCol = [
        {
            label: 'Name',
            fieldName: 'Name',
            type: 'text',
            sortable: true
        },
        {
            label: 'Location',
            fieldName: 'Location__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Start Date',
            fieldName: 'Start__c',
            type: 'date'
        },
        {
            label: 'No. of People Attending',
            fieldName: 'People_Attending',
            type: 'integer'
        }
    ];
    @track eventPastCol = [
        {
            label: 'Name',
            fieldName: 'Name',
            type: 'text',
            sortable: true
        },
        {
            label: 'Location',
            fieldName: 'Location__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Start Date',
            fieldName: 'Start__c',
            type: 'date'
        },
        {
            label: 'End Date',
            fieldName: 'End__c',
            type: 'date'
        }
    ];

    @track error;
    @track upcomingEventsList;
    @wire(upcomingEvents, {attendeeId : '$recordId'}) wiredUpcomingEvents({error,data}){
        if(data){
        this.upcomingEventsList = data;
        this.error = undefined;
        }else if(error){
        this.error = error;
        this.upcomingEventsList = undefined;
        }
    }

    @track pastEventsList;
    @wire(pastEvents, {attendeeId : '$recordId'}) wiredPastEvents({error,data}){
        if(data){
        this.pastEventsList = data;
        this.error = undefined;
        }else if(error){    
        this.error = error;
        this.pastEventsList = undefined;
        }
    }


    @wire (upcomingEvents,{attendeeId : '$recordId'}) wiredUpcomingAtnId({error,data}){
        var returnUpcomingOptions = [];
        if(data){
                data.forEach(ele => {
                    var loc;
                    if(ele.Event__r.Location_Address_Book__r){
                        loc = ele.Event__r.Location_Address_Book__r.Name;
                    }else{
                        loc = 'This is Virtual';
                    }
                returnUpcomingOptions.push({Name:ele.Event__r.Name, Location__c:loc, Start__c:ele.Event__r.Start__c, People_Attending:ele.Event__r.People_Attending__c});
        }); 
      this.upcomingEventsList = returnUpcomingOptions; 
      }
    }

    
    @wire (pastEvents,{attendeeId : '$recordId'}) wiredPastAtnId({error,data}){
        var returnPastOptions = [];
        if(data){
                data.forEach(ele => {
                    var loc;
                    if(ele.Event__r.Location_Address_Book__r){
                        loc = ele.Event__r.Location_Address_Book__r.Name;
                    }else{
                        loc = 'This is Virtual';
                    }
                returnPastOptions.push({Name:ele.Event__r.Name, Location__c:loc, Start__c:ele.Event__r.Start__c, End__c:ele.Event__r.End__c});
        }); 
      this.pastEventsList = returnPastOptions;
      }
    }
}