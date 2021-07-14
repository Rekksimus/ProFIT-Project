@isTest
public with sharing class LocationZIpVerifierCallout_Test {
    public static testMethod void testZip(){

        Location__c loc = new Location__c(
            Name = '3301 South Greenfield Rd',
            Street__c = '3301 South Greenfield Rd',
            City__c = 'Gilbert',
            State__c = 'AZ',
            Postal_Code__c = '85297',
            Country__c = 'Philippines'
        );
        insert loc;



        try{
            Test.setMock(HttpCalloutMock.class, new ZipCalloutMock());
            Test.startTest();

            LocationZipVerifierCallout.verifyZip(''+loc.Id+'');
            
            Test.stopTest();
        }catch(Exception ex){

        }
        Location__c retrievedZipVerified = [Select Is_Zip_correct__c from Location__c where Id =: loc.Id];
        System.assertEquals(true,retrievedZipVerified.Is_Zip_correct__c);

    }
    public static testMethod void testLoc(){
        Location__c loc = new Location__c(
            Name = '3301 South Greenfield Rd',
            Street__c = '3301 South Greenfield Rd',
            City__c = 'Gilbert',
            State__c = 'AZ',
            Postal_Code__c = '85297',
            Country__c = 'Philippines'
        );
        insert loc;

        try{
            Test.setMock(HttpCalloutMock.class, new LocationCalloutMock());
            Test.startTest();

            LocationZipVerifierCallout.verifyLocation(''+loc.Id+'');
            
            Test.stopTest();
        }catch(Exception ex){

        }
        Location__c retrievedLocVerified = [Select Ver__c from Location__c where Id =: loc.Id];
        System.assertEquals(true,retrievedLocVerified.Ver__c);
    }

}