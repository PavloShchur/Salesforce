public class UserCtrl {
    
    @AuraEnabled
    public static List<User> getUsers() {
        
        return UserDAO.getAllUsers();
        
    }
    
}