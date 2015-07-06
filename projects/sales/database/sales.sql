CREATE TABLE product_category(
	product_category_id		serial primary key,
	product_category_name	varchar(100),
	details 				text
	);
INSERT INTO product_category(product_category_id,product_category_name,details) VALUES (1,'UNDEFINED','Default category');

CREATE TABLE product_brand(
	product_brand_id		serial primary key,
	product_brand_name			varchar(100),
	details					text
	);
INSERT INTO product_brand(product_brand_id,product_brand_name,details) VALUES(1,'UNDEFINED','Default brand');

CREATE TABLE product(
	product_id				serial primary key,
	product_name			varchar(100),
	product_version			varchar(50),
	product_category_id 	integer references product_category,
	product_brand_id		integer references product_brand,

	created_by				integer references entitys,				--logged in system user who did the insert
	created					date not null default current_date,
	remarks					text,

	updated_by			integer references entitys,				--logged in system user who did the last update
	updated				date,
	narrative			text,

	details 			text
	);

--leads can be initiated by either the sales guys, marketing, or other managers
CREATE TABLE sales_lead(
	sales_lead_id		serial primary key,	
	lead_code			varchar(20),
	lead_description	varchar(200),

	product_id			integer references product,				--the product associated wiht this lead

	lead_chaser_id		integer references entitys,				--staff incharge of following up this lead
	isdead				boolean default false not null,			--lead reached a dead end....	
	
	created_by			integer references entitys,				--logged in system user who did the insert
	created				date not null default current_date,
	remarks				text,

	updated_by			integer references entitys,				--logged in system user who did the last update
	updated				date,
	narrative			text,

	details 			text
	
	);
CREATE INDEX sales_lead_chaser_id ON sales_lead (lead_chaser_id);
CREATE INDEX sales_lead_created_by ON sales_lead (created_by);
CREATE INDEX sales_lead_updated_by ON sales_lead (updated_by);


--lead qualification checklists
--includes who, what, where, when, why
--eg Need, Budget, Authority,
CREATE TABLE checklist(
	checklist_id			serial primary key,
	checklist_value			varchar(200),			
	weight					integer default 1 not null check(weight > 0 AND weight <=10),	--relative weight/significance in the range 1-10

	created_by			integer references entitys,				--logged in system user who did the insert
	created				date not null default current_date,
	remarks				text,

	updated_by			integer references entitys,				--logged in system user who did the last update
	updated				date,
	narrative			text,

	--forindividual		boolean default true not null,
	--forcompany		boolean default true not null,
	--forcitizen		boolean default true not null,
	--forforeigners		boolean default true not null,

	isactive			boolean default true not null,			--usable checklist item

	details 			text
	);
CREATE INDEX checklist_created_by ON checklist (created_by);
CREATE INDEX checklist_updated_by ON checklist (updated_by);


--actual qualification process
CREATE TABLE lead_checklist(
	lead_checklist_id		serial primary key,
	sales_lead_id			integer references sales_lead,
	checklist_id			integer references checklist,
	
	result					varchar(500),		--the textual answer/reply to the checklist
	score					integer,	--must be within the range/bounds established for that particular checklist (weight in the checklist table). enforced by a trigger function
	
	isactive				boolean default true not null,			--we may chose to ignore/delete a checklist added accidentaly

	created_by			integer references entitys,				--logged in system user who did the insert
	created				date not null default current_date,
	remarks				text,

	updated_by			integer references entitys,				--logged in system user who did the last update
	updated				date,
	narrative			text,
	
	details 			text
	);
CREATE INDEX lead_checklist_sales_lead_id ON lead_checklist (sales_lead_id);
CREATE INDEX lead_checklist_checklist_id ON lead_checklist (checklist_id);
CREATE INDEX lead_checklist_created_by ON lead_checklist (created_by);
CREATE INDEX lead_checklist_updated_by ON lead_checklist (updated_by);


