USE dns_shop;

-- топ-10 пользователей с наибольшим количеством заказов в магазине
SELECT  
	CONCAT (u.lastname, ' ', u.firstname) user,
	COUNT(o.id) orders_count
  FROM users AS u
  LEFT JOIN orders AS o
    ON u.id = o.user_id 
 GROUP BY u.id
 ORDER BY orders_count DESC LIMIT 10; 	

-- все телевизоры со скидкой >50% дейстительной на сегодняшний день
SELECT DISTINCT
	p.attributes->>'$."Производитель"' AS manufacturer,
	p.name AS model,
	p.price AS price,
	d.discount AS discount,
	d.finished_at discount_ends
  FROM products AS p
  JOIN catalogs AS c
    ON c.name = 'Телевизоры' AND p.catalog_id = c.id
  JOIN discounts AS d
    ON d.product_id = p.id AND d.discount >= 0.5 AND d.finished_at > NOW() 
 ORDER BY discount DESC;

-- флешка 32Гб дешевле 3000 с максимальным количеством положительных отзывов (оценки 4 и 5)
SELECT DISTINCT
	CONCAT( p.attributes->>'$."Производитель"', ' ',
		p.name, ' ',
		p.attributes->>'$."Объем памяти"', 'Гб') AS product,	
	p.price AS price,
	COUNT(o.id) AS good_opinions
  FROM products AS p
  JOIN catalogs AS c
    ON c.name = 'Флешки' AND p.catalog_id = c.id AND p.price < 3000 AND p.attributes->'$."Объем памяти"' = '32'
  JOIN opinions AS o
    ON o.product_id = p.id AND (o.mark = 4 OR o.mark = 5)
 GROUP BY o.product_id
 ORDER BY good_opinions DESC LIMIT 1;

