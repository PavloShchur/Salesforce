/**
* Helper class to hold collection related utilities.
*/
public with sharing class CollectionUtilities {


    /**
    * Organize data source based on the order of provided collection (id is used for matching).
    */
    public static List<SObject> organize(List<SObject> orderSource, List<SObject> dataSource) {

        List<SObject> orderedData = new List<SObject>();


        // early exit if empty collection
        if (
                BaseUtilities.isNullOrEmpty(
                        orderSource
                )
                        ||
                        BaseUtilities.isNullOrEmpty(
                                dataSource
                        )
                ) {
            return orderedData;
        }


        // index source by id
        Map<Id, SObject> idToData = indexById(dataSource);


        // loop through order items
        for (SObject orderItem : orderSource) {

            // get data item
            SObject dataItem = idToData.get(orderItem.Id);

            // data item not found - go to next one
            if (dataItem == null) {
                continue;
            }

            // gather data items in correct order
            orderedData.add(
                    dataItem
            );

        }


        return orderedData;

    }



    /**
    * Index incoming sobjects by id
    */
    public static Map<Id, SObject> indexById(List<SObject> source) {

        return
                new Map<Id, SObject>(
                        source
                )
                ;

    }



    /**
    * Index by string
    */
    public static Map<String, SObject> indexByUniqueString(List<SObject> records, String indexFieldName) {

        Map<String, SObject> nameToRecord = new Map<String, SObject>();


        for (SObject record : records) {

            nameToRecord.put(
                    String.valueOf(
                            record.get(
                                    indexFieldName
                            )
                    ),
                    record
            );

        }


        return nameToRecord;

    }



    /**
    * Wrap incoming string into set
    */
    public static Set<String> asSet(String value) {

        return
                new Set<String> {
                        value
                }
                ;

    }



    /**
    * Wrap incoming id into set
    */
    public static Set<Id> asSet(Id id) {

        return
                new Set<Id> {
                        id
                }
                ;

    }



    /**
    * Wrap incoming sobject into list
    */
    public static List<SObject> asList(SObject record) {

        return
                new List<SObject> {
                        record
                }
                ;

    }

    public static Map<String, Object> asMap(List<Object> objects, String keyAttribute, String valueAttribute) {
        Map<String, Object> result = new Map<String, Object>();

        System.assert(keyAttribute != null);

        for (Object obj : objects) {
            result.put(
                    String.valueOf(BaseUtilities.toPropertyMap(obj).get(keyAttribute)),
                    valueAttribute != null ? BaseUtilities.toPropertyMap(obj).get(valueAttribute) : obj
            );
        }

        return result;
    }

    public static Map<String, String> asStringMap(List<Object> objects, String keyAttribute, String valueAttribute) {

        Map<String, String> result = new Map<String, String>();
        Map<String, Object> objectMap = asMap(objects, keyAttribute, valueAttribute);

        for (String key : objectMap.keySet()) {
            result.put(
                    key,
                    String.valueOf(objectMap.get(key))
            );
        }

        return result;
    }

    /**
    * Convert incoming set of string values to lower case
    */
    public static Set<String> toLowerCase(Set<String> originalValues) {

        Set<String> loweredCaseValues = new Set<String>();


        for (String originalValue : originalValues) {

            loweredCaseValues.add(
                    originalValue == null
                            ?
                            originalValue
                            :
                            originalValue.toLowerCase()
            );

        }


        return loweredCaseValues;

    }



    /**
    * Convert incoming map to another one with lower-cased version of keys
    */
    public static Map<String, Object> toLowerCaseKey(Map<String, Object> keyToValue) {

        Map<String, Object> lowerCaseKeyToValue = keyToValue.clone();
        lowerCaseKeyToValue.clear();


        for (String key : keyToValue.keySet()) {

            lowerCaseKeyToValue.put(
                    (
                            BaseUtilities.isNullOrEmpty(key)
                                    ?
                                    key
                                    :
                                    key.toLowerCase()
                    ),
                    keyToValue.get(
                            key
                    )
            );

        }


        return lowerCaseKeyToValue;

    }



    /**
    * Reverse incoming list
    */
    public static List<Object> reverse(List<Object> originalObjects) {

        List<Object> reverseObjects = createListOfSameType(originalObjects);


        for (Integer i = originalObjects.size() - 1; i >= 0; i--) {

            reverseObjects.add(
                    originalObjects[i]
            );

        }


        return reverseObjects;

    }



    /**
    * Create new list of the same type as incoming one - useful for building some generic solutions, e.g. reverse
    */
    public static List<Object> createListOfSameType(List<Object> source) {

        List<Object> target = source.clone();

        target.clear();


        return target;

    }



    /**
    * Concat two incoming lists into single new one
    */
    public static List<Object> concat(List<Object> operandOne, List<Object> operandTwo) {

        // clone first list
        List<Object> result = operandOne.clone();

        // copy all elements from the second one
        result.addAll(operandTwo);


        return result;

    }



    /**
    * Extract sublist from incoming list: [start, finish)
    */
    public static List<SObject> subList(List<SObject> source, Integer start, Integer finish) {

        List<SObject> destination = (List<SObject>)createListOfSameType(source);

        if (BaseUtilities.isNullOrEmpty(source)) {
            return destination;
        }


        Integer actualStart = (start == null || start < 0 ? 0 : start);
        Integer actualFinish =  (finish == null || finish > source.size() ? source.size() : finish);


        if (actualStart > source.size() || actualFinish <= 0 || actualStart >= actualFinish) {
            return destination;
        }


        for (Integer i = actualStart; i < actualFinish; i++) {

            destination.add(
                    source[i]
            );

        }


        return destination;

    }



    /**
    * Filter to records with change in provided field, e.g. when filtering in trigger context
    */
    public static List<SObject> filterToChanged(List<SObject> newRecords, Map<Id, SObject> idToOldRecord, String fieldNameToCompare) {

        List<SObject> changedRecords = (List<SObject>)createListOfSameType(newRecords);


        for (SObject newRecord : newRecords) {

            // fetch old record
            SObject oldRecord = idToOldRecord.get(newRecord.Id);

            // move to the next one if old record is not found - just in case
            if (oldRecord == null) {
                continue;
            }


            // skip not changed records
            if (
                    equals(
                            newRecord.get(
                                    fieldNameToCompare
                            ),
                            oldRecord.get(
                                    fieldNameToCompare
                            )
                    )
                    ) {
                continue;
            }


            // collect changed records
            changedRecords.add(
                    newRecord
            );

        }


        return changedRecords;

    }



    // compare two values of ounknown type
    private static Boolean equals(Object operandOne, Object operandTwo) {

        if (
                operandOne instanceof String
                        &&
                        operandTwo instanceof String
                ) {

            return
                    BaseUtilities.isEquivalent(
                            String.valueOf(
                                    operandOne
                            ),
                            String.valueOf(
                                    operandTwo
                            )
                    )
                    ;

        }


        return operandOne == operandTwo;

    }


}