public class ViewSelectObject {

	public String tocken { get; set; }
	public String objectType { get; set; }
	public Id objectId { get; set; }

	public String fullName { get; set; }
	public String phone { get; set; }
	public Decimal experience { get; set; }
	public String scype { get; set; }
	public String email { get; set; }
	public Decimal pay { get; set; }

	public String fullNameHR { get; set; }
	public String position { get; set; }
	public String status { get; set; }
	public String firstConnection { get; set; }
	public String comming { get; set; }

	public String userLogin { get; set; }
	public String password { get; set; }

	public ViewSelectObject() {
		//Map<String, System.Cookie[]> cookieMap =  
		//for(string cookieKey : cookieMap.keySet()) {
		//	if(cookieKey == 'userId') tocken = cookieMap.get(cookieKey).getValue();
		//	if(cookieKey == 'objectId') objectId = cookieMap.get(cookieKey).getValue();
		//	if(cookieKey == 'objectType') objectType = cookieMap.get(cookieKey).getValue();
		//}

		//tocken = ApexPages.currentPage().getCookies().get('userId').getValue();
		objectType = ApexPages.currentPage().getCookies().get('objectType').getValue();
		//objectId = ApexPages.currentPage().getCookies().get('objectId').getValue();
	}

	public void getPersonData(Id personId) {
		List<String> fields = new List<String>(Person__c.SObjectType.getDescribe().fields.getMap().keySet());
		String query = ' SELECT ' + String.join(fields, ', ') +
			' FROM Person__c ' +
			' WHERE id = :personId ' +
			' LIMIT 1';
		Person__c person = (Person__c)Database.query(query);
		this.fullName = person.LastName__c + ' ' + person.FirstName__c + ' ' + person.Middle_Name__c;
		this.phone = person.Phone__c;
		this.experience = person.Experience__c;
		this.scype = person.Scype__c;
		this.email = person.Email__c;
		this.pay = person.Pay__c;

	}

	public void viewCandidate() {
		List<String> fields = new List<String>(Candidate__c.SObjectType.getDescribe().fields.getMap().keySet());
		String query = ' SELECT ' + String.join(fields, ', ') +
			' FROM Candidate__c ' +
			' WHERE id = :objectId ' +
			' LIMIT 1';
		Candidate__c candidate = (Candidate__c)Database.query(query);
		getPersonData(candidate.Person__c);
		query = ' SELECT Coming__r.Title__c, Position__r.Title__c, First_connection__r.Title, ' +
			' Status__r.Title__c, HR__r.LastName__c, HR__r.FirstName__c, HR__r.Middle_Name__c' +
			' FROM Candidate__c ' +
			' WHERE id = :objectId ' +
			' LIMIT 1';
		candidate = (Candidate__c)Database.query(query);
		this.fullNameHR = candidate.HR__r.LastName__c +' ' + candidate.HR__r.FirstName__c + ' ' + candidate.HR__r.Middle_Name__c;
		this.position = candidate.Position__r.Title__c;
		this.status = candidate.Status__r.Title__c;
		this.firstConnection = candidate.First_connection__r.Title__c;
		this.comming = candidate.Coming__r.Title__c;
	}

	public void viewEmployee() {
		List<String> fields = new List<String>(Employee__c.SObjectType.getDescribe().fields.getMap().keySet());
		String query = ' SELECT ' + String.join(fields, ', ') +
			' FROM Employee__c ' +
			' WHERE id = :objectId ' +
			' LIMIT 1';
		Employee__c employee = (Employee__c)Database.query(query);
		getPersonData(employee.Person__c);
		this.position = User.getPosition(employee.Id);
	}

	public void viewUser() {
		List<String> fields = new List<String>(User_system__c.SObjectType.getDescribe().fields.getMap().keySet());
		String query = ' SELECT ' + String.join(fields, ', ') + 'Employee__r.Person__c ' +
			' FROM User_system__c ' +
			' WHERE id = :objectId ' +
			' LIMIT 1';
		User_system__c user = (User_system__c)Database.query(query);
		getPersonData(user.Employee__r.Person__c);
	}

	public PageReference submitAllList() {
		Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
		PageReference page = Page.AllLists;
		page.setCookies(new Cookie[]{cookieUserId});
		return page;
	}

	public PageReference submitAddNew() {
		Id employeeId = User.getEmployeeByUserId((Id)this.tocken);
		String position = User.getPosition(employeeId);
		if(position == 'Разработчик') {
			Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
			PageReference page = Page.AddNew;
			page.setCookies(new Cookie[]{cookieUserId});
			return page;
			}
		return null;
	}

	public PageReference submitViewObject() {
		Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
		PageReference page = Page.CandidateReview;
		page.setCookies(new Cookie[]{cookieUserId});
		return page;
	}

	public PageReference submitViewSelectObject(Id objectId, String objectType) {
		Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
		Cookie cookieObjectId = new Cookie('objectId', objectId, null, 315569260, false);
		Cookie cookieObjectType = new Cookie('objectType', objectType, null, 315569260, false);
		PageReference page = Page.CandidateReview;
		page.setCookies(new Cookie[]{cookieUserId, cookieObjectId, cookieObjectType});
		return page;
	}

	public PageReference submitPageManager() {
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
