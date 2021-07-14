public class UpdateEventBatch implements Database.Batchable<sObject> {
	
        public Database.QueryLocator start(Database.BatchableContext batchContext){
            String Query = 'Select Id, Name From Event__c Where Live__c = false AND Status__c != \'Completed\' AND End__c < LAST_N_MONTHS:4';
            return Database.getQueryLocator(Query);
        }
        
        public void execute(Database.BatchableContext bc, List<Event__c> eventList ){
                List<Event__c> updatedEventList = new List<Event__c>();
                for(Event__c event: eventList){
                    event.Status__c = 'Deleted';
                    updatedEventList.add(event);
                }
                update updatedEventList;
            
        }


        public void finish(Database.BatchableContext BC){
            
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                TotalJobItems, CreatedBy.Email
                                FROM AsyncApexJob WHERE Id =
                                :BC.getJobId()];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String userName = UserInfo.getUserName();
            User activeUser = [Select Name,Email From User where Username = : userName limit 1];
            String userEmail = activeUser.Email;
            String userWholeName = activeUser.Name;
            
            
            mail.setSubject('Batch Processing Completed');
            List<String> toAddress = new List<String>();
            toAddress.add(userEmail);
            mail.setToAddresses( toAddress );
            mail.setSenderDisplayName(userWholeName);
            
            mail.setHtmlBody('The batch Apex job processed ' + a.TotalJobItems +
            ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         }
    }