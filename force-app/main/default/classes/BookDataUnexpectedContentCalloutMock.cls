/**
 * @description Class to mock a callout to fetch book data for testing purposes.
 * Response contains an unexpected content which results in a failure while processing.
 */
@IsTest
global class BookDataUnexpectedContentCalloutMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody('["Unexpected Content]');
        response.setStatusCode(200);
        return response;
    }
}