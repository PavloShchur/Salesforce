public class RunnigUserCtrl {
    
    @AuraEnabled
    public static List<User> getUsers() {
        
        return UserDAO.getAllUsers();
        
    }

}