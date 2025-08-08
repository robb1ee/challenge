/**
 * @description Trigger for MostPublishedBooks platform events. Does not contain any business logic and is only used
 * to save events for testing purposes.
 */
trigger MostPublishedBooksEventTrigger on MostPublishedBooks__e (after insert) {
    if (Test.isRunningTest()) {
        GetBookDataTestHelper.events.addAll(Trigger.new);
    }
}