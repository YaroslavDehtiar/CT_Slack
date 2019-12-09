@IsTest
private class WorkflowPathOfflineAssociationSrvcTest {

    private static final String MEETING_SOBJECT_NAME = Meeting__c.SObjectType.getDescribe().getName();
    private static final String PRODUCT_SOBJECT_NAME = Product__c.SObjectType.getDescribe().getName();

    @IsTest
    static void testSyncObjectWorkflowPathAssociations() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final Integer COUNT_OF_OBJECT = 10;

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        List<Product__c> testProducts = new List<Product__c>();

        for (Integer i = 0; i < COUNT_OF_OBJECT; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            meeting.OfflineUniqueId__c = 'meeting'+i;
            testMeetings.add(meeting);

            Product__c product = TestUtils.createProduct('Product',false);
            product.OfflineUniqueId__c = 'product'+i;
            testProducts.add(product);
        }

        insert testMeetings;
        insert testProducts;

        List<ObjectWorkflowPathAssociation__c> associations = new List<ObjectWorkflowPathAssociation__c>();
        for (Integer i = 0; i < COUNT_OF_OBJECT; i++) {
            Meeting__c meeting = testMeetings.get(i);
            Product__c product = testProducts.get(i);

            associations.add(
                    new ObjectWorkflowPathAssociation__c(
                            ObjectOfflineId__c = meeting.OfflineUniqueId__c
                            , ObjectName__c = MEETING_SOBJECT_NAME
                    )
            );
            associations.add(
                    new ObjectWorkflowPathAssociation__c(
                            ObjectOfflineId__c = product.OfflineUniqueId__c
                            , ObjectName__c = PRODUCT_SOBJECT_NAME
                    )
            );
        }

        //When
        WorkflowPathOfflineAssociationService service = new WorkflowPathOfflineAssociationService();
        service.syncObjectWorkflowPathAssociations(associations);

        //Then
        List<ObjectWorkflowPathAssociation__c> objectWorkflowPathAssociations = getObjectWorkflowPathAssociations();
        Map<Id, Meeting__c> meetingsByIds = new Map<Id, Meeting__c>(testMeetings);
        Map<Id, Product__c> productsByIds = new Map<Id, Product__c>(testProducts);

        for (ObjectWorkflowPathAssociation__c record: objectWorkflowPathAssociations){
            if (record.ObjectName__c == MEETING_SOBJECT_NAME) {
                System.assert(meetingsByIds.containsKey(record.ObjectRecordID__c));
            } else if (record.ObjectName__c == PRODUCT_SOBJECT_NAME) {
                System.assert(productsByIds.containsKey(record.ObjectRecordID__c));
            }
        }
    }

    private static List<ObjectWorkflowPathAssociation__c> getObjectWorkflowPathAssociations() {
        return [SELECT Id, ObjectName__c, ObjectRecordID__c FROM ObjectWorkflowPathAssociation__c];
    }
}