@IsTest
private class WorkflowObjectPrototypeTest {

    @IsTest
    static void gettersTest() {
        if (TestConfigurationDao.isNotLowScope()) return;

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);
        MeetingMember__c meetingMember = TestUtils.createMeetingSpeaker('test', meeting.Id, false);

        //When
        Test.startTest();
        WorkflowObjectPrototype objectPrototype = new WorkflowObjectPrototype(
                meetingMember,
                'Speaker',
                meeting.Id
        );
        Test.stopTest();

        //Then
        System.assertEquals(meetingMember.getSObjectType(), objectPrototype.getPrototypeSObjectType());
        System.assertEquals(meetingMember.getSObjectType().getDescribe().getName(), objectPrototype.getPrototypeSObjectName());
        System.assertEquals('Speaker', objectPrototype.getRecordTypeDeveloperName());
        System.assertEquals(meeting.Id, objectPrototype.getParentObjectId());

    }

    @IsTest
    static void equalsTest() {
        if (TestConfigurationDao.isNotLowScope()) return;

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);
        MeetingMember__c meetingMember = TestUtils.createMeetingSpeaker('test', meeting.Id, false);

        //When
        Test.startTest();
        WorkflowObjectPrototype meetingMemberPrototype = new WorkflowObjectPrototype(
                meetingMember,
                'Speaker',
                meeting.Id
        );
        WorkflowObjectPrototype meetingMemberPrototype2 = new WorkflowObjectPrototype(
                meetingMember,
                'Speaker',
                meeting.Id
        );
        WorkflowObjectPrototype meetingPrototype = new WorkflowObjectPrototype(
                meeting,
                'Speaker_Meeting',
                meeting.Id
        );
        WorkflowObjectPrototype meetingPrototypeNoRecordType = new WorkflowObjectPrototype(
                meeting,
                meeting.Id
        );
        Test.stopTest();

        //Then
        System.assert(meetingMemberPrototype.equals(meetingMemberPrototype));
        System.assert(meetingMemberPrototype.equals(meetingMemberPrototype2));

        System.assertEquals(meetingMemberPrototype.hashCode(), meetingMemberPrototype.hashCode());
        System.assertEquals(meetingMemberPrototype.hashCode(), meetingMemberPrototype2.hashCode());

        System.assert(!meetingMemberPrototype.equals(meetingPrototype));
        System.assert(!meetingMemberPrototype2.equals(null));
        System.assert(!meetingPrototype.equals(meetingPrototypeNoRecordType));
    }
}