/**
 * @description Class to mock a failed callout to fetch book data for testing purposes.
 */
@IsTest
global class BookDataFailedCalloutMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody('failed');
        response.setStatusCode(500);
        return response;
    }
}