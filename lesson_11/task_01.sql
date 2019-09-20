/* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name. */

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время и дата создания записи',
 	from_table VARCHAR(8) NOT NULL COMMENT 'Исходная таблица',
	from_table_item_id INT UNSIGNED NOT NULL COMMENT 'ID записи в исходной таблице',
	from_table_item_name VARCHAR(255) COMMENT 'Поле name записи в исходной таблице',
	PRIMARY KEY (id)
) COMMENT 'Таблица логов' ENGINE = ARCHIVE;

SELECT * FROM logs;

DELIMITER //

DROP TRIGGER IF EXISTS users_insert; 
CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (from_table, from_table_item_id, from_table_item_name) VALUES ('users', NEW.id, NEW.name);
END//

DROP TRIGGER IF EXISTS catalogs_insert; 
CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (from_table, from_table_item_id, from_table_item_name) VALUES ('catalogs', NEW.id, NEW.name);
END//

DROP TRIGGER IF EXISTS products_insert; 
CREATE TRIGGER products_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (from_table, from_table_item_id, from_table_item_name) VALUES ('products', NEW.id, NEW.name);
END// 

DELIMITER ;

INSERT INTO users (name, age) VALUES ('Deniska', 11);
INSERT INTO catalogs (name) VALUES ('Блоки питания'), ('Корпуса');
INSERT INTO products (name) VALUES ('FSP 250W');

SELECT * FROM logs;

