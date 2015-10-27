
CREATE VIEW programmeview AS
	SELECT DISTINCT programmes.programmeid, programmes.themeid, programmes.sys_country_id, 
		programmes.programmename, programmes.location, programmes.address, programmes.town, programmes.email,
		programmes.telephone, programmes.fax, programmes.starteddate, programmes.duration, programmes.income, 
		programmes.budget, programmes.femployees, programmes.memployees, programmes.programmebrief, 
		programmes.history, programmes.objectives, 
		programmes.thematicprogramme, programmes.areaprogramme, programmes.panafricanprogramme, programmes.details,
		sys_countrys.sys_country_name
	FROM ((programmes INNER JOIN sys_countrys ON programmes.sys_country_id=sys_countrys.sys_country_id) INNER JOIN
		themes ON programmes.themeid=themes.themeid) 
	ORDER BY sys_country_name;

CREATE VIEW programmecountryview AS
	SELECT DISTINCT programmes.programmename, programmes.programmeid,
			sys_countrys.sys_country_name, sys_countrys.sys_country_id 
	FROM programmes INNER JOIN sys_countrys ON programmes.sys_country_id=sys_countrys.sys_country_id;

CREATE VIEW donorview AS
	SELECT sys_countrys.sys_country_id, sys_countrys.sys_country_name, donorgroups.donorgroupid,
		donorgroups.donorgroupname, donors.donorid, donors.donorname, donors.headquarters, donors.contactperson, 
		donors.address, donors.town, donors.email, donors.telephone, donors.fax, donors.localdonor, 
		donors.memberdonor, donors.fundingsummary, donors.donorsummary, donors.details
	FROM ((sys_countrys INNER JOIN donors ON sys_countrys.sys_country_id = donors.sys_country_id)
		INNER JOIN donorgroups ON donors.donorgroupid = donorgroups.donorgroupid);

CREATE VIEW budgetview AS
	SELECT budget.budgetid, budget.expenditure, budget.budgettype, budget.globalamount, 
		budget.fieldamount, budget.getbydate, budget.spendbydate, budget.officeid,
		projects.projectid, projects.projectname, subthemes.subthemename
	FROM ((budget INNER JOIN projects ON budget.projectid=projects.projectid)	 
		INNER JOIN subthemes ON budget.subthemeid=subthemes.subthemeid);

CREATE VIEW contractview AS
	SELECT contracts.contractid, contracts.applicationref, contracts.currency, contracts.corefund, 
		contracts.percentagelevy, contracts.contractref, contracts.decisiondate, contracts.contractdate,
		contracts.startofgrant, contracts.endofgrant, contracts.conditions, contracts.notes, contracts.subject,
		contracts.financing, contracts.reporting, contracts.operation, contracts.genconditions, 
		contracts.speconditions, contracts.details, projects.projectid, projects.projectname, donors.donorname
	FROM ((contracts INNER JOIN projects ON contracts.projectid=projects.projectid) INNER JOIN donors ON 
		contracts.donorid=donors.donorid);

CREATE VIEW projectview AS
	SELECT  projects.projectid, projects.projectname, projects.location, projects.sys_country_id,
		projects.regionaldesk, projects.address, projects.town, projects.email, projects.telephone, projects.fax,
		projects.startingdate, projects.openingbalance, projects.history, projects.core,
		projects.objectives, projects.details, programmes.programmeid,
		programmes.programmename, programmes.income, programmes.budget, sys_countrys.sys_country_name
	FROM ((projects INNER JOIN programmes ON projects.programmeid= programmes.programmeid) 
		INNER JOIN sys_countrys ON projects.sys_country_id=sys_countrys.sys_country_id);

CREATE VIEW grantview AS
	SELECT grants.grantid, grants.contractid, grants.amount, grants.prdate, grants.details, contracts.contractref,
		projects.projectname	
	FROM ((grants INNER JOIN contracts ON grants.contractid=contracts.contractid) INNER JOIN projects ON
		projects.projectid=contracts.projectid);

CREATE VIEW bankingview AS
	SELECT banking.bankid, banking.contractid, banking.exchangecodeid, banking.referenceno, banking.receivedate,
		banking.amount, banking.exchangerate, banking.details, projects.projectname, programmes.programmename
	FROM (((banking INNER JOIN contracts ON banking.contractid=contracts.contractid) INNER JOIN projects ON 
		contracts.projectid=projects.projectid) INNER JOIN programmes ON 
		projects.programmeid=programmes.programmeid);

CREATE VIEW proposalview AS
	SELECT proposals.proposalid, proposals.programmeid, proposals.themeid, proposals.startdate, proposals.description,
		proposals.location, proposals.budget, proposals.proposal, proposals.details,
		programmes.programmename,themes.themename
	FROM ((proposals INNER JOIN programmes ON proposals.programmeid=programmes.programmeid) INNER JOIN themes ON
		proposals.themeid=themes.themeid);

CREATE VIEW submissionview AS
	SELECT submissions.submissionid, submissions.proposalid, submissions.proposalstatusid,	submissions.donorid,
		submissions.submitdatedate, submissions.email, submissions.approved, submissions.dropped, 
		submissions.details, proposals.description, proposalstatus.proposalstatuname, donors.donorname
	FROM (((submissions INNER JOIN proposals ON submissions.proposalid=proposals.proposalid) INNER JOIN proposalstatus
		ON submissions.proposalstatusid=proposalstatus.proposalstatusid) INNER JOIN donors ON
		submissions.donorid=donors.donorid);

CREATE VIEW activityview AS
	SELECT activities.activityid, activities.projectid, activities.activity, activities.startdate, activities.closedate,
		activities.details, activities.impactrating, activities.subthemeid, projects.projectname, subthemes.subthemename
	FROM ((activities INNER JOIN projects ON activities.projectid=projects.projectid) INNER JOIN subthemes
		 ON activities.subthemeid=subthemes.subthemeid);

CREATE VIEW expenditureview AS
	SELECT expenditure.expenditureid, expenditure.projectid, expenditure.officeid, 
		expenditure.amount, expenditure.prdate, expenditure.details, projects.projectname, 
		subthemes.subthemename, programmes.programmename
	FROM (((expenditure INNER JOIN subthemes ON expenditure.subthemeid=subthemes.subthemeid) INNER JOIN
		projects ON expenditure.projectid=projects.projectid) INNER JOIN programmes ON 
		projects.programmeid=programmes.programmeid);

CREATE VIEW deadlineview AS
	SELECT deadlines.deadlineid, deadlines.contractid, deadlines.event, deadlines.eventdate, deadlines.email, 
		deadlines.details, contracts.contractref, projects.projectname, projects.projectid
	FROM ((deadlines INNER JOIN contracts ON deadlines.contractid=contracts.contractid) INNER JOIN projects
		ON contracts.projectid=projects.projectid);

CREATE VIEW officeview AS
	SELECT offices.officeid, offices.officename, offices.sys_country_id, offices.details,
		sys_countrys.sys_country_name
	FROM offices INNER JOIN sys_countrys ON offices.sys_country_id=sys_countrys.sys_country_id;

CREATE VIEW themeview AS
	SELECT subthemes.subthemeid, subthemes.subthemename, subthemes.details,
		themes.themeid, themes.themename	
	FROM subthemes INNER JOIN themes ON subthemes.themeid=themes.themeid;	
	


