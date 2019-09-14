/* В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию. */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание'
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.'),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.'),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.');
SELECT * FROM products;

-- ------------------------------------------------------------------------------------------------------------------------
DELIMITER //

CREATE TRIGGER check_not_null_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF 'null_try' = COALESCE(NEW.name, NEW.description, 'null_try') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Canceled. Input name or description!';
    END IF;
END//

CREATE TRIGGER check_not_null_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF 'null_try' = COALESCE(NEW.name, NEW.description, 'null_try') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Canceled. Name or description required!';
    END IF;
END//

DELIMITER ;

INSERT INTO products (name, description) VALUES ('AMD 3600', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD');
SELECT * FROM products;
INSERT INTO products (name, description) VALUES (NULL, 'Процессор для настольных персональных компьютеров, основанных на платформе AMD');
SELECT * FROM products;
INSERT INTO products (name, description) VALUES (NULL, NULL);
SELECT * FROM products;
UPDATE products SET name = NULL WHERE id = 1;
SELECT * FROM products;
UPDATE products SET description = NULL WHERE id = 1;
SELECT * FROM products;

