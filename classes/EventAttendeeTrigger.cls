public class EventAttendeeTrigger {

    public static void sendAttendeeEmail(List<Event_Attendee__c> newRecordList ) {
        
        Set<Id> attendeesIdsSet = new Set<Id>();
        Set<Id> eventIdsSet = new Set<Id>();
        
        for(Event_Attendee__c evtAtt : newRecordList){
            attendeesIdsSet.add(evtAtt.Attendee__c);
            eventIdsSet.add(evtAtt.Event__c);
        }
        
        Map<Id,Attendee__c> attendeeMap = new Map<Id,Attendee__c>( 
            [Select Id, Name, Email__c From Attendee__c WHERE  Id IN : attendeesIdsSet]
        );
        Map<Id, Event__c> eventMap = new Map<Id, Event__c > ([Select Id, Name, Start__c, Event_Organizer__c, Event_Type__c, Event_Organizer__r.Name, Location_Address_Book__c , Location_Address_Book__r.Name, Location_Address_Book__r.City__c, Location_Address_Book__r.State__c, Location_Address_Book__r.Country__c, Location_Address_Book__r.Postal_Code__c, Location_Address_Book__r.Street__c FROM Event__c  WHERE ID IN: eventIdsSet]);
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        for(Event_Attendee__c evtAtt : newRecordList){
            
            Attendee__c att = attendeeMap.get(evtAtt.Attendee__c);
            Event__c evt = eventMap.get(evtAtt.Event__c);
            
            if(evt.Event_Type__c == 'Virtual'){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                mail.setSubject('Pass for the '+evt.Name);
                List<String> toAddress = new List<String>();
                toAddress.add(att.Email__c);
                mail.setToAddresses( toAddress );
                mail.setSenderDisplayName(evt.Event_Organizer__r.Name);
                
                String virtualLink = 'https://meet.google.com/';
                String hrefForVirtualLink = '<a href="'+virtualLink+'"'+'target="_blank">GMeet Link</a>';
                String emailBody = 'Hello '+ att.Name + ',<br/><br/>'+
                    'Your registration for '+evt.Name+' that will happen on '+
                    evt.Start__c+' has been confirmed. This event will be held at Google Meet.<br/>We are excited to have you!'+ 
                    ' See you at the event. <br/>'+
                    'You can find the link for the said event via this link here: '+hrefForVirtualLink+'.<br/><br/><br/>'+
                    'Thanks,<br/>'+evt.Event_Organizer__r.Name;
                
                mail.setHtmlBody(emailBody);
                emailList.add(mail);
                
            }else{
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                mail.setSubject('Pass for the '+evt.Name);
                List<String> toAddress = new List<String>();
                toAddress.add(att.Email__c);
                mail.setToAddresses( toAddress );
                mail.setSenderDisplayName(evt.Event_Organizer__r.Name);
                
                String location = 'https://www.google.com/maps/place/'+evt.Location_Address_Book__r.Street__c+' '+evt.Location_Address_Book__r.City__c+' '
                    +evt.Location_Address_Book__r.State__c+' '+
                    evt.Location_Address_Book__r.Country__c+' '+evt.Location_Address_Book__r.Postal_Code__c;
                
                String hrefForLocation = '<a href="'+location+'"'+'target="_blank">GMaps Link</a>';
                
                String emailBody = 'Hello '+ att.Name + ',<br/><br/>'+
                    'Your registration for '+evt.Name+' that will happen on '+
                    evt.Start__c+' has been confirmed. This will be held at '+evt.Location_Address_Book__r.Name
                    +'.<br/>We are excited to have you!'+ 
                    ' See you at the event. <br/>'+
                    'You can find the location for the said event via Google Maps here: '+hrefForLocation+'.<br/><br/><br/>'+
                    'Thanks,<br/>'+evt.Event_Organizer__r.Name;
                
                mail.setHtmlBody(emailBody);
                emailList.add(mail);
            }
        }
        
        try{
            
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(emailList, false);
            for(Messaging.SendEmailResult email : results){
                System.debug(email.isSuccess());
                if(!email.isSuccess()){
                    List<Messaging.SendEmailError> errors = email.getErrors();
                }
            }  
        }catch(System.Exception ex){
            System.debug(' ' + ex);
        }
    }
}