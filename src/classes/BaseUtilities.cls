public class BaseUtilities {

    public static final String PROFILE_NAME_ADMIN = 'OCE Admin';

    // symbols
    public static final String EMPTY = '';
    public static final String SPACE = ' ';
    public static final String DOT = '.';
    public static final String SEMICOLON = ';';
    public static final String COMMA = ',';
    public static final String COMMA_SPACE = COMMA + SPACE;

    public static final String HYPHEN = '-';

    public static final String UNDERSCORE = '_';
    public static final String DOUBLE_UNDERSCORE = UNDERSCORE + UNDERSCORE;

    public static final String VBAR = '|';
    public static final String VBAR_SURROUNDED_BY_SPACES = SPACE + VBAR + SPACE;

    public static final String SINGLE_QUOTE = '\'';

    public static final String ELLIPSIS = '...';

    public static final String NEW_LINE = '\r\n';

    public static final Decimal ZERO = 0;
    public static final Decimal ONE = 1;


    // reg exps
    public static final String DOT_REGEXP = '\\.';
    public static final String NEW_LINE_REGEXP = '\\r?\\n';

    // reg options
    public static final String CASE_INSENSITIVE_REGEXP_OPTION_ON = '(?i)';

    // DML operations
    public static final String READ = 'Read';
    public static final String EDIT = 'Edit';
    public static final String FULLACCESS = 'All';

    /**
     * Converts a list of strings to lower case.
     * @param a list to convert.
     * @return converted list.
     */
    public static List<String> listToLowerCase(List<String> strings){
        //optimized for(String str : strings)
        for (Integer i = 0, size = strings.size(); i < size; ++i) {
            strings[i] = strings[i].toLowerCase();
        }
        return strings;
    }

    /**
     * Converts a list of strings to upper case.
     * @param a list to convert.
     * @return converted list.
     */
    public static List<String> listToUpperCase(List<String> strings){
        //optimized for(String str : strings)
        for (Integer i = 0, size = strings.size(); i < size; ++i) {
            strings[i] = strings[i].toUpperCase();
        }
        return strings;
    }

    /**
     * Return real null if string value equals to 'null'.
     * @value to be checked.
     * @retun null, if value equals to 'null'. Othewise, return value.
     */
    public static String resetIfNull(String value) {
        return 'null' == value ? null : value;
    }

    /**
    * Returns the unique values for a given field in a list of records. Null is not included.
    * @param objects the list of records.
    * @param field values from this field will be returned.
    * @return set of values; no null.
    */
    public static Set<String> getFieldValues(SObject[] objects, SObjectField field) {
        return getFieldValues(objects, field.getDescribe().getName());
    }

    /**
    * Overload that accepts field as a string.
    */
    public static Set<String> getFieldValues(SObject[] objects, String field) {
        Set<String> result = new Set<String>();
        if (null != objects) {
            for (Integer i = 0, size = objects.size(); i < size; ++i) {
                result.add(String.valueOf(objects[i].get(field)));
            }
            result.remove(null);
        }
        return result;
    }

    /**
    * Overload that accepts field as a string and has toUpper parameter.
    */
    public static Set<String> getFieldValues(SObject[] objects, String field, Boolean toUpper) {
        Set<String> result = new Set<String>();
        if (null != objects) {
            for (Integer i = 0, size = objects.size(); i < size; ++i) {
                String fieldValue = String.valueOf(objects[i].get(field));
                result.add(toUpper ? fieldValue.toUpperCase() : fieldValue.toLowerCase());
            }
            result.remove(null);
        }
        return result;
    }


    /**
     * Today's date
     */
    public static Date today {

        get {
            return today();
        }

    }


    /**
    * Return today's date, i.e. similar to System.today(), but it supports mocking in test scope
    */
    public static Date today() {

        return
                System.today()
                ;

    }

    /**
    * Split by punctuation
    */
    public static List<String> splitByPunctuation(String source) {

        List<String> values = new List<String>();


        if (isNotNullOrEmpty(source)) {

            values =
                    source.split(
                            '[\\s,;:]+'
                    )
                    ;

        }


        return values;

    }



    /**
    * Split multiselect value into separate options
    */
    public static List<String> splitMultiselectToOptions(String value) {

        List<String> options = new List<String>();


        if (isNotNullOrEmpty(value)) {

            options =
                    value.split(
                            SEMICOLON
                    )
                    ;

        }


        return options;

    }


    /**
    * Join separate options into multiselect value
    */
    public static String joinOptionsIntoMultiselect(List<String> options) {

        return
                String.join(
                        options,
                        SEMICOLON
                )
                ;

    }



    /**
    * Filter out nulls or blanks from list
    */
    public static List<String> filterOutNullsOrBlanks(List<String> inStrings) {

        List<String> outStrings = new List<String>();


        for (String inString : inStrings) {

            if (String.isNotBlank(inString)) {
                outStrings.add(inString);
            }

        }

        return outStrings;

    }



    /**
    * Convert list of strings to set
    */
    public static Set<String> toSet(List<String> listOfStrings) {

        Set<String> setOfStrings = new Set<String>();


        if (isNotNullOrEmpty(listOfStrings)) {

            setOfStrings.addAll(listOfStrings);

        }


        return setOfStrings;

    }



    /**
    * Convert list of ids to set
    */
    public static Set<Id> toSet(List<Id> listOfIds) {

        Set<Id> setOfIds = new Set<Id>();


        if (isNotNullOrEmpty(listOfIds)) {

            setOfIds.addAll(
                    listOfIds
            );

        }


        return setOfIds;

    }



    /**
    * Check if two incoming strings are equivalent (i.e. equal ignoring case, leading & trailing whitespaces)
    */
    public static Boolean isEquivalent(String operandOne, String operandTwo) {

        if (String.isBlank(operandOne) && String.isBlank(operandTwo)) {
            return true;
        }


        if (String.isBlank(operandOne) || String.isBlank(operandTwo)) {
            return false;
        }


        return
                operandOne.trim().equalsIgnoreCase(operandTwo.trim())
                ;

    }



    /**
    * Check if two incoming list of sobjects are equivalent (i.e. both null or contain records with the same ids disregarding order)
    */
    public static Boolean isEquivalent(List<SObject> operandOne, List<SObject> operandTwo) {

        // consider null and empty list the same
        if (isNullOrEmpty(operandOne) && isNullOrEmpty(operandTwo)) {
            return true;
        }


        if (isNullOrEmpty(operandOne) || isNullOrEmpty(operandTwo)) {
            return false;
        }


        if (operandOne.size() <> operandTwo.size()) {
            return false;
        }


        return
                mapToIds(
                        operandOne
                )
                        ==
                        mapToIds(
                                operandTwo
                        )
                ;

    }



    /**
    * Check if incoming object is null or empty (supports string & lists)
    */
    public static Boolean isNullOrEmpty(Object obj) {

        return
                obj == null
                        ||
                        (
                                obj instanceof String
                                        &&
                                        String.isBlank( (String)obj )
                        )
                        ||
                        (
                                obj instanceof List<Object>
                                        &&
                                        ((List<Object>)obj).isEmpty()
                        )
                ;

    }


    /**
    * Check if incoming set of ids is null or empty
    */
    public static Boolean isNullOrEmpty(Set<Id> ids) {

        return
                ids == null
                        ||
                        ids.isEmpty()
                ;

    }


    /**
    * Check if incoming set of ids is not null or empty
    */
    public static Boolean isNotNullOrEmpty(Set<Id> ids) {

        return !isNullOrEmpty(ids);

    }


    /**
    * Check if incoming set of values is null or empty
    */
    public static Boolean isNullOrEmpty(Set<String> values) {

        return
                values == null
                        ||
                        values.isEmpty()
                ;

    }


    /**
    * Check if incoming set of values is not null or empty
    */
    public static Boolean isNotNullOrEmpty(Set<String> values) {

        return !isNullOrEmpty(values);

    }


    /**
    * Check if incoming map of ids to objects is null or empty
    */
    public static Boolean isNullOrEmpty(Map<Id, Object> idToObject) {

        return
                idToObject == null
                        ||
                        idToObject.size() == 0
                ;

    }


    /**
    * Check if incoming map of ids to objects is not null or empty
    */
    public static Boolean isNotNullOrEmpty(Map<Id, Object> idToObject) {

        return
                !isNullOrEmpty(
                        idToObject
                )
                ;

    }


    /**
    * Check if incoming object is not null or empty (supports string & lists)
    */
    public static Boolean isNotNullOrEmpty(Object obj) {

        return !isNullOrEmpty(obj);

    }


    /**
    * Assert condition and throw custom exception if not true.
    * This is a replacement of system assert method, cause it's not possible to catch thrown system exception.
    */
    public static void assert(Boolean condition, String message) {

        if (condition <> true) {

            throw
                    new CustomAssertException(
                            'Assertion Failed: ' + message
                    )
                    ;

        }

    }


    /**
    * Assert if objects match and throw custom exception if not true.
    * This is a replacement of system assert method, cause it's not possible to catch thrown system exception.
    */
    public static void assertEquals(Object expected, Object actual, String message) {

        if (expected <> actual) {

            throw
                    new CustomAssertException(
                            'Assertion Failed: ' + message + ': Expected: ' + expected + ' Actual: ' + actual
                    )
                    ;

        }

    }


    /**
    * Return empty string replacement in case of null source
    */
    public static String coalesce(String source) {

        return
                coalesce(
                        source,
                        EMPTY
                )
                ;

    }


    /**
    * Return provided replacement in case of null source
    */
    public static String coalesce(String source, String replacement) {

        return
                String.isBlank(source)
                        ?
                        replacement
                        :
                        source
                ;

    }


    /**
    * Return provided replacement in case of null source
    */
    public static Id coalesce(Id source, Id replacement) {

        return
                source == null
                        ?
                        replacement
                        :
                        source
                ;

    }


    /**
    * Return false replacement in case of null source
    */
    public static Boolean coalesce(Boolean source) {

        return
                source == null
                        ?
                        false
                        :
                        source
                ;

    }



    /**
    * Return provided replacement in case of null source
    */
    public static Boolean coalesce(Boolean source, Boolean replacement) {

        return
                source == null
                        ?
                        replacement
                        :
                        source
                ;

    }



    /**
     * Return provided replacement in case of null source
     */
    public static Integer coalesce(Integer source, Integer replacement) {

        return
                source == null
                        ?
                        replacement
                        :
                        source
                ;
    }



    /**
    * Return zero-number replacement in case of null source
    */
    public static Decimal coalesce(Decimal source) {

        return
                coalesce(
                        source,
                        ZERO
                )
                ;

    }



    /**
    * Return provided replacement in case of null source
    */
    public static Decimal coalesce(Decimal source, Decimal replacement) {

        return
                source == null
                        ?
                        replacement
                        :
                        source
                ;

    }



    /**
    * Convert incoming list into string using comma+space as default delimiter
    */
    public static String toString(List<String> values) {

        return
                toString(
                        values,
                        COMMA_SPACE
                )
                ;

    }


    /**
    * Convert incoming list into string using provided delimiter
    */
    public static String toString(List<String> values, String delimiter) {

        return
                String.join(
                        values,
                        delimiter
                )
                ;

    }


    /**
    * Map incoming list of sobjects to array of another sobjects using provided field name refering to related record
    */
    public static List<SObject> mapToSObjects(List<SObject> objects, String sobjectFieldName) {

        List<SObject> sobjects = new List<SObject>();


        if (isNotNullOrEmpty(objects)) {

            for (SObject obj : objects) {

                sobjects.add(
                        obj.getSObject(sobjectFieldName)
                );

            }

        }


        return sobjects;

    }


    /**
    * Map list of sobjects to set of ids using provided field name to fetch id
    */
    public static Set<Id> mapToIds(List<SObject> objects, String idFieldName) {

        Set<Id> ids = new Set<Id>();


        if (isNotNullOrEmpty(objects)) {

            for (SObject obj : objects) {

                ids.add(
                        (Id)
                                obj.get(idFieldName)
                );

            }

        }


        return ids;

    }


    /**
    * Map list of sobjects to set of ids
    */
    public static Set<Id> mapToIds(List<SObject> objects) {

        Set<Id> ids = new Set<Id>();


        if (isNotNullOrEmpty(objects)) {

            for (SObject obj : objects) {
                ids.add(obj.Id);
            }

        }


        return ids;

    }


    /**
    * Map list of sobjects to list of strings using provided field name
    */
    public static List<String> mapToStrings(List<SObject> objects, String textFieldName) {

        List<String> values = new List<String>();


        if (isNotNullOrEmpty(objects)) {

            for (SObject obj : objects) {

                values.add(
                        String.valueOf(
                                obj.get(textFieldName)
                        )
                );

            }

        }


        return values;

    }


    /**
    * Wipe id field (i.e. set value to null) for incoming sobject.
    */
//    public static SObject wipeId(SObject record) {
//
//        return
//                getFirstIfAny(
//                        wipeId(
//                                CollectionUtilities.asList(
//                                        record
//                                )
//                        )
//                )
//                ;
//
//    }


    /**
    * Wipe id field (i.e. set value to null) for all sobjects in incoming collections.
    */
//    public static List<SObject> wipeId(List<SObject> records) {
//
//        return
//                wipeField(
//                        records,
//                        ObjectUtilities.FIELD_NAME_ID
//                )
//                ;
//
//    }


    /**
    * Wipe field (i.e. set value to null) for all sobjects in incoming collections.
    */
    public static List<SObject> wipeField(List<SObject> records, String fieldName) {

        for (SObject record : records) {

            record.put(
                    fieldName,
                    null
            );

        }


        return records;

    }


    /**
    * Prepend provided prefix to specific text field for incoming sobject.
    */
    public static SObject prependToTextField(SObject record, String textFieldName, String prefix) {

        return
                getFirstIfAny(
                        prependToTextField(
                                CollectionUtilities.asList(record),
                                textFieldName,
                                prefix
                        )
                )
                ;

    }


    /**
    * Prepend provided prefix to specific text field for all sobjects in incoming collections.
    */
    public static List<SObject> prependToTextField(List<SObject> records, String textFieldName, String prefix) {

        for (SObject record : records) {

            record.put(
                    textFieldName,
                    (
                            prefix
                                    +
                                    coalesce(
                                            String.valueOf(
                                                    record.get(
                                                            textFieldName
                                                    )
                                            )
                                    )
                    )
            );

        }


        return records;

    }


    /**
    * Convert set of ids to list
    */
    public static List<Id> toList(Set<Id> setOfIds) {

        List<Id> listOfIds = new List<Id>();


        if (setOfIds <> null) {

            listOfIds.addAll(setOfIds);

        }


        return listOfIds;

    }


    /**
    * Convert set of values to list
    */
    public static List<String> toList(Set<String> setOfValues) {

        List<String> listOfValues = new List<String>();


        if (setOfValues <> null) {

            listOfValues.addAll(setOfValues);

        }


        return listOfValues;

    }


    /**
    * Check whether incoming source match to provided regex pattern
    */
    public static Boolean match(String source, Pattern pattern) {

        return
                pattern.matcher(source).find()
                ;

    }


    /**
    * Check if incoming string matches provided regular expression
    */
    public static Boolean match(String source, String regEx) {

        return
                Pattern.matches(
                        regEx,
                        coalesce(
                                source
                        )
                )
                ;

    }


    /**
    * Wrap incoming string into regex
    */
    public static String asRegex(String source) {

        return
                String.isBlank(source)
                        ?
                        EMPTY
                        :
                        Pattern.quote(
                                source
                        )
                ;

    }


    /**
    * Wrap incoming string into case-insensitive regex
    */
    public static String asCaseInsensitiveRegex(String source) {

        return
                String.isBlank(source)
                        ?
                        EMPTY
                        :
                        (
                                CASE_INSENSITIVE_REGEXP_OPTION_ON + asRegex(source)
                        )
                ;

    }


    /**
    * Fetch value from incoming source by provided regexp
    */
    public static String extract(String source, String regexp) {

        Matcher matcher =
                Pattern.compile(
                        regexp
                ).matcher(source)
        ;


        return
                matcher.find()
                        ?
                        matcher.group(1).trim()
                        :
                        null
                ;

    }


    /**
    * Parse number from incoming string.
    * Null is returned in case of error.
    */
    public static Integer parseNumber(String source) {

        if (String.isBlank(source)) {
            return null;
        }


        Integer result = null;


        try {

            result = Integer.valueOf(source);

        } catch (Exception exp) {
        }


        return result;

    }


    /**
    * Check whether provided field path segment referes to field on incoming sobject
    */
    public static Boolean isField(SObject source, String fieldPathSegment) {

        return
                source.getSObjectType().getDescribe().fields.getMap().containsKey(
                        fieldPathSegment.trim()
                )
                ;

    }


    /**
    * Check whether provided field path segment referes to children collections of incoming sobject
    */
    public static Boolean isChildrenCollections(SObject source, String fieldPathSegment) {

        for (Schema.ChildRelationship childRelationship : source.getSObjectType().getDescribe().getChildRelationships()) {

            if (
                    isEquivalent(
                            childRelationship.getRelationshipName(),
                            fieldPathSegment
                    )
                    ) {

                return true;

            }

        }


        return false;

    }


    /**
    * Convert incoming object into map of propery/values (useful for reflection based techniques)
    */
    public static Map<String, Object> toPropertyMap(Object source) {

        return
                source <> null
                        ?
                        (Map<String, Object>)
                                JSON.deserializeUntyped(
                                        JSON.serialize(
                                                source
                                        )
                                )
                        :
                        null
                ;

    }


    /**
    * Map incoming collection of objects (presumably some DTOs or view models) to string values extracted from the provided property
    */
    public static List<String> mapModelsToStrings(List<Object> models, String textPropertyName) {

        List<String> propertyValues = new List<String>();


        for (Object model : models) {

            propertyValues.add(
                    String.valueOf(
                            BaseUtilities.toPropertyMap(model).get(textPropertyName)
                    )
            );

        }


        return propertyValues;

    }


    /**
    * Map incoming collection of objects (presumably some DTOs or view models) to ids values extracted from the provided property
    */
    public static List<Id> mapModelsToIds(List<Object> models, String idPropertyName) {

        List<Id> propertyValues = new List<Id>();


        for (String idValue : mapModelsToStrings(models, idPropertyName)) {

            propertyValues.add(
                    Id.valueOf(
                            idValue
                    )
            );

        }


        return propertyValues;

    }


    /**
    * Map incoming collection of objects (presumably some DTOs or view models) to boolean values extracted from the provided property
    */
    public static List<Boolean> mapModelsToBooleans(List<Object> models, String booleanPropertyName) {

        List<Boolean> propertyValues = new List<Boolean>();


        for (Object model : models) {

            propertyValues.add(
                    Boolean.valueOf(
                            BaseUtilities.toPropertyMap(model).get(booleanPropertyName)
                    )
            );

        }


        return propertyValues;

    }


    /**
    * Get first element (if any) from incoming records collection, otherwise null is returned
    */
    public static SObject getFirstIfAny(List<SObject> records) {

        return
                isNullOrEmpty(records)
                        ?
                        null
                        :
                        records[0]
                ;

    }


    /**
    * Get first (if any) from incoming map (arbitrary one), otherwise null is returned
   	*/
    public static SObject getFirstIfAny(Map<Id, SObject> idToRecord) {

        if (isNotNullOrEmpty(idToRecord)) {

            // get first element (yep, it would be arbitrary one, map doesn't enforce any order)
            for (SObject record : idToRecord.values()) {

                return record;

            }

        }


        return null;

    }



    /**
     * Put incoming record into registry (if not there).
     * Returns existent record from the registry or just newly added.
     */
    public static SObject putIfNotThere(Map<Id, SObject> idToRecord, Id recordId, SObject newRecord) {

        SObject record = idToRecord.get(recordId);


        // not in the registry - inject new record
        if (record == null) {

            idToRecord.put(
                    recordId,
                    record = newRecord
            );

        }


        return record;

    }



    /**
    * Get yesterday
    */
    public static Date getYesterday() {

        return
                getYesterday(
                        BaseUtilities.today()
                )
                ;

    }


    /**
    * Get yeasterday
    */
    public static Date getYesterday(Date baseDate) {

        return
                baseDate.addDays(-1)
                ;

    }


    /**
    * Get tomorrow
    */
    public static Date getTomorrow() {

        return
                getTomorrow(
                        BaseUtilities.today()
                )
                ;

    }


    /**
    * Get tomorrow
    */
    public static Date getTomorrow(Date baseDate) {

        return
                baseDate.addDays(1)
                ;

    }


    /**
    * Join two incoming set of ids
    */
    public static Set<Id> join(Set<Id> operandOne, Set<Id> operandTwo) {

        Set<Id> result = new Set<Id>();


        if (isNotNullOrEmpty(operandOne)) {

            result.addAll(
                    operandOne
            );

        }


        if (isNotNullOrEmpty(operandTwo)) {

            result.addAll(
                    operandTwo
            );

        }


        return result;

    }


    /**
    * Union of two incoming set of ids.
    * New set is returned.
    */
    public static Set<Id> unite(Set<Id> operandOne, Set<Id> operandTwo) {

        return
                join(
                        operandOne,
                        operandTwo
                )
                ;

    }


    /**
    * Intersection of two incoming set of ids.
    * New set is returned.
    */
    public static Set<Id> intersect(Set<Id> operandOne, Set<Id> operandTwo) {

        Set<Id> result = new Set<Id>();


        // intersection with empty set = empty set
        if (
                isNullOrEmpty(operandOne)
                        ||
                        isNullOrEmpty(operandTwo)
                ) {
            return result;
        }


        result.addAll(
                operandOne
        );


        result.retainAll(operandTwo);


        return result;

    }


    /**
    * Intersection of two incoming set of strings.
    * New set is returned.
    */
    public static Set<String> intersect(Set<String> operandOne, Set<String> operandTwo) {

        Set<String> result = new Set<String>();


        // intersection with empty set = empty set
        if (
                isNullOrEmpty(operandOne)
                        ||
                        isNullOrEmpty(operandTwo)
                ) {
            return result;
        }


        result.addAll(
                operandOne
        );


        result.retainAll(operandTwo);


        return result;

    }


    /**
    * Set subtraction: operandOne - operandTwo
    * New set is returned.
    */
    public static Set<Id> subtract(Set<Id> operandOne, Set<Id> operandTwo) {

        Set<Id> result = new Set<Id>();


        // operand one empty: result => empty set
        if (isNullOrEmpty(operandOne)) {
            return result;
        }


        result.addAll(
                operandOne
        );


        // operand two empty: result => copy of operand one
        if (isNullOrEmpty(operandTwo)) {
            return result;
        }


        result.removeAll(operandTwo);


        return result;

    }


    /**
    * Exclusive or
    */
    public static Boolean xor(Boolean operandOne, Boolean operandTwo) {

        return
                (
                        operandOne == true
                                &&
                                operandTwo == false
                )
                        ||
                        (
                                operandOne == false
                                        &&
                                        operandTwo == true
                        )
                ;

    }


    /**
    * getLookupFieldNamePath (String fieldPath)
    * Returns a fieldPath for a relationship (e.g. for AccountId - will return Account.Name)
    */
    public static String getRelationshipFieldNamePath(String fieldPath) {
        String result = getRelationshipName(fieldPath) + '.Name';
        return result;
    }

    /**
    * getRelationshipName (String fieldPath)
    * Returns relationshipName from a fieldPath - e.g. from Custom_Lookup__c -> Custom_Lookup__r
    */
    public static String getRelationshipName(String fieldPath) {
        String result;
        if (fieldPath.contains('__c'))
        {
            result = fieldPath.replace('__c', '__r');
        }
        else
        {
            result = fieldPath.replace('Id', '');
        }
        return result;
    }

    /**
    * getValueForReferenceType (String fieldPath, SObject record)
    * Returns a value of relationship name by a fieldpath from a record (e.g. will return Account.Name value for a Contact record if will be called with params 'AccountId', contactRecord)
    */
    public static String getValueForReferenceTypeName(String fieldPath, SObject record) {
        String result = '';
        SObject parentSObject = record.getSObject(getRelationshipName(fieldPath));
        if (parentSObject != null) {
            result = String.valueOf(parentSObject.get('Name'));
        }
        return result;
    }



    /*
     * General custom assert exception to be used as a replacement of system one due to inability to catch it.
    */
    public class CustomAssertException extends Exception {

    }

    /*
     * Serves to make exception context more clear.
    */
    public class NoSuchSObjectException extends Exception {

    }

    /*
     * Serves to make exception context more clear.
    */
    public class NoSuchFieldException extends Exception {

    }

    /**
    * Check if user has assigned OCE Admin Profile.
    * @return Boolean.
    */
    public static Boolean isAdmin() {
        Boolean isAdmin = false;
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id = : UserInfo.getProfileId()];
        if(PROFILE_NAME_ADMIN.equalsIgnoreCase(profile.Name)) {
            isAdmin = true;
        }
        return isAdmin;
    }


    /**
    * Wrap incoming string into single quotes escaping already existent quotes along the way.
    */
    public static String quote(String source) {

        return
                SINGLE_QUOTE
                        +
                        String.escapeSingleQuotes(
                                coalesce(
                                        source
                                )
                        )
                        +
                        SINGLE_QUOTE
                ;

    }


    /**
    * checks if sobject exists in the org.
    */

    public static Boolean isSobjectExist(String sobjectName){

        if(Schema.getGlobalDescribe().get(sobjectName) != null)
            return true;
        else
                return false;

    }

    /**
    *  This method is used to get Get all fields of an Object.
    *   @param      thisSObject - the Object Type passed to the method.
    *   @return     list<string> - the list of String returned.
    */

    public static List<string> getAllFields( sObject thisSObject) {
        list<string> fields = new list<string>();
        for(String f: thisSObject.getsObjectType().getDescribe().fields.getMap().Keyset()) {
            fields.add(f);
        }
        return fields;
    }

    /**
    *  Check if any approval process is active for the sObject.
    */
    public static boolean isApprovalProcessActive(String sObjectType){
        List<ProcessDefinition> approvalProcess = [select  Id,State,TableEnumOrId from ProcessDefinition
        where State = 'Active' and TableEnumOrId =:sObjectType and Type='Approval'];

        if(approvalProcess.size() > 0)
            return true;
        else
                return false;
    }

    /**
    * Get profile by id
    */
    public static Profile getProfileById( Id profileId ) {
        return [SELECT Name
        FROM Profile
        WHERE Id = : profileId];
    }


    /**
    * Get Static Resource by developer name
    */
    public static StaticResource getStaticResourceByDevName( String devName ){
        return getStaticResourceByDevName( devName, true );
    }

    /**
    * Get Static Resource by developer name. throw BaseException exception if no resource found.
    */
    public static StaticResource getStaticResourceByDevName( String devName, Boolean doCheck ){

        List<StaticResource> statResources =
        [SELECT Id, SystemModStamp, Name
        FROM StaticResource
        WHERE Name = : devName];

        if ( doCheck && statResources.isEmpty() ){
            throw new BaseException('custom exeption: static resource "' + devName + '" not found.');
        }

        if ( !doCheck && statResources.isEmpty() ){
            return null;
        }

        return statResources.get(0);
    }



    /**
    * form relative url (without only domain name) to the specific file inside static resourse
    */
    public static String formUrlToStaticResourceFile( String staticResourseName, Datetime staticResourseTimeStamp, String relativePath ){

        if ( staticResourseTimeStamp == null ){
            return null;
        }

        return '/resource/'
                + String.valueOf(staticResourseTimeStamp.getTime())
                + '/' + staticResourseName
                + '/' + relativePath.removeStart('/');
    }


    /**
    * build relative url (without only domain name) to the specific file inside static resourse
    */
    public static String formUrlToStaticResourceFile( StaticResource resource, String relativePath ){

        return formUrlToStaticResourceFile( resource.Name, resource.SystemModStamp, relativePath );

    }



    /**
    * Truncate incoming string to provided number of charachters, optionally append ellipsis
    */
    public static String truncate(String source, Integer numberOfCharacters, Boolean appendEllipsis) {

        return
                (
                        String.isBlank(source)
                                ||
                                source.length() <= numberOfCharacters
                )
                        ?
                        source
                        :
                        (
                                source.left(numberOfCharacters)
                                        +
                                        (appendEllipsis ? ELLIPSIS : EMPTY)
                        )
                ;

    }



    /**
    * Shorten incoming string to provided length and added ellipsis
    */
    public static String shortenTo(String source, Integer numberOfCharacters) {

        return
                truncate(
                        source,
                        numberOfCharacters,
                        true
                )
                ;

    }



    /**
    * Format incoming message with one provided param
    */
    public static String format(String message, Object value) {

        return
                String.format(
                        message,
                        new List<String> {
                                String.valueOf(
                                        value
                                )
                        }
                )
                ;

    }


}