/**
 * @description Class to test the correct behaviour of enqueueing the queueable job and creating the platform event. 
 */
@IsTest
public with sharing class GetBookDataTest {
    /**
     * @description Method to test if the GetBookDataService class correctly enqueues the job to fetch book data.
     */
    @IsTest
    static void testEnqueuingGetBookData() {
        Test.setMock(HttpCalloutMock.class, new BookDataCalloutMock());

        Test.startTest();
        String jobId = GetBookDataService.enqueueGetBookData();
        Test.stopTest();

        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE Id = :jobId];
        Assert.areEqual(1, jobs.size(), 'Queueable job has not been started.');
    }

    /**
     * @description Method to test the correct creation of the platform event containing the book data. Callout is mocked by BookDataCalloutMock class
     * and the expectecBookList displays the expected result given the input in the mock class.
     */
    @IsTest
    static void testPublishMostPublishedBooksEvent() {
        String expectedBookList = 
            '[{"Edition":1200000,"Publisher":"Addison-Wesley","Author":"Robert C. Martin","Title":"Clean Code"},'
            + '{"Edition":1000000,"Publisher":"O\'Reilly Media","Author":"Eric Freeman","Title":"Head First Design Patterns"},'
            + '{"Edition":900000,"Publisher":"Addison-Wesley","Author":"Martin Fowler","Title":"Refactoring: Improving the Design of Existing Code"},'
            + '{"Edition":750000,"Publisher":"Manning Publications","Author":"Andrew Hunt, David Thomas","Title":"The Pragmatic Programmer"}]';

        Test.setMock(HttpCalloutMock.class, new BookDataCalloutMock());

        Test.startTest();
        System.enqueueJob(new GetBookDataQueueable());
        Test.stopTest();

        Assert.areEqual(1, GetBookDataTestHelper.events.size(), 'One event should have been created.');
        Assert.areEqual(expectedBookList, GetBookDataTestHelper.events[0].Books__c, 'Wrong list of books has been created.');
        Assert.isNull(GetBookDataTestHelper.events[0].Error__c, 'Error field should have been empty.');
    }

    /**
     * @description Given a list of three books, test that they are ordered correctly by edition.
     */
    @IsTest
    static void testSortingBooksByEdition() {
        Map<String, Object> bookWithLowerEdition = new Map<String, Object> {
            'Publisher' => 'Publisher1',
            'Edition' => 1000,
            'Author' => 'Author1',
            'Title' => 'Title1'
        };

        Map<String, Object> bookWithHigherEdition = new Map<String, Object> {
            'Publisher' => 'Publisher2',
            'Edition' => 2000,
            'Author' => 'Author2',
            'Title' => 'Title2'
        };

        Map<String, Object> bookWithMediumEdition = new Map<String, Object> {
            'Publisher' => 'Publisher3',
            'Edition' => 1500,
            'Author' => 'Author3',
            'Title' => 'Title3'
        };

        List<Map<String,Object>> books = new List<Map<String,Object>> {
            bookWithLowerEdition,
            bookWithHigherEdition,
            bookWithMediumEdition
        };

        books.sort(new EditionComparator());

        Assert.areEqual(bookWithHigherEdition, books[0], 'Book with higher edition should have been the first element');
        Assert.areEqual(bookWithMediumEdition, books[1], 'Book with medium edition should have been the second element');
        Assert.areEqual(bookWithLowerEdition, books[2], 'Book with higher edition should have been the third element');
    }
}