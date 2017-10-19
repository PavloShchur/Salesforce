/**
* Helper class to hold object related utilities, e.g. dealing with fields etc.
*/
public with sharing class ObjectUtilities {


    // id's related
    public static final String FIELD_NAME_ID = 'Id';

    public static final Integer SHORT_ID_LENGTH = 15;
    public static final Integer LONG_ID_LENGTH = 18;


    // cache
    private static Map<String, Schema.DescribeSObjectResult> objectNameToDescribeResult = new Map<String, Schema.DescribeSObjectResult>();



    /**
    * Check whether incoming field set exists from provided SObject type (works with fully qualified and local names).
    */
    public static Boolean existFieldSet(Schema.DescribeSObjectResult objectDescribe, String fieldSetName) {

        return
                getObjectFieldSet(objectDescribe, fieldSetName)
                        <>
                        null
                ;

    }



    /**
    * Get fields for provided SObject type from field set identified by name.
    */
    public static List<Schema.FieldSetMember> getFieldsFromFieldSet(Schema.DescribeSObjectResult objectDescribe, String fieldSetName) {

        // early exist if field set doesn't exist
        if (!existFieldSet(objectDescribe, fieldSetName)) {
            return new List<Schema.FieldSetMember>();
        }


        return
                getObjectFieldSet(
                        objectDescribe,
                        fieldSetName
                ).getFields()
                ;

    }



    /**
    * Get object field by incoming name (works with fully qualified and local names).
    */
    public static Schema.FieldSet getObjectFieldSet(Schema.DescribeSObjectResult objectDescribe, String fieldSetName) {

        Map<String, Schema.FieldSet> fullyQualifiedNameToFieldSet = objectDescribe.fieldSets.getMap();


        // prepend namesapce to field set and search for it
        Schema.FieldSet fieldSet =
                fullyQualifiedNameToFieldSet.get(
                        PackageUtilities.addNamespacePrefixToFieldSet(
                                fieldSetName
                        )
                )
        ;

        // early exit: stop searching if found
        if (fieldSet <> null) {
            return fieldSet;
        }


        // search for field set by originally provided name and returns what has been found (since no more alternatives)
        return
                fullyQualifiedNameToFieldSet.get(
                        fieldSetName
                )
                ;

    }



    /**
    * Map list of incoming field set members to field paths, i.e. format ready to be used in a dynamic SOQL query
    */
    public static List<String> mapFieldSetMembersToPaths(List<Schema.FieldSetMember> fieldSetMembers) {

        if (BaseUtilities.isNullOrEmpty(fieldSetMembers)) {
            return new List<String>();
        }


        List<String> fieldPaths = new List<String>();


        for (Schema.FieldSetMember fieldSetMember : fieldSetMembers) {

            fieldPaths.add(
                    fieldSetMember.getFieldPath()
            );

        }


        return fieldPaths;

    }



    /**
    * Map list of incoming field set members to labels
    */
    public static List<String> mapFieldSetMembersToLabels(List<Schema.FieldSetMember> fieldSetMembers) {

        if (BaseUtilities.isNullOrEmpty(fieldSetMembers)) {
            return new List<String>();
        }


        List<String> fieldLabels = new List<String>();


        for (Schema.FieldSetMember fieldSetMember : fieldSetMembers) {

            fieldLabels.add(
                    fieldSetMember.getLabel()
            );

        }


        return fieldLabels;

    }

    /**
    * Get record types of sobject.
    * @param sObjectName which record types have to be returned.
    * @return a map of record types ids to record types names.
    */
    public static Map<String, Id> getSObjectRecordTypes(String sObjectName) {
        Map<String, Id> result = new Map<String, Id>();
        List<Schema.RecordTypeInfo> recordTypes = getObjectDescribe(sObjectName).getRecordTypeInfos();
        Map<String, Object> recordTypesMap = CollectionUtilities.asMap(recordTypes, 'name', 'recordTypeId');

        for (String key : recordTypesMap.keySet()) {
            result.put(
                    key,
                    (Id)recordTypesMap.get(key)
            );
        }

        return result;
    }

    /**
    * Get name by incoming sobject instance
    */
    public static String getSobjectName(SObject record) {

        return
                String.valueOf(
                        record.getSObjectType()
                )
                ;

    }



    /**
    * Get name by incoming record id
    */
    public static String getSobjectName(String recordId) {

        return
                String.valueOf(
                        Id.valueOf(
                                recordId
                        ).getSObjectType()
                )
                ;

    }



    /**
    * Convert incoming object name to fully qualified one, i.e. assuming current namespace
    */
    public static String toFullyQualifiedObjectName(String objectName) {

        return
                String.valueOf(
                        ObjectUtilities.getObjectType(
                                objectName
                        )
                )
                ;

    }



    /**
    * Create new empty sobject instance by name and set incoming id (optionally)
    */
    public static SObject newSobjectInstance(String objectName, Id recordId) {

        SObject record =
                getObjectType(objectName).newSObject()
        ;


        // set id of the record
        if (recordId <> null) {

            record.put(
                    'Id',
                    recordId
            );

        }


        return record;

    }



    /**
    * Create new empty sobject instance by name
    */
    public static SObject newSobjectInstance(String objectName) {

        return
                newSobjectInstance(
                        objectName,
                        null
                )
                ;

    }



    /**
    * Create object of specified type and populated with provided values
    */
    public static Object toObject(Map<String, Object> fieldNameToValue, Type objectType) {

        return
                JSON.deserialize(
                        JSON.serialize(
                                fieldNameToValue
                        ),
                        objectType
                )
                ;

    }



    /**
    * Convert incoming object to short version of id (just substring extraction, no actual parsing as id)
    */
    public static String asShortId(Object source) {

        return
                BaseUtilities.coalesce(
                        String.valueOf(
                                source
                        )
                )
                        .left(SHORT_ID_LENGTH)
                ;

    }



    /**
    * Convert incoming object to record id.
    * Return null in case of failure (e.g. invalid format) instead of throwing exception.
    */
    public static Id toId(Object source) {

        String value = String.valueOf(source);


        if (String.isBlank(value)) {
            return null;
        }


        Id recordId = null;


        try {

            recordId =
                    Id.valueOf(
                            value.trim()
                    )
                    ;

        } catch (Exception exp) {

            // returned null would be an indicator of error

        }


        return recordId;

    }



    /**
    * Is not valid id
    */
    public static Boolean isNotId(Object value) {

        return
                !
                        isId(value)
                ;

    }



    /**
    * Is valid id
    */
    public static Boolean isId(Object value) {

        return
                toId(value) <> null
                ;

    }



    /**
    * Check whether incoming object exists
    */
    public static Boolean isObject(String objectName) {

        return
                getObjectType(objectName) <> null
                ;

    }



    /**
    * Check whether incoming field exists for provided object name, e.g. isField('Account', 'Name')
    */
    public static Boolean isField(String objectName, String fieldName) {

        return
                isObject(objectName)
                        &&
                        isField(
                                getObjectDescribe(objectName),
                                fieldName
                        )
                ;

    }



    /**
    * Check whether incoming field exists for provided object type, e.g. isField(Schema.SobjectType.Account, 'Name')
    */
    public static Boolean isField(Schema.DescribeSObjectResult objectDescribe, String fieldName) {

        return
                objectDescribe <> null
                        &&
                        (
                                getFieldDescribe(
                                        objectDescribe,
                                        fieldName
                                )
                                        <>
                                        null
                        )
                ;

    }



    /**
    * Check whether provided field path segment referes to field on incoming sobject
    */
    public static Boolean isField(SObject source, String fieldPathSegment) {
        if(source == null){
            return false;
        }

        return
                isField(
                        source.getSObjectType().getDescribe(),
                        fieldPathSegment.trim()
                )
                ;

    }



    /**
    * Convert incoming value to type compatible with provided field (to be able to populated the field with returned value)
    */
    public static Object convertValueToFieldType(String objectName, String fieldName, Object originalValue) {

        String stringifiedOriginalValue = String.valueOf(originalValue);


        // id
        if (isIdField(objectName, fieldName)) {

            return
                    originalValue instanceof Id
                            ?
                            originalValue
                            :
                            Id.valueOf(
                                    stringifiedOriginalValue
                            )
                    ;


            // numeric
        } else if (isNumericField(objectName, fieldName)) {

            return
                    originalValue instanceof Decimal
                            ?
                            originalValue
                            :
                            Decimal.valueOf(
                                    stringifiedOriginalValue
                            )
                    ;


            // boolean
        } else if (isBooleanField(objectName, fieldName)) {

            return
                    originalValue instanceof Boolean
                            ?
                            originalValue
                            :
                            Date.valueOf(
                                    stringifiedOriginalValue
                            )
                    ;


            // date
        } else if (isDateField(objectName, fieldName)) {

            return
                    originalValue instanceof Date
                            ?
                            originalValue
                            :
                            Date.valueOf(
                                    stringifiedOriginalValue
                            )
                    ;


            // date time
        } else if (isDateTimeField(objectName, fieldName)) {

            return
                    originalValue instanceof DateTime
                            ?
                            originalValue
                            :
                            DateTime.valueOfGmt(
                                    normalizeDateTime(
                                            stringifiedOriginalValue
                                    )
                            )
                    ;


            // blob
        } else if (isBlobField(objectName, fieldName)) {

            return
                    originalValue instanceof Blob
                            ?
                            originalValue
                            :
                            Blob.valueOf(
                                    stringifiedOriginalValue
                            )
                    ;


            // looks like it doesn't require special conversion, e.g. some text
        } else {

            return originalValue;

        }

    }



    /**
    * Check whether incoming field name is id
    */
    public static Boolean isIdFieldName(String fieldName) {

        return
                BaseUtilities.isEquivalent(
                        FIELD_NAME_ID,
                        fieldName
                )
                ;

    }



    /**
    * Check whether incoming field name is not id
    */
    public static Boolean isNotIdFieldName(String fieldName) {

        return
                !
                        isIdFieldName(
                                fieldName
                        )
                ;

    }



    /**
    * Check whether incoming field is not permissionalbe
    */
    public static Boolean isNotPermissionableField(String objectName, String fieldName) {

        return
                !
                        isPermissionableField(
                                objectName,
                                fieldName
                        )
                ;

    }



    /**
    * Check whether incoming field is permissionalbe
    */
    public static Boolean isPermissionableField(String objectName, String fieldName) {

        Schema.DescribeFieldResult fieldDescribe = getFieldDescribe(objectName, fieldName);

        // early exit if field not found
        if (fieldDescribe == null) {
            return false;
        }


        return fieldDescribe.isPermissionable();

    }



    /**
    * Check whether incoming field is createable but not updateable
    */
    public static Boolean isCreateableButNotUpdateableField(String objectName, String fieldName) {

        Schema.DescribeFieldResult fieldDescribe = getFieldDescribe(objectName, fieldName);

        // early exit if field not found
        if (fieldDescribe == null) {
            return false;
        }


        return
                fieldDescribe.isCreateable()
                        &&
                        !
                                fieldDescribe.isUpdateable()
                ;

    }



    /**
    * Check whether provided field is id
    */
    public static Boolean isIdField(String objectName, String fieldName) {

        return
                isFieldOfType(
                        objectName,
                        fieldName,
                        Schema.DisplayType.Id
                )
                ;

    }



    /**
    * Check whether provided field is numeric
    */
    public static Boolean isNumericField(String objectName, String fieldName) {

        return
                isFieldOfType(
                        objectName,
                        fieldName,
                        new Set<Schema.DisplayType> {
                                Schema.DisplayType.Currency,
                                Schema.DisplayType.Double,
                                Schema.DisplayType.Integer,
                                Schema.DisplayType.Percent
                        }
                )
                ;

    }



    /**
    * Check whether provided field is boolean
    */
    public static Boolean isBooleanField(String objectName, String fieldName) {

        return
                isFieldOfType(
                        objectName,
                        fieldName,
                        Schema.DisplayType.Boolean
                )
                ;

    }



    /**
    * Check whether provided field is a date
    */
    public static Boolean isDateField(String objectName, String fieldName) {

        return
                isFieldOfType(
                        objectName,
                        fieldName,
                        Schema.DisplayType.Date
                )
                ;

    }



    /**
    * Check whether provided field is a date time
    */
    public static Boolean isDateTimeField(String objectName, String fieldName) {

        return
                isFieldOfType(
                        objectName,
                        fieldName,
                        Schema.DisplayType.DateTime
                )
                ;

    }



    /**
    * Check whether provided field is a reference, i.e. lookup or master-detail relationship
    */
    public static Boolean isReferenceField(String objectName, String fieldName) {

        return
                isFieldOfType(
                        objectName,
                        fieldName,
                        Schema.DisplayType.Reference
                )
                ;

    }



    /**
    * Check whether provided field is a blob field, i.e. represents large base64-encoded chunk of data, e.g. Attachment.Body
    */
    public static Boolean isBlobField(String objectName, String fieldName) {

        return
                isFieldOfType(
                        objectName,
                        fieldName,
                        Schema.DisplayType.base64
                )
                ;

    }



    /**
    * Check whether provided field has an expected field type
    */
    public static Boolean isFieldOfType(String objectName, String fieldName, Schema.DisplayType expectedFieldType) {

        Schema.DescribeFieldResult fieldDescribe = getFieldDescribe(objectName, fieldName);

        // early exit if field not found
        if (fieldDescribe == null) {
            return false;
        }


        return
                fieldDescribe.getType()
                        ==
                        expectedFieldType
                ;

    }



    /**
    * Check whether provided field has one of the expected field types
    */
    public static Boolean isFieldOfType(String objectName, String fieldName, Set<Schema.DisplayType> expectedFieldTypes) {

        Schema.DescribeFieldResult fieldDescribe = getFieldDescribe(objectName, fieldName);

        // early exit if field not found
        if (fieldDescribe == null) {
            return false;
        }


        for (Schema.DisplayType expectedFieldType : expectedFieldTypes) {

            if (fieldDescribe.getType() == expectedFieldType) {

                return true;

            }

        }


        return false;

    }



    /**
    * Get field label (works with fully qualified and local names).
    */
    public static String getFieldLabel(String objectName, String fieldName) {

        Schema.DescribeFieldResult fieldDescribe =
                getFieldDescribe(
                        objectName,
                        fieldName
                )
        ;


        return
                fieldDescribe == null
                        ?
                        null
                        :
                        fieldDescribe.getLabel()
                ;

    }



    /**
    * Get field label (works with fully qualified and local names).
    * If some field is not found, null is returned on appropriate position in outcoming collection.
    */
    public static List<String> getFieldsLabels(String objectName, List<String> fieldNames) {

        List<String> fieldsLabels = new List<String>();


        for (String fieldName : fieldNames) {

            fieldsLabels.add(
                    getFieldLabel(
                            objectName,
                            fieldName
                    )
            );

        }


        return fieldsLabels;

    }



    /**
    * Get field describe (works with fully qualified and local names).
    */
    public static Schema.DescribeFieldResult getFieldDescribe(String objectName, String fieldName) {

        Schema.DescribeSObjectResult objectDescribe = getObjectDescribe(objectName);


        if (objectDescribe == null) {
            return null;
        }


        return getFieldDescribe(objectDescribe, fieldName);

    }



    /**
    * Get field describe (works with fully qualified and local names).
    */
    public static Schema.DescribeFieldResult getFieldDescribe(Schema.DescribeSObjectResult objectDescribe, String fieldName) {

        Schema.SObjectField objectField = getObjectField(objectDescribe, fieldName);


        return
                objectField == null
                        ?
                        null
                        :
                        objectField.getDescribe()
                ;

    }



    /**
    * Get object field by incoming name (works with fully qualified and local names).
    */
    public static Schema.SObjectField getObjectField(Schema.DescribeSObjectResult objectDescribe, String fieldName) {

        Map<String, Schema.SObjectField> fullyQualifiedNameToField = objectDescribe.fields.getMap();


        // prepend namesapce to field name and search for it
        Schema.SObjectField fieldType =
                fullyQualifiedNameToField.get(
                        PackageUtilities.addNamespacePrefixToObjectField(
                                fieldName
                        )
                )
        ;

        // early exit: stop searching if found
        if (fieldType <> null) {
            return fieldType;
        }


        // search for field by originally provided name and returns what has been found (since no more alternatives)
        return
                fullyQualifiedNameToField.get(
                        fieldName
                )
                ;

    }



    /**
    * Get describes for sortable fields of incoming object (works with fully qualified and local names).
   	*/
    public static List<Schema.DescribeFieldResult> getObjectSortableFieldsDescribes(String objectName) {

        List<Schema.DescribeFieldResult> sortableFieldDescribes = new List<Schema.DescribeFieldResult>();


        for (Schema.DescribeFieldResult fieldDescribe : getObjectFieldsDescribes(objectName)) {

            if (fieldDescribe.isSortable()) {

                sortableFieldDescribes.add(
                        fieldDescribe
                );

            }

        }


        return sortableFieldDescribes;

    }

    public static Set<String> getObjectFieldNames(String objectName) {
        Set<String> fieldNames = new Set<String>();

        Schema.DescribeSObjectResult objectDescribe = getObjectDescribe(objectName);

        if (objectDescribe == null) {
            return fieldNames;
        }

        for (Schema.SObjectField objectField : objectDescribe.fields.getMap().values()) {

            fieldNames.add(
                    objectField.getDescribe().getLocalName()
            );

        }

        return fieldNames;
    }

    /**
    * Get describes for all fields of incoming object (works with fully qualified and local names).
   	*/
    public static List<Schema.DescribeFieldResult> getObjectFieldsDescribes(String objectName) {

        List<Schema.DescribeFieldResult> fieldDescribes = new List<Schema.DescribeFieldResult>();


        Schema.DescribeSObjectResult objectDescribe = getObjectDescribe(objectName);

        if (objectDescribe == null) {
            return fieldDescribes;
        }


        for (Schema.SObjectField objectField : objectDescribe.fields.getMap().values()) {

            fieldDescribes.add(
                    objectField.getDescribe()
            );

        }


        return fieldDescribes;

    }



    /**
    * Get object 'name' field, i.e. the one which is used as text representation of a record (Name in most cases)
    */
    public static Schema.DescribeFieldResult getObjectNameField(String objectName) {

        List<Schema.DescribeFieldResult> fieldsDescribes =  getObjectFieldsDescribes(objectName);

        // early exit - can not get fields for provided object name
        if (BaseUtilities.isNullOrEmpty(fieldsDescribes)) {
            return null;
        }


        // loop through fields and find first named one
        for (Schema.DescribeFieldResult describeFieldResult : fieldsDescribes) {

            if (describeFieldResult.isNameField()) {

                return describeFieldResult;

            }

        }


        // no named field found - highly unlikely
        return null;

    }

    /**
     * Gets Labels for Object .
     * @param        String sObjectType
     * @return       Map<String, String>
     */
    public static Map<String, String> geFieldNameLabelMap(String objectName) {
        List<Schema.DescribeFieldResult> fields = getObjectFieldsDescribes(objectName);

        return CollectionUtilities.asStringMap(fields, 'localName', 'label');
    }

    /**
     * Gets Labels for Object .
     * @param        String sObjectType
     * @return       Map<String, String>
     */
    public static Map<String, String> geFieldLabelNameMap(String objectName) {
        List<Schema.DescribeFieldResult> fields = getObjectFieldsDescribes(objectName);

        return CollectionUtilities.asStringMap(fields, 'label', 'localName');
    }

    public static List<String> getActivePicklistValues(String objectName, String fieldName) {
        return
                BaseUtilities.mapModelsToStrings(
                        getActivePicklistEntries(objectName, fieldName),
                        'value'
                );
    }

    /**
    * Get active picklist entries
    */
    public static List<Schema.PicklistEntry> getActivePicklistEntries(String objectName, String fieldName) {

        List<Schema.PicklistEntry> activePicklistEntries = new List<Schema.PicklistEntry>();


        for (Schema.PicklistEntry picklistEntry : getPicklistEntries(objectName, fieldName)) {

            // filter to active entries
            if (picklistEntry.isActive() == true) {

                activePicklistEntries.add(
                        picklistEntry
                );

            }

        }


        return activePicklistEntries;

    }



    /**
    * Get picklist entries
    */
    public static List<Schema.PicklistEntry> getPicklistEntries(String objectName, String fieldName) {

        return
                getFieldDescribe(
                        objectName,
                        fieldName
                ).getPicklistValues()
                ;

    }



    /**
	* Get object describe by incoming name (works with fully qualified and local names).
	*/
    public static Schema.DescribeSObjectResult getObjectDescribe(String objectName) {

        // check cache first
        Schema.DescribeSObjectResult describeResult = objectNameToDescribeResult.get(objectName);

        if (describeResult <> null) {
            return describeResult;
        }


        Schema.SObjectType objectType = getObjectType(objectName);


        if (objectType <> null) {

            describeResult = objectType.getDescribe();

            objectNameToDescribeResult.put(
                    objectName,
                    describeResult
            );

        }


        return describeResult;

    }



    /**
    * Get object type by incoming name (works with fully qualified and local names).
    */
    public static Schema.SObjectType getObjectType(String objectName) {

        String normalizedObjectName = objectName.toLowerCase();

        Map<String, Schema.SObjectType> fullyQualifiedNameToObject = Schema.getGlobalDescribe();


        // prepend namesapce to object name and search for it
        Schema.SObjectType objectType =
                fullyQualifiedNameToObject.get(
                        PackageUtilities.addNamespacePrefixToObjectField(
                                normalizedObjectName
                        )
                )
        ;

        // early exit: stop searching if found
        if (objectType <> null) {
            return objectType;
        }


        // search for object by originally provided name and returns what has been found (since no more alternatives)
        return
                fullyQualifiedNameToObject.get(
                        normalizedObjectName
                )
                ;

    }



    /**
    * Wipe describe results cache
    */
    public static void wipeObjectDescribeResultCache() {

        objectNameToDescribeResult.clear();

    }



    /**
    * Check whether provided field path segment referes to children collections of incoming sobject
    */
    public static Boolean isChildrenCollections(SObject source, String fieldPathSegment) {
        if(source == null){
            return false;
        }
        for (Schema.ChildRelationship childRelationship : source.getSObjectType().getDescribe().getChildRelationships()) {

            if (
                    BaseUtilities.isEquivalent(
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
    * Get sobject field value by field path
    */
    public static Object getValueByFieldPath(SObject actualObject, String fieldPath) {

        SObject intermediateRecord = actualObject;
        Object value = null;

        String[] fieldPathSegments =
                fieldPath.split(
                        BaseUtilities.DOT_REGEXP,
                        -1
                )
        ;


        for (Integer i = 0; i < fieldPathSegments.size(); i++) {

            String fieldPathSegmentWithoutCollectionIndex = fieldPathSegments[i].substringBefore('[').trim();


            // field path segment just refers to field name
            if (isField(intermediateRecord, fieldPathSegmentWithoutCollectionIndex)) {

                // fetch value directly from intermediate record based on field name
                value =
                        intermediateRecord.get(
                                fieldPathSegmentWithoutCollectionIndex
                        )
                        ;


                // if field token is present, it should be the last in field path
                break;


                // field path segment refers to children collections (with optional index) and it also could be the last segment in field path
            } else if (isChildrenCollections(intermediateRecord, fieldPathSegmentWithoutCollectionIndex)) {

                SObject[] childrenCollections =
                        intermediateRecord.getSObjects(
                                fieldPathSegmentWithoutCollectionIndex
                        )
                ;

                // fetch collection index (if any), e.g. Contacts[2].Name => 2
                String fieldPathSegmentCollectionIndexRaw =
                        BaseUtilities.extract(
                                fieldPathSegments[i],
                                '\\[\\s*(\\d+)\\s*\\]'
                        )
                ;


                Integer fieldPathSegmentCollectionIndex =
                        BaseUtilities.parseNumber(
                                fieldPathSegmentCollectionIndexRaw
                        )
                ;


                // just one element of collections should be considered
                if (fieldPathSegmentCollectionIndex <> null) {

                    intermediateRecord =
                            intermediateRecord.getSObjects(
                                    fieldPathSegmentWithoutCollectionIndex
                            )
                            [
                                    fieldPathSegmentCollectionIndex
                                    ]
                            ;


                    value = (Object)intermediateRecord;


                    // all collection should be considered
                } else {

                    value = (Object)childrenCollections;

                    // if all collection is considered, it should be the last token in field path
                    break;

                }


                // suppose that field path segment refers to parent record
            } else if(intermediateRecord != null) {
                intermediateRecord =
                        intermediateRecord.getSObject(
                                fieldPathSegmentWithoutCollectionIndex
                        )
                        ;


                value = (Object)intermediateRecord;

            }

        }


        return value;

    }



    // normalize date time, e.g.
    //	from:	2014-11-20T14:23:44.000+0000
    //	to:		2014-11-20 14:23:44
    private static String normalizeDateTime(String stringifiedDateTime) {

        return
                stringifiedDateTime
                        .substringBefore(
                        BaseUtilities.DOT
                )
                        .replaceAll(
                        BaseUtilities.CASE_INSENSITIVE_REGEXP_OPTION_ON + 't',
                        BaseUtilities.SPACE
                )
                ;

    }


}