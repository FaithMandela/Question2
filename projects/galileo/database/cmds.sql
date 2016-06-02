INSERT INTO assets(
            assetid, assetsn, purchasedate, purchasecost, lost, sold, saledate, saleamount, condition)
   SELECT asset_id, asset_serial, purchase_date,  purchase_value, lost, sold, disposal_date, disposal_amount, details 
   FROM i_assets ;


INSERT INTO clients(
            clientid, clientname, address, zipcode, premises, street, division, town, 
            country, telno, email, website, iatano, isactive, details)
      SELECT client_id, client_name, address, zipcode, premises, street, division, town, country_id,
      telno, email, website, iatano, is_active, details
      FROM i_clients;


INSERT INTO clientassets(clientid, crmrefno, dnoteno,
            clientassetid, assetid, isissued, dateissued, 
            isretrived, units, dateretrived, narrative, dateadded, datechanged)
   SELECT b.client_id, b.crm_ref, b.dnote_no, a.client_asset_id, a.asset_id, a.is_issued, a.date_issued, a.is_retrived, a.units, a.date_retrived, a.narrative, a.date_added, a.date_changed
       FROM i_client_assets a INNER JOIN i_client_requests b ON a.client_request_id = b.client_request_id;



INSERT INTO assettypes(
            assettypeid, assettypename, details)
    SELECT asset_type_id, asset_type_name, details
       FROM i_asset_types;


INSERT INTO clientlinks(
            clientlinkid, clientlinkname, details)
    SELECT client_link_id, link_number, details
       FROM i_client_links;
       
       
SELECT i_asset_types.asset_type_id, i_asset_types.asset_type_name,
	i_models.model_id,
	i_assets.asset_id, i_assets.asset_serial, i_assets.purchase_date
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id;
	
UPDATE assets SET AssetSubTypeID = 1 WHERE purchasedate < '2014-01-01' and assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 1);

UPDATE assets SET AssetSubTypeID = 2 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 1);

UPDATE assets SET AssetSubTypeID = 3 WHERE purchasedate < '2014-01-01' and assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 3);

UPDATE assets SET AssetSubTypeID = 4 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 3);

UPDATE assets SET AssetSubTypeID = 5 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 4);

UPDATE assets SET AssetSubTypeID = 6 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 5);

UPDATE assets SET AssetSubTypeID = 7 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 6);

UPDATE assets SET AssetSubTypeID = 8 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 11);

UPDATE assets SET AssetSubTypeID = 9 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 14);

UPDATE assets SET AssetSubTypeID = 11 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 15);

