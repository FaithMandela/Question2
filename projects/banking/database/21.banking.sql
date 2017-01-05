---Project Database File
create table payment_type (
  payment_type_id smallint auto_increment not null,
  payment_type_lookup_id integer,
  primary key(payment_type_id),
  foreign key(payment_type_lookup_id)
    references lookup_value(lookup_id)
      on delete no action
      on update no action
);

create table fee_type (
  fee_type_id smallint not null,
  fee_lookup_id smallint,
  flat_or_rate smallint,
  formula varchar(100),
  primary key(fee_type_id),
  foreign key(fee_lookup_id)
    references lookup_entity(entity_id)
      on delete no action
      on update no action
);

create table fees (
  fee_id smallint auto_increment not null,
  global_fee_num varchar(50),
  fee_name varchar(50) not  null,
  fee_payments_category_type_id smallint,
  office_id smallint not null,
  glcode_id smallint  not null,
  status smallint not null,
  category_id smallint not null,
  rate_or_amount decimal(16,5),
  rate_or_amount_currency_id smallint,
  rate_flat_falg smallint,
  created_date date  not null,
  created_by smallint  not null,
  updated_date date,
  updated_by smallint,
  update_flag  smallint,
  formula_id smallint,
  default_admin_fee varchar(10),
  fee_amount decimal(21,4) ,
  fee_amount_currency_id smallint,
  rate decimal(16,5),
  version_no integer not null,
  discriminator varchar(20),
  primary key  (fee_id),
  foreign key (glcode_id)
    references gl_code (glcode_id)
    on delete no action
    on update no action,
  foreign key (category_id)
    references category_type (category_id)
    on delete no action
    on update no action,
  foreign key (status)
    references fee_status (status_id)
    on delete no action
    on update no action,
  foreign key (office_id)
    references office (office_id)
    on delete no action
    on update no action,
  foreign key (created_by)
    references personnel (personnel_id)
    on delete no action
    on update no action,
  foreign key (updated_by)
    references personnel (personnel_id)
    on delete no action
    on update no action,
  foreign key (formula_id)
    references fee_formula_master (formulaid)
    on delete no action
    on update no action,
  foreign key(rate_or_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(fee_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action
);


CREATE TABLE m_savings_product (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  description varchar(500) NOT NULL,
  currency_code varchar(3) NOT NULL,
  currency_digits smallint(5) NOT NULL,
  nominal_interest_rate_per_period decimal(19,6) NOT NULL,
  nominal_interest_rate_period_frequency_enum smallint(5) NOT NULL,
  min_required_opening_balance decimal(19,6) DEFAULT NULL,
  lockin_period_frequency decimal(19,6) DEFAULT NULL,
  lockin_period_frequency_enum smallint(5) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY sp_unq_name (name)
);

CREATE TABLE m_product_loan (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  currency_code varchar(3) NOT NULL,
  currency_digits smallint(5) NOT NULL,
  principal_amount decimal(19,6) NOT NULL,
  arrearstolerance_amount decimal(19,6) DEFAULT NULL,
  name varchar(100) NOT NULL,
  description varchar(500) DEFAULT NULL,
  fund_id bigint(20) DEFAULT NULL,
  nominal_interest_rate_per_period decimal(19,6) NOT NULL,
  interest_period_frequency_enum smallint(5) NOT NULL,
  annual_nominal_interest_rate decimal(19,6) NOT NULL,
  interest_method_enum smallint(5) NOT NULL,
  interest_calculated_in_period_enum smallint(5) NOT NULL DEFAULT '1',
  repay_every smallint(5) NOT NULL,
  repayment_period_frequency_enum smallint(5) NOT NULL,
  number_of_repayments smallint(5) NOT NULL,
  amortization_method_enum smallint(5) NOT NULL,
  accounting_type smallint(5) NOT NULL,
  loan_transaction_strategy_id bigint(20) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unq_name (name),
  KEY FKA6A8A7D77240145 (fund_id),
  KEY FK_ltp_strategy (loan_transaction_strategy_id),
  CONSTRAINT FKA6A8A7D77240145 FOREIGN KEY (fund_id) REFERENCES m_fund (id),
  CONSTRAINT FK_ltp_strategy FOREIGN KEY (loan_transaction_strategy_id) REFERENCES ref_loan_transaction_processing_strategy (id)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE account_types (
	id int(11) NOT NULL AUTO_INCREMENT,
	name varchar(100) NOT NULL,
	charge_mode varchar(2) NOT NULL,
	run_mode varchar(1) NOT NULL,
	payment_direction varchar(1) NOT NULL,
	enabled bit(1) NOT NULL,
	amount decimal(15,6) NOT NULL,
	account_type_id int(11) NOT NULL,
	invoice_mode varchar(1) DEFAULT NULL,
	description longtext,
	enabled_since datetime DEFAULT NULL,
	day tinyint(4) DEFAULT NULL,
	hour tinyint(4) DEFAULT NULL,
	free_base decimal(15,6) DEFAULT NULL,
	transfer_type_id int(11) NOT NULL,
	recurrence_number int(11) DEFAULT NULL,
	recurrence_field int(11) DEFAULT NULL,
);


CREATE TABLE accounts (
	id int(11) NOT NULL AUTO_INCREMENT,
	currency_id int(11) NOT NULL,
	subclass varchar(1) NOT NULL,
	creation_date datetime NOT NULL,
	last_closing_date date DEFAULT NULL,
	owner_name varchar(255) NOT NULL,
	type_id int(11) DEFAULT NULL,
	credit_limit decimal(15,6) DEFAULT NULL,
	upper_credit_limit decimal(15,6) DEFAULT NULL,
	member_id int(11) DEFAULT NULL,
	member_status varchar(1) DEFAULT NULL,
	last_low_units_sent datetime DEFAULT NULL,
	member_action varchar(1) DEFAULT NULL
);

CREATE TABLE m_savings_account (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  account_no varchar(20) NOT NULL,
  external_id varchar(100) DEFAULT NULL,
  client_id bigint(20) DEFAULT NULL,
  group_id bigint(20) DEFAULT NULL,
  product_id bigint(20) DEFAULT NULL,
  status_enum smallint(5) NOT NULL DEFAULT '300',
  activation_date date DEFAULT NULL,
  currency_code varchar(3) NOT NULL,
  currency_digits smallint(5) NOT NULL,
  nominal_interest_rate_per_period decimal(19,6) NOT NULL,
  nominal_interest_rate_period_frequency_enum smallint(5) NOT NULL,
  annual_nominal_interest_rate decimal(19,6) NOT NULL,
  min_required_opening_balance decimal(19,6) DEFAULT NULL,
  lockin_period_frequency decimal(19,6) DEFAULT NULL,
  lockin_period_frequency_enum smallint(5) DEFAULT NULL,
  lockedin_until_date_derived date DEFAULT NULL,
  total_deposits_derived decimal(19,6) DEFAULT NULL,
  total_withdrawals_derived decimal(19,6) DEFAULT NULL,
  total_interest_posted_derived decimal(19,6) DEFAULT NULL,
  account_balance_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  PRIMARY KEY (id),

  CONSTRAINT FKSA00000000000001 FOREIGN KEY (client_id) REFERENCES m_client (id),
  CONSTRAINT FKSA00000000000002 FOREIGN KEY (group_id) REFERENCES m_group (id),
  CONSTRAINT FKSA00000000000003 FOREIGN KEY (product_id) REFERENCES m_savings_product (id)
);

CREATE TABLE m_savings_account_transaction (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  savings_account_id bigint(20) NOT NULL,
  transaction_type_enum smallint(5) NOT NULL,
  transaction_date date NOT NULL,
  amount decimal(19,6) NOT NULL,
  is_reversed tinyint(1) NOT NULL,

  CONSTRAINT FKSAT0000000001 FOREIGN KEY (savings_account_id) REFERENCES m_savings_account (id)
);

create table account_activity (
  activity_id integer auto_increment not null,
  account_id integer not null,
  personnel_id smallint not null,
  activity_name varchar(50) not null,
  principal decimal(21,4),
  principal_currency_id smallint,
  principal_outstanding decimal(21,4),
  principal_outstanding_currency_id smallint,
  interest decimal(13, 10),
  interest_currency_id smallint,
  interest_outstanding decimal(13, 10),
  interest_outstanding_currency_id smallint,
  fee decimal(13, 2),
  fee_currency_id smallint,
  fee_outstanding decimal(13, 2),
  fee_outstanding_currency_id smallint,
  penalty decimal(13, 10),
  penalty_currency_id smallint,
  penalty_outstanding decimal(13, 10),
  penalty_outstanding_currency_id smallint,
  primary key(activity_id),
  foreign key(account_id)
    references account(account_id)
      on delete no action
      on update no action,
 foreign key(principal_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
 foreign key(principal_outstanding_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
 foreign key(interest_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
 foreign key(interest_outstanding_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
 foreign key(fee_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
 foreign key(fee_outstanding_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
 foreign key(penalty_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
 foreign key(penalty_outstanding_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action
);

create table account_notes (
  account_notes_id integer  auto_increment not null,
  account_id integer not null,
  note varchar(500) not null,
  comment_date date not null,
  officer_id smallint not null,
  primary key(account_notes_id),
  foreign key(account_id)
    references account(account_id)
      on delete no action
      on update no action,
  foreign key(officer_id)
    references personnel(personnel_id)
      on delete no action
      on update no action
)
;


CREATE TABLE account_fee_amounts (
	id int(11) NOT NULL AUTO_INCREMENT,
	account_id int(11) NOT NULL,
	date date NOT NULL,
	available_balance decimal(18,6) NOT NULL,
	amount decimal(15,6) NOT NULL,
	account_fee_id int(11) NOT NULL
);

CREATE TABLE client additional data (
  client_id bigint(20) NOT NULL,
  Gender_cd int(11) NOT NULL,
  Date of Birth date NOT NULL,
  Home address text NOT NULL,
  Telephone number varchar(20) NOT NULL,
  Telephone number (2nd) varchar(20) NOT NULL,
  Email address varchar(50) NOT NULL,
  EducationLevel_cd int(11) NOT NULL,
  MaritalStatus_cd int(11) NOT NULL,
  Number of children int(11) NOT NULL,
  Citizenship varchar(50) NOT NULL,
  PovertyStatus_cd int(11) NOT NULL,
  YesNo_cd_Employed int(11) NOT NULL,
  FieldOfEmployment_cd_Field of employment int(11) DEFAULT NULL,
  Employer name varchar(50) DEFAULT NULL,
  Number of years int(11) DEFAULT NULL,
  Monthly salary decimal(19,6) DEFAULT NULL,
  YesNo_cd_Self employed int(11) NOT NULL,
  FieldOfEmployment_cd_Field of self-employment int(11) DEFAULT NULL,
  Business address text,
  Number of employees int(11) DEFAULT NULL,
  Monthly salaries paid decimal(19,6) DEFAULT NULL,
  Monthly net income of business activity decimal(19,6) DEFAULT NULL,
  Monthly rent decimal(19,6) DEFAULT NULL,
  Other income generating activities varchar(100) DEFAULT NULL,
  YesNo_cd_Bookkeeping int(11) DEFAULT NULL,
  YesNo_cd_Loans with other institutions int(11) NOT NULL,
  From whom varchar(100) DEFAULT NULL,
  Amount decimal(19,6) DEFAULT NULL,
  Interest rate pa decimal(19,6) DEFAULT NULL,
  Number of people depending on overal income int(11) NOT NULL,
  YesNo_cd_Bank account int(11) NOT NULL,
  YesNo_cd_Business plan provided int(11) NOT NULL,
  YesNo_cd_Access to internet int(11) DEFAULT NULL,
  Introduced by varchar(100) DEFAULT NULL,
  Known to introducer since varchar(100) NOT NULL,
  Last visited by varchar(100) DEFAULT NULL,
  Last visited on date NOT NULL,
  PRIMARY KEY (client_id),
  CONSTRAINT FK_client_additional_data FOREIGN KEY (client_id) REFERENCES m_client (id)
);


CREATE TABLE extra_client_details (
  client_id bigint(20) NOT NULL,
  Business Description varchar(100) DEFAULT NULL,
  Years in Business int(11) DEFAULT NULL,
  Gender_cd int(11) DEFAULT NULL,
  Education_cv varchar(60) DEFAULT NULL,
  Next Visit date DEFAULT NULL,
  Highest Rate Paid decimal(19,6) DEFAULT NULL,
  Comment text,
  PRIMARY KEY (client_id),
  CONSTRAINT FK_extra_client_details FOREIGN KEY (client_id) REFERENCES m_client (id)
);


CREATE TABLE impact measurement (
  loan_id bigint(20) NOT NULL,
  YesNo_cd_RepaidOnSchedule int(11) NOT NULL,
  ReasonNotRepaidOnSchedule text,
  How was Loan Amount Invested text NOT NULL,
  Additional Income Generated decimal(19,6) NOT NULL,
  Additional Income Used For text NOT NULL,
  YesNo_cd_NewJobsCreated int(11) NOT NULL,
  Number of Jobs Created bigint(20) DEFAULT NULL,
  PRIMARY KEY (loan_id),
  CONSTRAINT FK_impact measurement FOREIGN KEY (loan_id) REFERENCES m_loan (id)
);

CREATE TABLE m_loan (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  account_no varchar(20) NOT NULL,
  external_id varchar(100) DEFAULT NULL,
  client_id bigint(20) DEFAULT NULL,
  group_id bigint(20) DEFAULT NULL,
  product_id bigint(20) DEFAULT NULL,
  fund_id bigint(20) DEFAULT NULL,
  loan_officer_id bigint(20) DEFAULT NULL,
  loanpurpose_cv_id int(11) DEFAULT NULL,
  loan_status_id smallint(5) NOT NULL,
  currency_code varchar(3) NOT NULL,
  currency_digits smallint(5) NOT NULL,
  principal_amount decimal(19,6) NOT NULL,
  arrearstolerance_amount decimal(19,6) DEFAULT NULL,
  nominal_interest_rate_per_period decimal(19,6) NOT NULL,
  interest_period_frequency_enum smallint(5) NOT NULL,
  annual_nominal_interest_rate decimal(19,6) NOT NULL,
  interest_method_enum smallint(5) NOT NULL,
  interest_calculated_in_period_enum smallint(5) NOT NULL DEFAULT '1',
  term_frequency smallint(5) NOT NULL DEFAULT '0',
  term_period_frequency_enum smallint(5) NOT NULL DEFAULT '2',
  repay_every smallint(5) NOT NULL,
  repayment_period_frequency_enum smallint(5) NOT NULL,
  number_of_repayments smallint(5) NOT NULL,
  amortization_method_enum smallint(5) NOT NULL,
  submittedon_date date DEFAULT NULL,
  submittedon_userid bigint(20) DEFAULT NULL,
  approvedon_date date DEFAULT NULL,
  approvedon_userid bigint(20) DEFAULT NULL,
  expected_disbursedon_date date DEFAULT NULL,
  expected_firstrepaymenton_date date DEFAULT NULL,
  interest_calculated_from_date date DEFAULT NULL,
  disbursedon_date date DEFAULT NULL,
  disbursedon_userid bigint(20) DEFAULT NULL,
  expected_maturedon_date date DEFAULT NULL,
  maturedon_date date DEFAULT NULL,
  closedon_date date DEFAULT NULL,
  closedon_userid bigint(20) DEFAULT NULL,
  total_charges_due_at_disbursement_derived decimal(19,6) DEFAULT NULL,
  principal_disbursed_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  principal_repaid_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  principal_writtenoff_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  principal_outstanding_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  interest_charged_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  interest_repaid_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  interest_waived_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  interest_writtenoff_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  interest_outstanding_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  fee_charges_charged_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  fee_charges_repaid_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  fee_charges_waived_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  fee_charges_writtenoff_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  fee_charges_outstanding_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  penalty_charges_charged_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  penalty_charges_repaid_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  penalty_charges_waived_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  penalty_charges_writtenoff_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  penalty_charges_outstanding_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  total_expected_repayment_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  total_repayment_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  total_expected_costofloan_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  total_costofloan_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  total_waived_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  total_writtenoff_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  total_outstanding_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  rejectedon_date date DEFAULT NULL,
  rejectedon_userid bigint(20) DEFAULT NULL,
  rescheduledon_date date DEFAULT NULL,
  withdrawnon_date date DEFAULT NULL,
  withdrawnon_userid bigint(20) DEFAULT NULL,
  writtenoffon_date date DEFAULT NULL,
  loan_transaction_strategy_id bigint(20) DEFAULT NULL,

  CONSTRAINT FK7C885877240145 FOREIGN KEY (fund_id) REFERENCES m_fund (id),
  CONSTRAINT FKB6F935D87179A0CB FOREIGN KEY (client_id) REFERENCES m_client (id),
  CONSTRAINT FKB6F935D8C8D4B434 FOREIGN KEY (product_id) REFERENCES m_product_loan (id),
  CONSTRAINT FK_approvedon_userid FOREIGN KEY (approvedon_userid) REFERENCES m_appuser (id),
  CONSTRAINT FK_closedon_userid FOREIGN KEY (closedon_userid) REFERENCES m_appuser (id),
  CONSTRAINT FK_disbursedon_userid FOREIGN KEY (disbursedon_userid) REFERENCES m_appuser (id),
  CONSTRAINT FK_loan_ltp_strategy FOREIGN KEY (loan_transaction_strategy_id) REFERENCES ref_loan_transaction_processing_strategy (id),
  CONSTRAINT FK_m_loanpurpose_codevalue FOREIGN KEY (loanpurpose_cv_id) REFERENCES m_code_value (id),
  CONSTRAINT FK_m_loan_m_staff FOREIGN KEY (loan_officer_id) REFERENCES m_staff (id),
  CONSTRAINT FK_rejectedon_userid FOREIGN KEY (rejectedon_userid) REFERENCES m_appuser (id),
  CONSTRAINT FK_submittedon_userid FOREIGN KEY (submittedon_userid) REFERENCES m_appuser (id),
  CONSTRAINT FK_withdrawnon_userid FOREIGN KEY (withdrawnon_userid) REFERENCES m_appuser (id),
  CONSTRAINT m_loan_ibfk_1 FOREIGN KEY (group_id) REFERENCES m_group (id)
);


CREATE TABLE m_guarantor (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  loan_id bigint(20) NOT NULL,


CREATE TABLE m_loan_charge (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  loan_id bigint(20) NOT NULL,
  charge_id bigint(20) NOT NULL,
  is_penalty tinyint(1) NOT NULL DEFAULT '0',
  charge_time_enum smallint(5) NOT NULL,
  due_for_collection_as_of_date date DEFAULT NULL,
  charge_calculation_enum smallint(5) NOT NULL,
  calculation_percentage decimal(19,6) DEFAULT NULL,
  calculation_on_amount decimal(19,6) DEFAULT NULL,
  amount decimal(19,6) NOT NULL,
  amount_paid_derived decimal(19,6) DEFAULT NULL,
  amount_waived_derived decimal(19,6) DEFAULT NULL,
  amount_writtenoff_derived decimal(19,6) DEFAULT NULL,
  amount_outstanding_derived decimal(19,6) NOT NULL DEFAULT '0.000000',
  is_paid_derived tinyint(1) NOT NULL DEFAULT '0',
  waived tinyint(1) NOT NULL DEFAULT '0',

  CONSTRAINT m_loan_charge_ibfk_1 FOREIGN KEY (charge_id) REFERENCES m_charge (id),
  CONSTRAINT m_loan_charge_ibfk_2 FOREIGN KEY (loan_id) REFERENCES m_loan (id)
);


CREATE TABLE m_loan_repayment_schedule (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  loan_id bigint(20) NOT NULL,
  fromdate date DEFAULT NULL,
  duedate date NOT NULL,
  installment smallint(5) NOT NULL,
  principal_amount decimal(19,6) DEFAULT NULL,
  principal_completed_derived decimal(19,6) DEFAULT NULL,
  principal_writtenoff_derived decimal(19,6) DEFAULT NULL,
  interest_amount decimal(19,6) DEFAULT NULL,
  interest_completed_derived decimal(19,6) DEFAULT NULL,
  interest_writtenoff_derived decimal(19,6) DEFAULT NULL,
  fee_charges_amount decimal(19,6) DEFAULT NULL,
  fee_charges_completed_derived decimal(19,6) DEFAULT NULL,
  fee_charges_writtenoff_derived decimal(19,6) DEFAULT NULL,
  fee_charges_waived_derived decimal(19,6) DEFAULT NULL,
  penalty_charges_amount decimal(19,6) DEFAULT NULL,
  penalty_charges_completed_derived decimal(19,6) DEFAULT NULL,
  penalty_charges_writtenoff_derived decimal(19,6) DEFAULT NULL,
  penalty_charges_waived_derived decimal(19,6) DEFAULT NULL,
  completed_derived bit(1) NOT NULL,
  createdby_id bigint(20) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  lastmodified_date datetime DEFAULT NULL,
  lastmodifiedby_id bigint(20) DEFAULT NULL,
  interest_waived_derived decimal(19,6) DEFAULT NULL,

  CONSTRAINT FK488B92AA40BE0710 FOREIGN KEY (loan_id) REFERENCES m_loan (id)
);


CREATE TABLE m_loan_transaction (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  loan_id bigint(20) NOT NULL,
  is_reversed tinyint(1) NOT NULL,
  transaction_type_enum smallint(5) NOT NULL,
  transaction_date date NOT NULL,
  amount decimal(19,6) NOT NULL,
  principal_portion_derived decimal(19,6) DEFAULT NULL,
  interest_portion_derived decimal(19,6) DEFAULT NULL,
  fee_charges_portion_derived decimal(19,6) DEFAULT NULL,
  penalty_charges_portion_derived decimal(19,6) DEFAULT NULL,

  CONSTRAINT FKCFCEA42640BE0710 FOREIGN KEY (loan_id) REFERENCES m_loan (id)
);

CREATE TABLE m_note (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  client_id bigint(20) DEFAULT NULL,
  group_id bigint(20) DEFAULT NULL,
  loan_id bigint(20) DEFAULT NULL,
  loan_transaction_id bigint(20) DEFAULT NULL,
  note_type_enum smallint(5) NOT NULL,
  note varchar(1000) DEFAULT NULL,
  created_date datetime DEFAULT NULL,
  createdby_id bigint(20) DEFAULT NULL,
  lastmodified_date datetime DEFAULT NULL,
  lastmodifiedby_id bigint(20) DEFAULT NULL,

  CONSTRAINT FK7C9708924D26803 FOREIGN KEY (loan_transaction_id) REFERENCES m_loan_transaction (id),
  CONSTRAINT FK7C9708940BE0710 FOREIGN KEY (loan_id) REFERENCES m_loan (id),
  CONSTRAINT FK7C97089541F0A56 FOREIGN KEY (createdby_id) REFERENCES m_appuser (id),
  CONSTRAINT FK7C970897179A0CB FOREIGN KEY (client_id) REFERENCES m_client (id),
  CONSTRAINT FK_m_note_m_group FOREIGN KEY (group_id) REFERENCES m_group (id),
  CONSTRAINT FK7C970898F889C3F FOREIGN KEY (lastmodifiedby_id) REFERENCES m_appuser (id)
);

create table loan_activity_details (
  id integer auto_increment not null,
  created_by smallint not null,
  account_id integer not null,
  created_date timestamp not null,
  comments varchar(100) not null,
  principal_amount decimal(21,4),
  principal_amount_currency_id smallint,
  interest_amount decimal(21,4),
  interest_amount_currency_id smallint,
  penalty_amount decimal(21,4),
  penalty_amount_currency_id smallint,
  fee_amount decimal(21,4),
  fee_amount_currency_id smallint,
  balance_principal_amount decimal(21,4),
  balance_principal_amount_currency_id smallint,
  balance_interest_amount decimal(21,4),
  balance_interest_amount_currency_id smallint,
  balance_penalty_amount decimal(21,4),
  balance_penalty_amount_currency_id smallint,
  balance_fee_amount decimal(21,4),
  balance_fee_amount_currency_id smallint,
  primary key(id),
  foreign key(created_by)
    references personnel(personnel_id)
      on delete no action
      on update no action,
  foreign key(account_id)
    references account(account_id)
      on delete no action
      on update no action,
  foreign key(principal_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(interest_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(fee_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(penalty_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(balance_principal_amount_currency_id)
  references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(balance_interest_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(balance_penalty_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(balance_fee_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action

)
;

create table account_fees (
  account_fee_id integer auto_increment not null,
  account_id integer not null,
  fee_id smallint not null,
  fee_frequency integer,
  status smallint,
  inherited_flag smallint,
  start_date date,
  end_date date,
  account_fee_amnt decimal(21,4) not null,
  account_fee_amnt_currency_id smallint,
  fee_amnt  decimal(21,4) not null,
  fee_status smallint,
  status_change_date date,
  version_no integer not null,
  last_applied_date date,
  primary key(account_fee_id),
  foreign key(account_id)
    references account(account_id)
      on delete no action
      on update no action,
  foreign key(fee_id)
    references fees(fee_id)
      on delete no action
      on update no action,
  foreign key(account_fee_amnt_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(fee_frequency)
    references recurrence_detail(details_id)
      on delete no action
      on update no action
)
;
create index account_fees_id_idx on account_fees (account_id,fee_id);

create table savings_account (
  account_id integer not null,
  activation_date date,
  savings_balance decimal(21,4),
  savings_balance_currency_id smallint,
  recommended_amount decimal(21,4),
  recommended_amount_currency_id smallint,
  recommended_amnt_unit_id smallint,
  savings_type_id smallint not null,
  int_to_be_posted decimal(21,4),
  int_to_be_posted_currency_id smallint,
  last_int_calc_date date,
  last_int_post_date date,
  next_int_calc_date date,
  next_int_post_date date,
  inter_int_calc_date date,
  prd_offering_id smallint not null,
  interest_rate decimal(13, 10) not null,
  interest_calculation_type_id smallint not null,
  time_per_for_int_calc integer,
  min_amnt_for_int decimal(21,4),
  min_amnt_for_int_currency_id smallint,
  primary key(account_id),
  foreign key(account_id)
    references account(account_id)
      on delete no action
      on update no action,
  foreign key(savings_balance_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(recommended_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(int_to_be_posted_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(recommended_amnt_unit_id)
    references recommended_amnt_unit(recommended_amnt_unit_id)
      on delete no action
      on update no action,
  foreign key(savings_type_id)
    references savings_type(savings_type_id)
      on delete no action
      on update no action,
  foreign key(prd_offering_id)
    references prd_offering(prd_offering_id)
      on delete no action
      on update no action,
  foreign key(interest_calculation_type_id)
    references interest_calculation_types(interest_calculation_type_id)
      on delete no action
      on update no action,
  foreign key(time_per_for_int_calc)
     references meeting (meeting_id)
      on delete no action
      on update no action,
  foreign key(min_amnt_for_int_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action
)
;

create table savings_activity_details (
  id integer auto_increment not null,
  created_by smallint,
  account_id integer not null,
  created_date timestamp not null,
  account_action_id smallint not null,
  amount decimal(21,4) not null,
  amount_currency_id smallint not null,
  balance_amount decimal(21,4) not null,
  balance_amount_currency_id smallint not null,
  primary key(id),
  foreign key(created_by)
    references personnel(personnel_id)
      on delete no action
      on update no action,
  foreign key(account_id)
    references account(account_id)
      on delete no action
      on update no action,
  foreign key(account_action_id)
    references account_action(account_action_id)
      on delete no action
      on update no action,
  foreign key(amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action,
  foreign key(balance_amount_currency_id)
    references currency(currency_id)
      on delete no action
      on update no action
)
;

