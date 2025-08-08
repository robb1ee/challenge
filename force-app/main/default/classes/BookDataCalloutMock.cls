/**
 * @description Class to mock the callout to fetch book data for testing purposes.
 */
@IsTest
global class BookDataCalloutMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody(
            '[{"Publisher":"O\'Reilly Media",'
            + '"Books":[{"Author":"Eric Freeman","Title":"Head First Design Patterns","Edition":1000000},'
            + '{"Author":"David Flanagan","Title":"JavaScript: The Definitive Guide","Edition":500000},'
            + '{"Author":"Mark Lutz","Title":"Learning Python","Edition":500000}]},'
            + '{"Publisher":"Manning Publications",'
            + '"Books":[{"Author":"Andrew Hunt, David Thomas","Title":"The Pragmatic Programmer","Edition":750000},'
            + '{"Author":"Bruce Eckel","Title":"Thinking in Java","Edition":300000}]},'
            + '{"Publisher":"Addison-Wesley",'
            + '"Books":[{"Author":"Robert C. Martin","Title":"Clean Code","Edition":1200000},'
            + '{"Author":"Martin Fowler","Title":"Refactoring: Improving the Design of Existing Code","Edition":900000},'
            + '{"Author":"Kent Beck","Title":"Test Driven Development: By Example","Edition":450000},'
            + '{"Author":"Don Norman","Title":"The Design of Everyday Things","Edition":600000}]}]'
        );
        response.setStatusCode(200);
        return response;
    }
}