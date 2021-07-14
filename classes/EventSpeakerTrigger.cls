public with sharing class EventSpeakerTrigger {
    public static void getNamesFromEventSpeaker(List<Event_Speaker__c> ESList)
    {
        try{
    
            Set<Id> eventId = new Set<Id>();
            Set<Id> eventSpeakerId = new Set<Id>();

            for(Event_Speaker__c evntSpkr : ESList){
                eventId.add(evntSpkr.Event__c);
                eventSpeakerId.add(evntSpkr.Speaker__c);
            }
            
            Map<Id, DateTime> startrequestedEvents = new Map<Id, DateTime>();
            Map<Id, DateTime> endrequestedEvents = new Map<Id, DateTime>();

            List<Event__c> relatedEventList = [Select Id, Name,Start__c,End__c From Event__c 
            Where Id IN: eventId];

            for(Event__c evt : relatedEventList ){
                startrequestedEvents.put(evt.Id, evt.Start__c);
                endrequestedEvents.put(evt.Id, evt.End__c);
            
            }

            List<Event_Speaker__c> relatedEventSpeakerList = [ SELECT Id, Event__c, Speaker__c,Event__r.Start__c,Event__r.End__c From Event_Speaker__c
            WHERE Speaker__c IN : eventSpeakerId];

        for(Event_Speaker__c evntSpkr : ESList){

            DateTime startTime = startrequestedEvents.get(evntSpkr.Event__c);
            DateTime endTime = endrequestedEvents.get(evntSpkr.Event__c);


                for(Event_Speaker__c rS: relatedEventSpeakerList){
                    if((rS.Event__r.Start__c < endTime && rS.Event__r.End__c > endTime)||(rS.Event__r.Start__c < startTime && rS.Event__r.End__c > startTime)||(rS.Event__r.Start__c >= startTime && rS.Event__r.End__c <= endTime)){
                        evntSpkr.Speaker__c.addError('The Speaker has already an event!');
                    }

                }
        }
        }catch(Exception e){
            System.debug('Exceptions Handled: ' + e.getMessage());
        }
    }
}
