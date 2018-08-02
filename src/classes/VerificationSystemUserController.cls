public with sharing class VerificationSystemUserController {

//	public User user = new User();

//	public static void verification() {
//	User user = new User();
//		String query = 'SELECT Password__c, Employee__c ' +
//			' FROM User_system__c ' +
//			' WHERE Login__c =: ' + user.login +
//			' LIMIT 1';
//		List<User_system__c> listUsers = (List<User_system__c>)Database.query(query);
//		if (user.password == (String)listUsers.get(0).Password__c) {
//			ID id = listUsers.get(0).Employee__c;
//			user.theEmployee = (Employee__c)[SELECT Id, Person__c FROM Employee__c WHERE id =: id LIMIT 1];
//			String queryRole = 'SELECT Employee_role__r.Title__c ' +
//			' FROM Employee__c ' +
//			' WHERE id =:' + user.theEmployee.Id +
//			' LIMIT 1';
//		List<Employee__c> listRole = (List<Employee__c>)Database.query(query);
//		user.role = (String)listRole.get(0).Employee_role__r.Title__c;
//		}
//	}

}