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