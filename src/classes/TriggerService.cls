/**
* Service provides functionality to control handling of objects on trigger executions
* @author Maksym Yakymenko
*/

public abstract class TriggerService {

    private static final String NAME_FIELD = 'HandlerName__c';
    private static final String ACTIVE_FIELD = 'IsActive__c';
    private static final String DESCRIPTION_FIELD = 'Description__c';
    private static final String ORDER_FIELD = 'Order__c';
    private static final String TYPE_FIELD = 'Type__c';
    private static final String PERMISSION_FIELD = 'PermissionLevel__c';

    @TestVisible
    private static List<HandlerWrapper> allHandlerWrappers {

        get {

            if (allHandlerWrappers == null) {
                Set<String> handlerPermissions = getHandlerPermissions();

                allHandlerWrappers = convertHandlerSObjectsToHandlerWrappers(
                [
                        SELECT
                                Id,
                                HandlerName__c,
                                IsActive__c,
                                Description__c,
                                Order__c,
                                Type__c,
                                PermissionLevel__c
                        FROM
                                TriggerHandler__mdt
                        WHERE
                                PermissionLevel__c IN :handlerPermissions
                        ORDER BY Order__c ASC
                ]
                );

            }

            return allHandlerWrappers;
        }

        private set;
    }


    private static List<HandlerWrapper> allActiveHandlerWrappers {
        get {
            if (allActiveHandlerWrappers == null) {
                allActiveHandlerWrappers = filterTriggerHandlerWrappers(allHandlerWrappers,
                        new Map<String, Object> { ACTIVE_FIELD => true });
            }
            return allActiveHandlerWrappers;
        }

        private set;
    }

    public static void onTrigger() {

        if (Trigger.isExecuting) {
            executeActions(new Context(Trigger.old,
                    Trigger.oldMap,
                    Trigger.new,
                    Trigger.newMap,
                    Trigger.isBefore,
                    Trigger.isAfter,
                    Trigger.isInsert,
                    Trigger.isUpdate,
                    Trigger.isDelete,
                    Trigger.isUndelete));
        } else {
          //  throw new TriggerServiceException(Label.Error_Not_Trigger_Context);
        }
    }

    @TestVisible
    private static void executeActions(Context cont) {

        List<Handler> handlers = instantiateHandlers(getSObjectType(cont));

        for (Handler h : handlers) {
            // skip handler execution if requested
            if (h.skipExecution(cont)) {
                continue;
            }
            if (cont.isBefore) {
                if (cont.isInsert) {
                    h.beforeInsert(cont);
                } else if (cont.isUpdate) {
                    h.beforeUpdate(cont);
                } else if (cont.isDelete) {
                    h.beforeDelete(cont);
                } else if (cont.isUndelete) {
                    h.beforeUndelete(cont);
                }
            } else if (cont.isAfter) {
                if (cont.isInsert) {
                    h.afterInsert(cont);
                } else if (cont.isUpdate) {
                    h.afterUpdate(cont);
                } else if (cont.isDelete) {
                    h.afterDelete(cont);
                } else if (cont.isUndelete) {
                    h.afterUndelete(cont);
                }
            }
        }
    }

    /**
    * Determines type of the provided object from the trigger context.
    * @return Object type name
    */
    private static String getSObjectType(Context cont) {
        return (cont.isDelete ? cont.oldList : cont.newList).getSObjectType().getDescribe().getLocalName();
    }

    /**
    * Returns configured permission values. User defined settings have the highest priority,
    * the Profie settings go on the second place and finally if nothing is found
    * method will return org default permission values.
    * @return Set<String> Permission values
    */
    @TestVisible
    private static Set<String> getHandlerPermissions() {

        TriggerPermission__c triggerPermission = TriggerPermission__c.getInstance();

        Set<String> resultPermissions = processPermissions(triggerPermission);

        return resultPermissions;
    }

    /**
    * Processes configured comma separated permission string.
    * @return Set<String> Permission values
    */
    private static Set<String> processPermissions(TriggerPermission__c triggerPermission) {

        Set<String> resultPermissions = new Set<String>();

        String permissionLevel = triggerPermission.PermisionLevel__c;

        if (String.isNotBlank(permissionLevel)) {
            for (String permissionValue : permissionLevel.split(BaseUtilities.COMMA)) {
                if (String.isNotBlank(permissionValue)) {
                    resultPermissions.add(permissionValue.trim());
                }
            }
        }

        return resultPermissions;
    }

    /**
    * Return all the available trigger handler configurations by the provided object type name
    * @param sType - Object type name
    * @return All active handler configurations
    */
    private static List<HandlerWrapper> getAllActiveHandlerWrappersBySType(String sType) {
        List<HandlerWrapper> handlerWrappers = filterTriggerHandlerWrappers(allActiveHandlerWrappers,
                new Map<String, Object> { TYPE_FIELD => sType }
        );
        List<HandlerWrapper> result = handlerWrappers;

        return result;
    }

    /**
    * Return all the available trigger handler implementations by the provided object type name
    * @param sType Object type name
    * @return All active handlers
    */
    @TestVisible
    private static List<Handler> instantiateHandlers(String sType) {

        List<Handler> result = new List<Handler>();

        List<HandlerWrapper> handlerWrappers = getAllActiveHandlerWrappersBySType(sType);
        for (HandlerWrapper hw : handlerWrappers) {
            try {
                Type handlerType = Type.forName(hw.name);

                if (handlerType != null) {
                    result.add((Handler) handlerType.newInstance());
                } else {
                    System.debug(LoggingLevel.ERROR, 'TriggerService::onTrigger can\'t instantiate handler for setting: ' + hw);
                }
            } catch (Exception exp) {
                System.debug(LoggingLevel.ERROR, 'TriggerService::onTrigger exception instantiating handler for setting: ' + hw + ' Exception: ' + exp.getMessage());
            }
        }

        return result;
    }

