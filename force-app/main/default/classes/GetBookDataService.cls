/**
 * @description Class to enqueue the queueable job to fetch book data.
 */
public with sharing class GetBookDataService {
    /**
     * @description Enqueue the job. Can be called from LWCs
     */
    @AuraEnabled
    public static String enqueueGetBookData() {
        return System.enqueueJob(new GetBookDataQueueable());
    }
}