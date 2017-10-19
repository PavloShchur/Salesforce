/**
* Helper class to hold package related utilities, e.g. dealing with namespace etc.
*/
public with sharing class PackageUtilities {

    public static final String NAMESPACE_SEPARATOR_FOR_OBJECT_FIELD = BaseUtilities.DOUBLE_UNDERSCORE;
    public static final String NAMESPACE_SEPARATOR_FOR_CLASS = BaseUtilities.DOT;

    public static final String OBJECT_FIELD_PATH_SEPARATOR = BaseUtilities.DOT;



    /**
    * Package namespace
    */
    public static String namespace {

        get {

            // cached version from previous evaluation
            if (namespace <> null) {
                return namespace;
            }


            PackageConfig__c config = PackageConfig__c.getInstance();


            namespace =
                    (
                            config == null
                                    ||
                                    BaseUtilities.isNullOrEmpty(config.Namespace__c)
                    )
                            ?
                            evaluateNamespace()
                            :
                            config.Namespace__c
                    ;


            return namespace;

        }

    }



    /**
    * Namespace prefix
    */
    public static String namespacePrefixObjectField {

        get {

            return
                    isNamespaceMode
                            ?
                            namespace + NAMESPACE_SEPARATOR_FOR_OBJECT_FIELD
                            :
                            BaseUtilities.EMPTY
                    ;

        }

    }



    /**
    * Not namespace mode indicator
    */
    public static Boolean isNotNamespaceMode {

        get {

            return
                    !
                            isNamespaceMode
                    ;

        }

    }



    /**
    * Namespace mode indicator
    */
    public static Boolean isNamespaceMode {

        get {

            return
                    BaseUtilities.isNotNullOrEmpty(
                            namespace
                    )
                    ;

        }

    }



    /**
    * Evaluate namespace (arbitrary custom object from package could be used here)
    */
    public static String evaluateNamespace() {

        return
//                SObjectType.Affiliation__c
//                        .Name
//                        .substringBefore('Affiliation__c').removeEndIgnoreCase(NAMESPACE_SEPARATOR_FOR_OBJECT_FIELD)
                'd'
                ;

    }



    /**
    * Check whether incoming entity (object or field) is custom object or field
    */
    public static Boolean isCustomObjectField(String entity) {

        return
                entity.containsIgnoreCase(
                        BaseUtilities.DOUBLE_UNDERSCORE
                )
                ;

    }



    /**
    * Check whether incoming entity (object or field) is standard object or field
    */
    public static Boolean isStandardObjectField(String entity) {

        return
                !
                        isCustomObjectField(
                                entity
                        )
                ;

    }



    /**
    * Check whether incoming entity (object or field) has current namespace prefix already
    */
    public static Boolean hasCurrentNamespaceObjectField(String entity) {

        return
                isNamespaceMode
                        &&
                        entity
                                .trim()
                                .startsWithIgnoreCase(
                                namespacePrefixObjectField
                        )
                ;

    }



    /**
    * Add namespace prefix to incoming entity (object or field) but only if needed, i.e. in case of custom entity without namespace
    */
    public static String addNamespacePrefixToObjectField(String entity) {

        return
                (
                        // not in a managed package mode
                        isNotNamespaceMode
                                ||
                                // standard object or field
                                isStandardObjectField(entity)
                                ||
                                // current namespace already there
                                hasCurrentNamespaceObjectField(entity)
                )
                        ?
                        entity
                        :
                        namespacePrefixObjectField + entity
                ;

    }



    /**
    * Add namespace prefix to keys (i.e. field names) in provided map
    */
    public static Map<String, Object> addNamespacePrefixToObjectField(Map<String, Object> fieldNameToValue) {

        Map<String, Object> prefixedFieldNameToValue = new Map<String, Object>();


        for (String fieldName : fieldNameToValue.keySet()) {

            prefixedFieldNameToValue.put(
                    addNamespacePrefixToObjectField(
                            fieldName
                    ),
                    fieldNameToValue.get(
                            fieldName
                    )
            );

        }


        return prefixedFieldNameToValue;

    }



    /**
    * Get local name for incoming entity (object or field)
    */
    public static String getObjectFieldLocalName(String entity) {

        return
                BaseUtilities.coalesce(entity).removeStartIgnoreCase(
                        namespacePrefixObjectField
                )
                ;

    }



    /**
    * Add namespace prefix to field path, e.g. Affiliation__r.From__r.Name
    */
    public static String addNamespacePrefixToFieldPath(String path) {

        String result = BaseUtilities.EMPTY;

        List<String> entities =
                path.split(
                        Pattern.quote(
                                OBJECT_FIELD_PATH_SEPARATOR
                        )
                )
        ;


        for (String entity : entities) {

            result += addNamespacePrefixToObjectField(entity) + OBJECT_FIELD_PATH_SEPARATOR;

        }


        return result.removeEndIgnoreCase(OBJECT_FIELD_PATH_SEPARATOR);

    }



    /**
    * Add namespace prefix to field paths
    */
    public static Set<String> addNamespacePrefixToFieldPaths(Set<String> paths) {

        Set<String> pathsWithNamespace = new Set<String>();


        for (String path : paths) {

            pathsWithNamespace.add(
                    addNamespacePrefixToFieldPath(path)
            );

        }


        return pathsWithNamespace;

    }



    /**
    * Add namespace prefix to columns for query
    */
    public static String addNamespacePrefixToColumnsForQuery(Set<String> pathsToQuery) {

        return
                BaseUtilities.SPACE
                        +
                        String.join(
                                BaseUtilities.toList(
                                        addNamespacePrefixToFieldPaths(
                                                pathsToQuery
                                        )
                                ),
                                BaseUtilities.COMMA_SPACE
                        )
                        +
                        BaseUtilities.SPACE
                ;

    }



    /**
    * Add namespace prefix to incoming field set
    */
    public static String addNamespacePrefixToFieldSet(String fieldSetName) {

        return
                (
                        // not in a managed package mode
                        isNotNamespaceMode
                                ||
                                // namespace already there
                                fieldSetName.containsIgnoreCase(
                                        NAMESPACE_SEPARATOR_FOR_OBJECT_FIELD
                                )
                )
                        ?
                        fieldSetName
                        :
                        namespacePrefixObjectField + fieldSetName
                ;

    }


}