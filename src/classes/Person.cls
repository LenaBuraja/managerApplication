public with sharing class Person {

	public Id id { get; set; }
	public String FirstName { get; set; }
	public String LastName { get; set; }
	public String MiddleName { get; set; }
	public String Phone { get; set; }
	public Decimal Experience { get; set; }
	public String Scype { get; set; }
	public String Email { get; set; }
	public Decimal Pay { get; set; }

	public Person() {
		this.id = null;
		this.FirstName = '';
		this.LastName = '';
		this.MiddleName = '';
		this.Phone = '';
		this.Experience = 0.0;
		this.Scype = '';
		this.Email = '';
		this.Pay = 0.0;
	}

}