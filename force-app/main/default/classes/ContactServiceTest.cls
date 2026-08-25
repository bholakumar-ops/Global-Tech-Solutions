@isTest
private class ContactServiceTest {

    @isTest
    static void testUpdateContactName() {

        // Create Account
        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        // Create Contact
        Contact con = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            AccountId = acc.Id
        );
        insert con;
        
        Test.startTest();

        ContactService.updateContactName(
            con.Id,
            'Jane',
            'Smith'
        );

        Test.stopTest();
        
        Contact updatedCon = [
            SELECT FirstName, LastName
            FROM Contact
            WHERE Id = :con.Id
        ];

        System.assertEquals('Jane', updatedCon.FirstName);
        System.assertEquals('Smith', updatedCon.LastName);
    }

    @isTest
    static void testUpdateContactNameWithNullId() {
        
        Test.startTest();

        try {
            ContactService.updateContactName(
                null,
                'Jane',
                'Smith'
            );
            System.assert(false, 'Exception should have been thrown.');
        } catch (IllegalArgumentException ex) {
            System.assertEquals(
                'Contact Id cannot be null.',
                ex.getMessage()
            );
        }

        Test.stopTest();
        
    }
}