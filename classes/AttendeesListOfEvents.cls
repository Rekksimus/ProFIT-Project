public with sharing class AttendeesListOfEvents {
   @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> upcomingEvents(String attendeeId) {
        List<Event_Attendee__c> upcomingEventLists = [SELECT Id, Name, Event__c, Event__r.Location_Address_Book__c, Event__r.Location_Address_Book__r.Name, Event__r.Name, Event__r.Start__c, Event__r.End__c, Event__r.People_Attending__c FROM Event_Attendee__c WHERE Attendee__c = :attendeeId AND Event__r.Start__c >= today AND Event__r.Live__c = true];
        return upcomingEventLists;

    }

    @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> pastEvents(String attendeeId) {
        List<Event_Attendee__c> pastEventLists = [ SELECT Id, Name, Event__c, Event__r.Location_Address_Book__c, Event__r.Location_Address_Book__r.Name, Event__r.Name, Event__r.Start__c, Event__r.End__c FROM Event_Attendee__c WHERE Attendee__c = :attendeeId AND Event__r.Start__c < today];
        return pastEventLists;
    }
  }