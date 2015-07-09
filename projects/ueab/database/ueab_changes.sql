
	



UPDATE sys_emails SET details = 'Dear {{name}},<br/><br/>

Thank you for applying to the University of Eastern Africa, Baraton.<br/>
To access form online use the the following information:<br/>
Username: {{username}} Password: {{password}}<br/><br/>


Go to http://registration.ueab.ac.ke/a_admissions.jsp<br/>
Using this link login with your username and password to complete your application.<br/>
Note: You can "Save" your application, and continue later until you are ready to "Complete and Exit".<br/>


Regards,<br/>
Admissions Office<br/>
University of Eastern Africa, Baraton<br/>
Eldoret<br/>
(254) 053-522625<br/>
admissions@ueab.ac.ke<br/>';

UPDATE fields SET question = 'Parent or Guardians commitment: I agree that the applicant may be a student at the University of Eastern Africa, Baraton. I am
ready to support the university in its effort to ensure that the applicant abides by the rules and principles of the university and
accepts the authority of its administration.'
WHERE field_id = 106;


UPDATE fields SET field_size = 150 WHERE field_id = 106;

   