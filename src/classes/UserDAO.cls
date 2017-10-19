public class UserDAO {
    
    public static List<User> getAllUsers() {
        
        return [SELECT Id, FirstName, LastName FROM User];
    }
    
    public static User getCurrentUser_IdFirstNameLastName() {
        
        return [SELECT Id, FirstName, LastName 
                FROM User 
                WHERE Id = :UserInfo.getUserId() LIMIT 1];
    }

}