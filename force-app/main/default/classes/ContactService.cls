public with sharing class ContactService {
    public static void updateContactName(Id contactId, String firstName, String lastName) {

        if (contactId == null) {
            throw new IllegalArgumentException('Contact Id cannot be null.');
        }

        Contact con = [
            SELECT Id, FirstName, LastName
            FROM Contact
            WHERE Id = :contactId
            LIMIT 1
        ];

        con.FirstName = firstName;
        con.LastName = lastName;

        update con;
    }
}