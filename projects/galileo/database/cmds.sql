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


INSERT INTO clientassets(
            clientassetid, assetid, isissued, dateissued, 
            isretrived, units, dateretrived, narrative, dateadded, datechanged)
   SELECT client_asset_id, asset_id, is_issued, date_issued, is_retrived, units, date_retrived, narrative, date_added, date_changed
       FROM i_client_assets;



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
	
UPDATE assets SET AssetSubTypeID = 1 WHERE assetid IN
(SELECT i_assets.asset_id
FROM i_asset_types INNER JOIN i_models ON i_asset_types.asset_type_id = i_models.asset_type_id 
	INNER JOIN i_assets ON i_models.model_id = i_assets.model_id
WHERE i_asset_types.asset_type_id = 1);

	