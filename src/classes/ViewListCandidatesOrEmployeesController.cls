public class ViewListCandidatesOrEmployeesController {

	public String listJSON { get; set; }
	public String tocken { get; set; }
	public String objectId { get; set; }
	public String objectType { get; set; }

	public ViewListCandidatesOrEmployeesController() {
		this.listJSON = '';
		tocken = ApexPages.currentPage().getCookies().get('userId').getValue();
	}

	public void getAllEmployees() {
		String query = ' SELECT Id, Person__r.LastName__c, Person__r.FirstName__c, ' + 
		' Person__r.Middle_Name__c, Person__r.Phone__c, Person__r.Experience__c, Person__r.Scype__c, ' +
		' Person__r.Email__c, Person__r.Pay__c, Employee_role__r.Title__c ' +
		' FROM Employee__c' +
		' LIMIT 100';
		List<Employee__c> employees = (List<Employee__c>)Database.query(query);
		this.listJSON = JSON.serialize(employees);
	}

	public void getAllCandidates() {
		String query = ' SELECT Id, Person__r.LastName__c, Person__r.FirstName__c, ' +
			' Person__r.Middle_Name__c, Person__r.Phone__c, Person__r.Experience__c, ' +
			' Person__r.Scype__c, Person__r.Email__c, Person__r.Pay__c, Status__r.Title__c, ' +
			' HR__r.LastName__c, HR__r.FirstName__c, HR__r.Middle_Name__c, ' +
			' Position__r.Title__c ' +
			' FROM Candidate__c ' +
			' LIMIT 100';
		List<Candidate__c> candidates = (List<Candidate__c>)Database.query(query);
		this.listJSON = JSON.serialize(candidates);
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
		Map<String, String> params = ApexPages.currentPage().getParameters();
		String objectId = params.get('objectId');
		String objectType = params.get('objectType');
		Cookie cookieObjectId = new Cookie('objectId', objectId, null, 315569260, false);
		Cookie cookieObjectType = new Cookie('objectType', objectType, null, 315569260, false);
		Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
		PageReference page = Page.CandidateReview;
		page.setCookies(new List<Cookie>{cookieUserId, cookieObjectId, cookieObjectType});
		return page;
	}

	public PageReference submitViewSelectObject() {
		Map<String, String> params = ApexPages.currentPage().getParameters();
		String objectId = params.get('objectId');
		String objectType = params.get('objectType');
		System.debug('-----------------' + objectId + ' ' + objectType);
		Cookie cookieObjectId = new Cookie('objectId',objectId, null, 315569260, false);
		Cookie cookieObjectType = new Cookie('objectType', objectType, null, 315569260, false);
		Cookie cookieUserId = new Cookie('userId', this.tocken, null, 315569260, false);
		PageReference page = Page.CandidateReview;
		page.setCookies(new List<Cookie>{cookieUserId, cookieObjectId, cookieObjectType});
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