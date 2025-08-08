/**
 * @description Queueable class that performs a callout to fetch book data and publish a platform event.
 */
public with sharing class GetBookDataQueueable implements Queueable, Database.AllowsCallouts {
    /**
     * @description Execution of the queueable. Fetches data via callout, filters and sorts the returned data and publishes a platform event
     * containing a list of most published books (i.e. with an edition of more than 600.000).
     */
    public static void execute(QueueableContext context) {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://eop0fqfuwjjx6lx.m.pipedream.net');
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            List<Map<String, Object>> mostPublishedBooks = new List<Map<String, Object>>();

            if (response.getStatusCode() == 200) {
                List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
                for (Object booksByPublisher : results) {
                    Map<String, Object> data = (Map<String, Object>) booksByPublisher;
                    Object publisher = data.get('Publisher');
                    List<Object> books = (List<Object>) data.get('Books');

                    for (Object book : books) {
                        Map<String, Object> bookData = (Map<String, Object>) book;
                        if ((Integer) bookData.get('Edition') > 600000) {
                            mostPublishedBooks.add(
                                new Map<String, Object> {
                                    'Title' => bookData.get('Title'),
                                    'Author' => bookData.get('Author'),
                                    'Publisher' => publisher,
                                    'Edition' => bookData.get('Edition')
                                }
                            );
                        }
                    }
                }

                mostPublishedBooks.sort(new EditionComparator());

                EventBus.publish(
                    new MostPublishedBooks__e(
                        Books__c = JSON.serialize(mostPublishedBooks)
                    )
                );
            } else {
                EventBus.publish(
                    new MostPublishedBooks__e(
                        Error__c = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus()
                    )
                );
            }

        } catch (Exception e) {
            EventBus.publish(
                new MostPublishedBooks__e(
                    Error__c = 'Error: ' + e.getMessage()
                )
            );
        }
    }

    /**
     * @description Custom comparator, given two books they are sorted by edition in descending order.
     */
    public class EditionComparator implements Comparator<Map<String, Object>> {
        public Integer compare(Map<String, Object> firstBook, Map<String, Object> secondBook) {
            Integer edA = (Integer) firstBook.get('Edition');
            Integer edB = (Integer) secondBook.get('Edition');

            if (edA == edB) return 0;

            return edA > edB ? -1 : 1;
        }
    }
}