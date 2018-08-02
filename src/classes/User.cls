public with sharing class User {

	public String tocken { get; set; }

	public Employee__c employee;
	public String login { get; set; }
	public String password { get; set; }
	public String role { get; set; }
	public Id userId { get; set; }

	public User() {
		this.login = '';
		this.password = '';
		this.tocken = '';
		//this.employee = new Employee__c();
		//this.role = '';
	}

	public static Id getEmployeeByUserId(Id userId) {
		String query = ' SELECT Employee__c' +
			' FROM User_system__c ' +
			' WHERE Id = :userId ' +
			' LIMIT 1 ';
		User_system__c employee = (User_system__c)Database.query(query);
		return (Id)employee.Employee__c;
	}

	public static String getPosition(Id employeeId) {
		String query = ' SELECT Id, Employee_role__r.Title__c ' +
			' FROM Employee__c ' +
			' WHERE Id = :employeeId ' +
			' LIMIT 1 ';
		Employee__c employee = (Employee__c)Database.query(query);
		return employee.Employee_role__r.Title__c;
	}

	public Boolean signIn() {
		if (this.login == '' || this.password == '') return false;
		String query = ' SELECT Id, Password__c, Employee__c ' +
			' FROM User_system__c ' +
			' WHERE Login__c = :login ' +
			' LIMIT 1 ';
		List<User_system__c> users = (List<User_system__c>)Database.query(query);
		if (users.isEmpty() || this.password != (String)users.get(0).Password__c) {
			return false;
		}
		this.userId = users.get(0).Id;
		Id employeeId = users.get(0).Employee__c;
		this.employee = (Employee__c)Database.query(
			' SELECT Id, Person__c, Employee_role__c ' +
			' FROM Employee__c ' +
			' WHERE id = :employeeId ' +
			' LIMIT 1 '
		);
		Id roleId = this.employee.Employee_role__c;
		this.role = ((Employee_role__c)Database.query(
			' SELECT Title__c ' +
			' FROM Employee_role__c ' +
			' WHERE id = :roleId ' +
			' LIMIT 1 '
		)).Title__c;
		return true;
	}

	public Employee__c getTheEmployee() {
		return this.employee;
	}

	public PageReference gotoSignup() {
		return Page.Signup;
	}

	public PageReference submitSignIn() {
		if (signIn()) {
			Cookie cookieUserId = new Cookie('userId', this.userId, null, 315569260, false);
			PageReference page = Page.AllLists;
			page.setCookies(new Cookie[]{cookieUserId});
			return page;
		}
		return ApexPages.currentPage();
	}

}