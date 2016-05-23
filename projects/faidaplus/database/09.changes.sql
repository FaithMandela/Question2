CREATE OR REPLACE VIEW vw_products AS
	SELECT products.product_id, products.product_name, products.product_details, products.product_uprice,
		products.created, products.updated_by,products.image, suppliers.supplier_name, suppliers.supplier_id,
		product_category.product_category_id,
		product_category.product_category_name,products.is_active
	FROM products JOIN suppliers ON products.supplier_id = suppliers.supplier_id
		JOIN product_category ON products.product_category_id=product_category.product_category_id;
