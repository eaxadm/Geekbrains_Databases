USE dns_shop;

DROP TRIGGER IF EXISTS check_availability;
DROP TRIGGER IF EXISTS upd_availability;
DELIMITER //
-- проверяем наличие товара перед продажей (добавлением в таблицу заказов orders_products)
CREATE TRIGGER check_availability BEFORE INSERT ON orders_products
FOR EACH ROW
BEGIN
	DECLARE prod_total INT;
	SELECT SUM(total) INTO prod_total FROM shops_products WHERE product_id = new.product_id;	
	IF new.quantity > prod_total THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'error. not enough products';
	END IF;
END //

-- уменьшаем доступные остатки на количество проданного товара перебирая магазины по порядку с первого
CREATE TRIGGER upd_availability AFTER INSERT ON orders_products
FOR EACH ROW
BEGIN
	DECLARE i INT DEFAULT 0;
	DECLARE prod_id BIGINT(20);
	DECLARE shop_total INT;
	DECLARE items_sold INT;
	SET items_sold = new.quantity;
	SET prod_id = new.product_id;
	WHILE items_sold > 0 DO
		SET i = i + 1;
		SELECT total INTO shop_total FROM shops_products sp WHERE sp.shop_id = i AND sp.product_id = prod_id;
		IF shop_total >= items_sold THEN 
			UPDATE shops_products SET total = total - items_sold WHERE shop_id = i AND product_id = prod_id;
			SET items_sold = 0;
		ELSE 
			UPDATE shops_products SET total = 0 WHERE shop_id = i AND product_id = prod_id;
			SET items_sold = items_sold - shop_total;
		END IF;
	END WHILE;	
END //
DELIMITER ;

-- проверка
INSERT INTO orders (id, user_id) VALUES (777, 111);
SELECT SUM(total) FROM shops_products WHERE product_id = 5; -- 39
SELECT * FROM shops_products WHERE product_id = 5;
INSERT INTO orders_products (order_id, product_id, quantity) values (777, 5, 40);
INSERT INTO orders_products (order_id, product_id, quantity) values (777, 5, 15);
SELECT * FROM orders_products WHERE order_id = 777;
SELECT * FROM shops_products WHERE product_id = 5;

-- -----------------------------------------------------------------------------------------------------------------------------
DELIMITER //
DROP FUNCTION IF EXISTS disc_price;
-- пересчитываем стоимость товара с учетом скидки. Понимаю, что это можно реализовать запросом, но не придумал лучшего примера функции.
CREATE FUNCTION disc_price (disc_id BIGINT(20))
RETURNS DECIMAL (11,2) DETERMINISTIC
BEGIN
	DECLARE prod_id BIGINT(20);
	DECLARE old_price, disc, new_price FLOAT;
	SET prod_id = (SELECT product_id FROM discounts WHERE id = disc_id);
	SET old_price = (SELECT price FROM products WHERE id = prod_id);
	SET disc = (SELECT discount FROM discounts WHERE id = disc_id);
	SET new_price = old_price - old_price * disc;
	RETURN new_price;
END //

DELIMITER ;
-- проверка
SELECT 
	p.price old_price,	
	(SELECT discount FROM discounts WHERE id = 59) discount,
	disc_price(59) new_price
  FROM products p
 WHERE p.id = (SELECT product_id FROM discounts WHERE id = 59) ;


