trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        EventAttendeeTrigger.sendAttendeeEmail(trigger.new);
    }
}