    /**
    * Filters handler configurations by the provided field values
    * @param handlerWrappers List of handler configuration for check
    * @param fieldValueMap Field values for comparison
    * @return Filtered handler configurations
    */
    private static List<HandlerWrapper> filterTriggerHandlerWrappers(List<HandlerWrapper> handlerWrappers,
            Map<String, Object> fieldValueMap) {

        List<HandlerWrapper> result = new List<HandlerWrapper>();

        for (HandlerWrapper hw : handlerWrappers) {
            for (String field : fieldValueMap.keySet()) {
                Object value = fieldValueMap.get(field);
                Object tgValue = hw.get(field);

                if ((value != null && tgValue != null && value.equals(tgValue)) || (value == null && tgValue == null)) {
                    result.add(hw);
                }
            }
        }

        return result;
    }

    /**
    * Filters handler configurations by the provided exception handler's list
    * @param handlerWrappers List of handler configuration for check
    * @return Filtered handler configurations
    */
    private static Set<String> convertHandlerWrappersToNames(List<HandlerWrapper> handlerWrappers) {
        Set<String> result = new Set<String>();

        for (HandlerWrapper hw : handlerWrappers) {
            result.add(hw.name);
        }

        return result;
    }

    /**
    * Wraps handler configuration objects for more flexible usage
    * @param handlerSObjs Original handler configuration objects
    * @return Handler configuration wrappers
    */
    @TestVisible
    private static List<HandlerWrapper> convertHandlerSObjectsToHandlerWrappers(List<TriggerHandler__mdt> handlerSObjs) {
        List<HandlerWrapper> result = new List<HandlerWrapper>();

        for (TriggerHandler__mdt hSObj : handlerSObjs) {
            result.add(new HandlerWrapper(hSObj.HandlerName__c,
                    hSObj.IsActive__c,
                    hSObj.Description__c,
                    (Integer) hSObj.Order__c,
                    hSObj.Type__c,
                    hSObj.PermissionLevel__c
            ));
        }

        return result;
    }

    /**
    * Class provides entry points for object handling logic implementation
    */
    public virtual class Handler {

        public virtual Boolean skipExecution(Context cont) {
            return false; // do not skip by default
        }
        public virtual void beforeInsert(Context cont) {}
        public virtual void afterInsert(Context cont) {}
        public virtual void beforeUpdate(Context cont) {}
        public virtual void afterUpdate(Context cont) {}
        public virtual void beforeDelete(Context cont) {}
        public virtual void afterDelete(Context cont) {}
        public virtual void beforeUndelete(Context cont) {}
        public virtual void afterUndelete(Context cont) {}

    }

    /**
    * Class contains all the available data from the trigger context scope
    */
    public class Context {

        public List<SObject> oldList { get; set; }
        public Map<Id, SObject> oldMap { get; set; }

        public List<SObject> newList { get; set; }
        public Map<Id, SObject> newMap { get; set; }

        public Boolean isBefore { get; set; }
        public Boolean isAfter { get; set; }
        public Boolean isInsert { get; set; }
        public Boolean isUpdate { get; set; }
        public Boolean isDelete { get; set; }
        public Boolean isUndelete { get; set; }

        public Context(List<SObject> oldList, Map<Id, SObject> oldMap,
                List<SObject> newList, Map<Id, SObject> newMap,
                Boolean isBefore, Boolean isAfter,
                Boolean isInsert, Boolean isUpdate,
                Boolean isDelete, Boolean isUndelete) {

            this.oldList = oldList;
            this.oldMap = oldMap;
            this.newList = newList;
            this.newMap = newMap;
            this.isBefore = isBefore;
            this.isAfter = isAfter;
            this.isInsert = isInsert;
            this.isUpdate = isUpdate;
            this.isDelete = isDelete;
            this.isUndelete = isUndelete;
        }

    }

    /**
    * Custom exception for handling trigger service execution faults
    */
    private class TriggerServiceException extends Exception {}

    /**
    * Trigger handler configuration wrapper class for more flexible usage of the provided configuration
    */
    @TestVisible
    private class HandlerWrapper {

        public String name { get; set; }
        public Boolean active { get; set; }
        public String description { get; set; }
        public Integer order { get; set; }
        public String sType { get; set; }
        public String permission { get; set; }

        public HandlerWrapper(String name, Boolean active, String description, Integer order, String sType, String permission) {
            this.name = name;
            this.active = active;
            this.description = description;
            this.order = order;
            this.sType = sType;
            this.permission = permission;
        }

        /**
        * Returns configuration value by the provided field
        * @param field Original field name for retrieve
        * @return Configuraion value
        */
        public Object get(String field) {
            Object result;

            if (field == NAME_FIELD) {
                result = name;
            } else if (field == ACTIVE_FIELD) {
                result = active;
            } else if (field == DESCRIPTION_FIELD) {
                result = description;
            } else if (field == ORDER_FIELD) {
                result = order;
            } else if (field == TYPE_FIELD) {
                result = sType;
            } else if (field == PERMISSION_FIELD) {
                result = permission;
            }

            return result;
        }

        /**
        * Returns the stringified wrapped hadler cofiguration in more readable format
        * @return Stringified wrapped hadler
        */
        public override String toString() {
            return String.format('Handler Wrapper: <<HandlerName__c: {0}, IsActive__c: {1}, Description__c: {2}, Order__c: {3}, Type__c: {4}, PermissionLevel__c: {5}>>',
                    new List<String> {name, String.valueOf(active), description, String.valueOf(order), sType, permission}
            );
        }

    }

}