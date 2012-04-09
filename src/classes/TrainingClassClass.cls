public with sharing class TrainingClassClass {

  public static List<Training_Class__c> FindAllById(Set<Id> ids) {
   
  return [SELECT Id
                ,Training_Status__c
                ,Date_of_Last_Status__c
           FROM Training_Class__c
          WHERE Id IN :ids];
  }
}