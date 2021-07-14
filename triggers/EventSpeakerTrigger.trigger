trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update) {
    if(trigger.isBefore && (trigger.isInsert||trigger.isUpdate)){
        EventSpeakerTrigger.getNamesFromEventSpeaker(trigger.new);
    }    
}