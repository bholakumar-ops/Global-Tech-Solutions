/**
 * @description Provides validation methods for text values. 
 */
public with sharing class StringValidator {
    /**
     * @description Checks whether the supplied value contains meaningful text.
     * @param value Text value to validate.
     * @return True when the value is not blank; otherwise false.
     */
    public static Boolean isValid(String value) {
        return String.isNotBlank(value);
    }
}