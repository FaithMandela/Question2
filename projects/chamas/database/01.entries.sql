
INSERT INTO account_types VALUES (0, 0, 0, 'Current Account', 'Current Transactions');
INSERT INTO account_types VALUES (1, 0, 0, 'Savings Account', 'Local Savings Transactions');
INSERT INTO account_types VALUES (2, 1, 1, 'Int Current Account', 'Overseas Current Transactions');
INSERT INTO account_types VALUES (3, 1, 1, 'Int Savings Account', 'Overseas Savings Transactions');


INSERT INTO contribution_types VALUES(0,0,'Shares Contribution', FALSE, 'Cash raised is valued in shares');
INSERT INTO contribution_types VALUES(1,0,'Member Contribution', TRUE, 'Cash raised for chama members');
INSERT INTO contribution_types VALUES(2,0,'Salary Contribution', FALSE, 'Cash raised to pay chama employees');
INSERT INTO contribution_types VALUES(3,0,'Operations Contribution', FALSE, 'Cash raised to purchase items');

INSERT INTO category VALUES(0, 0, 'Stationery', 'Office Utilities ');
INSERT INTO category VALUES(1, 0, 'Food Stuffs', 'Chama Food stuffs for employees and during meetings');
INSERT INTO category VALUES(2, 0, 'Electronics', 'Office Electronics');
INSERT INTO category VALUES(3, 0, 'Furniture', 'Office Furniture');

<GRIDBOX w="430" title="GL Account" default="70005" lptable="vw_accounts" lpkey="account_id" y="30" h="20" x="10" lpfield="account_description">account_id
				<GRID name="Account" keyfield="account_id" table="vw_accounts" where="(is_header = false) and (is_active = true)">
					<TEXTFIELD w="75" title="Account ID">account_id</TEXTFIELD>
					<TEXTFIELD w="150" title="Accounts Class Name">accounts_class_name</TEXTFIELD>
					<TEXTFIELD w="150" title="Account Type Name">account_type_name</TEXTFIELD>
					<TEXTFIELD w="250" title="Account Name">account_name</TEXTFIELD>
				</GRID>
</GRIDBOX>
