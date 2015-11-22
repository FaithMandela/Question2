
CREATE TABLE offices (
	office_id				varchar(12) primary key,
	office_name				text,
	sys_country_id			char(2) references sys_countrys,
	details					text
);

CREATE TABLE donor_groups (
	donor_group_id			varchar(12) primary key,
	donor_group_name		varchar(50) not null,
	details					text
);

CREATE TABLE donors (
	donorid				varchar(50) primary key,
	donorgroupid			varchar(12) references donorgroups,
	sys_country_id			char(2) references sys_countrys,
	donorname			varchar(50) not null,
	localdonor			boolean default false not null,
	memberdonor			boolean default false not null,
	headquarters			varchar(120),
	contactperson			varchar(120),
	address				varchar(120),
	town				varchar(120),
	email				varchar(120),
	telephone			varchar(120),
	fax				varchar(120),
	donorsummary			text,
	fundingsummary			text,
	details				text
);

CREATE TABLE themes (
	themeid				varchar(12) primary key,
	themename			varchar(50),
	details				text
);

CREATE TABLE subthemes (
	subthemeid			varchar(12) primary key,
	themeid				varchar(12) references themes,
	subthemename			varchar(50),
	details				text
);

CREATE TABLE programmes (
	programmeid           		varchar(50) primary key,
	sys_country_id			char(2) references sys_countrys,
   	programmename    		varchar(50) not null,
	areaprogramme			boolean default false not null,
	thematicprogramme		boolean default false not null,
	panafricanprogramme		boolean default false not null,
	location			varchar(50),
	address				varchar(120),
	town				varchar(120),
	email				varchar(120),
	telephone			varchar(120),
	fax				varchar(120),
	starteddate            		date,
	duration			integer,
	income				float,
	budget				float,
	femployees			integer,
	memployees			integer,
	programmebrief			text,
	history				text,
	objectives			text,
   	details               		text
);

CREATE TABLE proposals (
	proposalid			serial primary key,
	programmeid			varchar(50) references programmes,
	themeid				varchar(12) references themes,
	startdate			date,
	description			varchar(240),
	location			varchar(240),
	exchangecodeid			varchar(12) references exchangecodes,
	budget				float,
	proposal			text,
	details				text
);

CREATE TABLE proposalstatus (
	proposalstatusid		serial primary key,
	proposalstatuname		varchar(50),
	details				text
);

CREATE TABLE submissions (
	submissionid			serial primary key,
	proposalid          		integer references proposals,
	proposalstatusid		integer references proposalstatus,
	donorid				varchar(50) references donors,
	submitdatedate			date,
	email				varchar(120),
	approved			boolean,
	dropped				boolean,
	details				text
);

CREATE TABLE followup (
	followupid			serial primary key,
	submissionid			integer references submissions,
	submitdatedate			date,
	details				text
);

CREATE TABLE projects (
	projectid			varchar(50) primary key,
	programmeid			varchar(50) references programmes,
	sys_country_id			char(2) references sys_countrys,
 	projectname			varchar(50) not null,
	location			varchar(50),
	regionaldesk       		varchar(50),
	address				varchar(120),
	town				varchar(120),
	email				varchar(120),
	telephone			varchar(120),
	fax				varchar(120),
	startingdate			date,
	openingbalance			real,
	history				text,
	vision				text,
	mission				text,
	core				text,
	objectives			text,
	details				text
);

CREATE TABLE contracts (
	contractid			varchar(12) primary key,
	themeid				varchar(12) references themes,
	projectid			varchar(50) references projects,
	donorid                 	varchar(50) references donors,
	applicationref			varchar(50),
	currency			varchar(12),
	corefund			boolean,
	percentagelevy			real,
	contractref			varchar(50),
	decisiondate			date,
	contractdate			date,
	startofgrant			date,
	endofgrant			date,
	conditions			text,
	notes				text,
	subject				text,
	financing			text,
	reporting			text,
	operation			text,
	genconditions			text,
	speconditions			text,
	details				text
);

CREATE TABLE deadlines (
	deadlineid			serial primary key,
	contractid			varchar(12) references contracts,
	event				varchar(120),
	eventdate			date,
	email				varchar(120),
	details				text
);

CREATE TABLE grants (
	grantid             		serial primary key,
	contractid			varchar(12) references contracts,
	amount                 		real,
	prdate				date,
	details                		text
);

CREATE TABLE banking (
	bankid				serial primary key,
	contractid			varchar(12) references contracts,
	exchangecodeid			varchar(12) references exchangecodes,
	referenceno			varchar(12),
	receivedate			date,
	amount				real,
	exchangerate			real,
	details				text
);

CREATE TABLE budget (
	budgetid               		serial primary key,
	projectid              		varchar(50) references projects,
	subthemeid          		varchar(12) references subthemes,
	officeid			varchar(12) references offices,
	expenditure            		varchar(50),
	budgettype             		varchar(50),
	globalamount           		real,
	fieldamount			real,
	getbydate              		date,
	spendbydate            		date,
	details                		text
);

CREATE TABLE expenditure (
	expenditureid     	    	serial primary key,
   	projectid    		   	varchar(50) references projects,
	subthemeid          		varchar(12) references subthemes,
	officeid			varchar(12) references offices,
   	amount             		real,
	prdate				date,
   	details            		text
);


CREATE TABLE activities (
	activityid       	    	serial primary key,
	projectid          		varchar(50) references projects,
	subthemeid          		varchar(12) references subthemes,
	activity               		varchar(50) not null,
	impactrating			integer not null,
	startdate			date,
	closedate			date,
	details                		text
);

