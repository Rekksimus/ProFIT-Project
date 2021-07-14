@isTest
private class EventSpeakerTrigger_Test {
    
    Static Id createTestEventID(){
        Event__c evt = new Event__c();
        evt.Name = 'Test Event';
        evt.Live__c = true;
        evt.Start__c = datetime.newInstance(2021, 6, 27, 19, 30, 0);
        evt.End__c = datetime.newInstance(2021, 6, 28, 20, 30, 0);
        insert evt;
        return evt.Id;
    }
    Static Id createTestDupEventID(){
      Event__c evt = new Event__c();
      evt.Name = 'Test Dup Event';
      evt.Live__c = true;
      evt.Start__c = datetime.newInstance(2021, 6, 29, 19, 30, 0);
      evt.End__c = datetime.newInstance(2021, 6, 30, 20, 30, 0);
      insert evt;
      return evt.Id;
    }
    Static Id createSpeakerID(){
      Speaker__c spk = new Speaker__c();
      spk.Name = 'Test Speaker';
      insert spk;
      return spk.Id;
    }

        @IsTest
      Static void checkEventEspeaker(){
        Test.startTest();

        try{
          String spk = createSpeakerID();

        Event_Speaker__c eS = new Event_Speaker__c();
        //Field Names
        //Create a new data to object
        eS.Name = 'Test Event-Speaker';
        eS.Event__c = createTestEventID();
        eS.Speaker__c = spk;
        
        insert eS;
        
        Event_Speaker__c eSD = new Event_Speaker__c();
        eSD.Name = 'Test Dup Event-Speaker';
        eSD.Event__c = createTestEventID();
        eSD.Speaker__c = spk;
        
        insert eSD;

        

        
        Test.stopTest();
        Event_Speaker__c retrievedES = [Select Name from Event_Speaker__c where Name =: eSD.Name];
        System.assertEquals('Test Dup Event-Speaker',retrievedES.Name);
        
        }
        catch (Exception ex){
          System.debug('Get Exception: '+ex.getMessage());
        }
        
      }

    
}