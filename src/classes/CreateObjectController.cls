public class CreateObjectController {

	public String tocken { get; set; }

	public String FirstName { get; set; }
	public String LastName { get; set; }
	public String MiddleName { get; set; }
	public String Phone { get; set; }
	public Decimal Experience { get; set; }
	public String Scype { get; set; }
	public String Email { get; set; }
	public Decimal Pay { get; set; }

	public List<Employee__c> HR;
	public List<Employee_role__c> position;
	public List<Status_candi__c> status;
	public List<First_connection__c> firstConnection;
	public List<Coming__c> comming;

	public Id selectHRId { get; set; }
	public Id selectPositionId { get; set; }
	public Id selectStatusId { get; set; }
	public Id selectFirstConnectionId { get; set; }
	public Id selectCommingId { get; set; }

	public String userLogin { get; set; }
	public String firstPassword { get; set; }
	public String secondPassword { get; set; }

	public List<SelectOption> HRList
	{
		get
		{
			HR = [SELECT Person__r.Id, Person__r.FirstName__c, Person__r.LastName__c,
					Person__r.Middle_Name__c FROM Employee__c
					WHERE Employee_role__r.Title__c = 'HR' LIMIT 100];
			HRList = new List<SelectOption>();
			HRList.add(new SelectOption((Id)'a000A00000A00Anone', '--None--'));
			for(Employee__c person : HR) {
				HRList.add(new SelectOption(person.Person__r.Id, person.Person__r.LastName__c + ' ' + person.Person__r.FirstName__c + ' ' + person.Person__r.Middle_Name__c));
			}
			return HRList;
		}
		set;
	}

	public List<SelectOption> positionList
	{
		get
		{
			position = [SELECT Id, Title__c FROM Employee_role__c LIMIT 100];
			positionList = new List<SelectOption>();
			positionList.add(new SelectOption((Id)'a000A00000A00Anone', '--None--'));
			for(Employee_role__c item : position) {
				positionList.add(new SelectOption(item.Id, item.Title__c));
			}
			return positionList;
		}
		set;
	}

	public List<SelectOption> statusList
	{
		get
		{
			status = [SELECT Id, Title__c FROM Status_candi__c LIMIT 100];
			statusList = new List<SelectOption>();
			statusList.add(new SelectOption((Id)'a000A00000A00Anone', '--None--'));
			for(Status_candi__c item : status) {
				statusList.add(new SelectOption(item.Id, item.Title__c));
			}
			return statusList;
		}
		set;
	}

	public List<SelectOption> commingList
	{
		get
		{
			comming = [SELECT Id, Title__c FROM Coming__c LIMIT 5];
			commingList = new List<SelectOption>();
			commingList.add(new SelectOption((Id)'a000A00000A00Anone', '--None--'));
			for(Coming__c item : comming) {
				commingList.add(new SelectOption(item.Id, item.Title__c));
			}
			return commingList;
		}
		set;
	}

	public List<SelectOption> firstConnectionList
	{
		get
		{
			firstConnection = [SELECT Id, Title__c FROM First_connection__c LIMIT 100];
			firstConnectionList = new List<SelectOption>();
			firstConnectionList.add(new SelectOption((Id)'a000A00000A00Anone', '--None--'));
			for(First_connection__c item : firstConnection) {
				firstConnectionList.add(new SelectOption(item.Id, item.Title__c));
			}
			return firstConnectionList;
		}
		set;
	}

	public CreateObjectController() {
		//this.FirstName = '';
		//this.LastName = '';
		//this.MiddleName = '';
		//this.Phone = '';
		//this.Experience = 0.0;
		//this.Scype = '';
		//this.Email = '';
		//this.Pay = 0.0;
		//this.userLogin = '';
		//this.firstPassword = '';
		//this.secondPassword = '';
		tocken = ApexPages.currentPage().getCookies().get('userId').getValue();

	}

	public Id addPerson() {
		Person__c person = new Person__c();
		person.FirstName__c = this.FirstName;
		person.LastName__c = this.LastName;
		person.Middle_Name__c = this.MiddleName;
		person.Phone__c = this.Phone;
		person.Experience__c = (Decimal)this.Experience;
		person.Scype__c = this.Scype;
		person.Email__c = this.Email;
		person.Pay__c = (Decimal)this.Pay;
		Database.SaveResult result = Database.insert(person);
		return result.getId();
	}

	public Id addEmployee(Id personId) {
		Employee__c employee = new Employee__c();
		employee.Person__c = personId;
		employee.Employee_role__c = selectPositionId;	
		Database.SaveResult result = Database.insert(employee);
		return result.getId();
	}

	public Id addCandidate(Id personId) {
		Candidate__c candidate = new Candidate__c();
		candidate.Coming__c = selectCommingId;
		candidate.Description__c = '';
		candidate.Position__c = selectPositionId;
		candidate.First_connection__c = selectFirstConnectionId;
		candidate.HR__c = selectHRId;
		candidate.Person__c = personId;
		candidate.Status__c = selectStatusId;
		Database.SaveResult result = Database.insert(candidate);
		return result.getId();
	}

	public Id getPersonId() {
		String query = 'SELECT Id, FirstName__c, LastName__c, Middle_Name__c ' +
			' FROM Person__c ' +
			' WHERE FirstName__c = :FirstName ' +
			' AND LastName__c = :LastName ' +
			' AND Middle_Name__c = :MiddleName ' +
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

	public Boolean insertCandidate() {
		if (this.FirstName == '' || this.LastName == '' || this.MiddleName == '' ||
			this.Phone == '' || this.Scype == '' || this.Email == '' || this.Pay == 0.0 ||
			this.selectHRId == (Id)'a000A00000A00Anone' || 
			this.selectPositionId == (Id)'a000A00000A00Anone' ||
			this.selectStatusId == (Id)'a000A00000A00Anone' ||
			this.selectCommingId == (Id)'a000A00000A00Anone' ||
			this.selectFirstConnectionId == (Id)'a000A00000A00Anone') return false;
		Id personId = getPersonId();
		if (personId != null) return false;
		personId = addPerson();
		Id candidateId = addCandidate(personId);
		if (candidateId == null) return false;
		return true;
	}

	public Boolean insertEmployee() {
		if (this.FirstName == '' || this.LastName == '' || this.MiddleName == '' ||
			this.Phone == '' || this.Scype == '' || this.Email == '' || this.Pay == 0.0 ||
			this.selectPositionId == (Id)'a000A00000A00Anone') return false;
		Id personId = getPersonId();
		Id emplouyeeId;
		if (personId == null) {
			personId = addPerson();
		} else {
			emplouyeeId = getEmployeeId(personId);
			if (emplouyeeId != null) return false;
		}
		emplouyeeId = addEmployee(personId);
		if (emplouyeeId == null) return false;
		return true;
	}

	public Boolean addUser() {
		if (this.FirstName == '' || this.LastName == '' || this.MiddleName == '' 
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

	public PageReference forAddCandidate() {
		return null;
	}

	public PageReference forAddEmployee() {
		return null;
	}

	public PageReference forAddUser() {
		return null;
	}

	public PageReference submitAddCandidate() {

		if (insertCandidate()) return Page.AllLists;
		return ApexPages.currentPage();
	}

	public PageReference submitAddEmployee() {
		if (insertEmployee()) return Page.AllLists;
		return ApexPages.currentPage();
	}

	public PageReference submitAddUser() {
		if (addUser()) return Page.AllLists;
		return ApexPages.currentPage();
	}

	public PageReference submitAllList() {
		Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
		PageReference page = Page.AllLists;
		page.setCookies(new Cookie[]{cookieUserId});
		return page;
	}

	public PageReference submitAddNew() {
		Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
		PageReference page = Page.AddNew;
		page.setCookies(new Cookie[]{cookieUserId});
		return page;
	}

	public PageReference submitViewObject() {
		Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
		PageReference page = Page.CandidateReview;
		page.setCookies(new Cookie[]{cookieUserId});
		return page;
	}

	public PageReference submitPageManager() {
		//Id userId = this.tocken;
		Id employeeId = User.getEmployeeByUserId((Id)this.tocken);
		String position = User.getPosition(employeeId);
		if(position == 'Менеджер') {
			Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
			PageReference page = Page.CandidateReview;
			page.setCookies(new Cookie[]{cookieUserId});
			return page;	
		}
		return null;
	}

}