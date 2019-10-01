USE dns_shop;

-- представление с названиями категорий и подкатегорий магазина
CREATE OR REPLACE VIEW catalog_names AS
	SELECT 
		c.name maindir, 
		(SELECT GROUP_CONCAT(cc.name SEPARATOR ' / ') FROM catalogs cc WHERE c.id = cc.parent_id) subdirs 
	  FROM catalogs c WHERE c.parent_id = 0 ;

SELECT * FROM catalog_names; 

-- список магазинов с общим количеством товара в них
CREATE OR REPLACE VIEW shops_products_total AS
	SELECT 
		s.name shop_name,
		SUM(sp.total) products_total
	  FROM shops s
	  JOIN shops_products sp
	    ON s.id = sp.shop_id 
	 GROUP BY sp.shop_id;

SELECT * FROM shops_products_total;
