/**
 * @description Unit tests for StringValidator.
 */
@IsTest
private class StringValidatorTest {
    /**
     * @description Verifies validation of non-blank and blank strings. 
     */
    @IsTest
    static void testIsValid() {
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() WITH USER_MODE];
        System.runAs(currentUser) {
            System.assertEquals(true, StringValidator.isValid('Salesforce'), 'A non-blank string should be valid.');
            System.assertEquals(false, StringValidator.isValid('   '), 'A blank string should not be valid.');
        }
    }
}