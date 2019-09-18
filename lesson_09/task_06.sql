/*(по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username. */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	password VARCHAR(100)
);

INSERT INTO accounts (name, password) VALUES ('Deniska', '123'), ('Obama', 'qwerty'), ('4eburashka', 'HksdntR552_!');

SELECT * FROM accounts;

-- --------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW username AS
    SELECT a.id, a.name FROM accounts a; 
SELECT * FROM username;

SELECT Host, User FROM mysql.user;

DROP USER IF EXISTS 'user_read';
CREATE USER 'user_read';
GRANT SELECT ON shop.username TO 'user_read';

SELECT Host, User FROM mysql.user;