--follow up on qualified leads, now we can assign resources to this prospect
CREATE TABLE prospect(
	prospect_id				serial primary key,
	prospect_code			varchar(20),
	prospect_description 	varchar(200),

	sales_lead_id			integer references sales_lead,		--the lead that qualified to become this prospect
	entity_id				integer references entitys,			--prospective client

	product_id			integer references product,				--the product we want to sell, by default this should be copied from the lead. in practise what u initialy intended to sell may change

	created_by			integer references entitys,				--logged in system user who did the insert
	created				date not null default current_date,
	remarks				text,

	updated_by			integer references entitys,				--logged in system user who did the last update
	updated				date,
	narrative			text,
	
	details 			text
	);
CREATE INDEX prospect_sales_lead_id ON prospect (sales_lead_id);
CREATE INDEX prospect_entity_id ON prospect (entity_id);
CREATE INDEX prospect_product_id ON prospect (product_id);
CREATE INDEX prospect_created_by ON prospect (created_by);
CREATE INDEX prospect_updated_by ON prospect (updated_by);


--different prospects may need to undergo different phases before the deal is closed
--examples may include Introduction, Folow Up, Demo, Negotiation, Contract
CREATE TABLE phase(
	phase_id			serial primary key,
	phase_name			varchar(100),
	phase_description	varchar(500),	

	details 			text
	);


--define the phases a particular prospect has to undergo
--eg a WebApp prospect may go thru Intro, Demo, Contract. The precedence/order of execution must be defined
CREATE TABLE prospect_phase(
	prospect_phase_id	serial primary key,
	prospect_id			integer references prospect,
	phase_id			integer references phase,

	precedence			integer check(precedence > 0),			--used to prioritise/order the execution of the phases

	manager_id			integer references entitys,		--the manager/staff in charge of ensuring the execution/finalization of this job
	iscomplete			boolean default false,			--is this phase complete so that the next can be started ?

	--these two r just convenience fields
	last_staff_id		integer references entitys,		--the last guy to be forwarded this task in the workflow. updated by trigger on workflow after each forward
	last_task_date		date,							--

	created_by			integer references entitys,				--logged in system user who did the insert
	created				date not null default current_date,
	remarks				text,

	updated_by			integer references entitys,				--logged in system user who did the last update
	updated				date,
	narrative			text,
	
	details 			text
	
	);

CREATE INDEX prospect_phase_prospect_id ON prospect_phase (prospect_id);
CREATE INDEX prospect_phase_phase_id ON prospect_phase (phase_id);
CREATE INDEX prospect_phase_manager_id ON prospect_phase (manager_id);
CREATE INDEX prospect_phase_last_staff_id ON prospect_phase (last_staff_id);
CREATE INDEX prospect_phase_created_by ON prospect_phase (created_by);
CREATE INDEX prospect_phase_updated_by ON prospect_phase (updated_by);

--within a phase tasks may be moved back and forth (to seek approval/review) before the task can be considered completed
--example The Demo phase of a WebApp prospect may need the following(arbitrary) workflow; developer prepares prototype, manager approves prototype, admin hosts the demo, sales guy moves in, manager confirms all this
CREATE TABLE workflow(
	workflow_id			serial primary key,
	prospect_phase_id	integer references prospect_phase,

	staff_id			integer references entitys,
	
	isforwarded			boolean default false,			--wether or not it has been handed over to another/next guy
	
	created_by			integer references entitys,				--logged in system user who did the insert
	created				date not null default current_date,
	remarks				text,

	updated_by			integer references entitys,				--logged in system user who did the last update
	updated				date,
	narrative			text,
	
	details 			text
	);

CREATE INDEX workflow_prospect_phase_id ON workflow (prospect_phase_id);
CREATE INDEX workflow_staff_id ON workflow (staff_id);
CREATE INDEX workflow_created_by ON workflow (created_by);
CREATE INDEX workflow_updated_by ON workflow (updated_by);

