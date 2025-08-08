/**
 * @description Helper class to save data from MostPublishedBooks events created by tests
 */
public with sharing class GetBookDataTestHelper {
    @TestVisible
    public static List<MostPublishedBooks__e> events = new List<MostPublishedBooks__e>();
}