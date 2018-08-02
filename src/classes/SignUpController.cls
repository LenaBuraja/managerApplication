public class SignUpController {

	public String tocken { get; set; }

	public Person person { get; set; }
	public String firstName { get; set; }
	public String lastName { get; set; }
	public String middleName { get; set; }
	public String userLogin { get; set; }
	public String firstPassword { get; set; }
	public String secondPassword { get; set; }
    
    public SignUpController() {
        this.firstName = '';
        this.lastName = '';
        this.middleName = '';
        this.userLogin = '';
        this.firstPassword = '';
        this.secondPassword = '';
		tocken = ApexPages.currentPage().getCookies().get('userId').getValue();
		//tocken = ApexPages.currentPage().getParameters().get('tocken');
    }

	public Id getPersonId() {
		String query = 'SELECT Id, FirstName__c, LastName__c, Middle_Name__c ' +
			' FROM Person__c ' +
			' WHERE FirstName__c = :firstName ' +
			' AND LastName__c = :lastName ' +
			' AND Middle_Name__c = :middleName ' +
			' LIMIT 1';
		List<Person__c> persons = (List<Person__c>)Database.query(query);
		return persons.isEmpty() ? null : persons.get(0).Id;
	}

	public static Id getEmployeeId(Id personId) {
		String query = 'SELECT Id ' +
			' FROM Employee__c ' +
			' WHERE Person__c = :personId ' +
			' LIMIT 1';
		List<Employee__c> employees = (List<Employee__c>)Database.query(query);
		return employees.isEmpty() ? null : employees.get(0).Id;
	}

	public Boolean signUp() {
		if (this.firstName == '' || this.lastName == '' || this.middleName == '' 
			|| this.userLogin == '' || this.firstPassword == '' || this.secondPassword == '' 
			|| this.firstPassword != this.secondPassword) return false;
		Id personId = getPersonId();
		if (personId == null) return false;
		Id employeeId = getEmployeeId(personId);
		if (employeeId == null) return false;
		String query = ' SELECT Password__c, Employee__c ' +
			' FROM User_system__c ' +
			' WHERE Login__c = :userLogin ' +
			' LIMIT 1 ';
		List<User_system__c> users = (List<User_system__c>)Database.query(query);
		if (!users.isEmpty()) return false;
		User_system__c inserUser = new User_system__c();
		inserUser.Login__c = this.userLogin;
		inserUser.Password__c = this.secondPassword;
		Employee__c empl = (Employee__c)Database.query(
			' SELECT Id, Person__c, Employee_role__c ' +
			' FROM Employee__c ' +
			' WHERE id = :employeeId ' +
			' LIMIT 1 '
		);
		inserUser.Employee__c = empl.Id;
		inserUser.Registration_time__c = Datetime.now();
		Id userId;
		Database.SaveResult result = Database.insert(inserUser);
			userId = result.getId();
		if (userId == null) return false;
		return true;
	}

	public PageReference submitSignUp() {
		if (signUp()) {
			Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
			PageReference page = Page.AddNew;
			page.setCookies(new Cookie[]{cookieUserId});
			return page;
		}
		return ApexPages.currentPage();
	}

}