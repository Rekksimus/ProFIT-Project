@isTest
public class EventAttendeeTrigger_Test {
    
    @testSetup
    public static void createTestID(){
        
        Event_Organizer__c  org = new Event_Organizer__c (
            Name = 'Test Organizer',
            Phone_Number__c = '9807654321',
            Email__c = 'testorg@email.com',
            Alt_Phone_Number__c  = '6627323',
            Alt_Email__c ='testorganizer@email.com'
        );
        insert org;
        
        Event__c event = new Event__c(
            Name = 'Test Event',
            Event_Organizer__c  = org.Id,
            Event_Type__c = 'Virtual',
            Frequency__c  = 'Daily',
            Max_Seats__c  = 49,
            Recurring__c = true,
            Live__c = true,
            Start__c = System.now(),
            End__c  = System.now().addDays(3)
        );
        insert event;
        Attendee__c att = new Attendee__c(
            Name = 'Test Attendee',
            Email__c = 'testatt@gmail.com',
            Phone_Number__c = '232323'
        );
        insert att;
        
        Event_Attendee__c evtAtt = new Event_Attendee__c(Event__c = event.Id, Attendee__c = att.Id);
        insert evtAtt;
    }
    
    @IsTest
    static void testEmail(){
        
        Test.startTest();
        createTestID();
        List <Event_Attendee__c> evtAtt = [Select Id, Name, Attendee__c, Event__c from Event_Attendee__c];
        EventAttendeeTrigger.sendAttendeeEmail(evtAtt);
        Test.stopTest();
        
    }
}