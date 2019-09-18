/* В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	age INT UNSIGNED
);

INSERT INTO users (name, age) VALUES ('Kasablanka', 45), ('Cheburashka', 7), ('VladimirVladimirovi4', 66);

CREATE DATABASE IF NOT EXISTS sample;
USE sample;
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	age INT UNSIGNED
);

INSERT INTO users (name, age) VALUES ('Obama', 33), ('Deniska', 11);

USE sample;
SELECT * FROM users;
USE shop;
SELECT * FROM users;

--  -----------------------------------------------------------------------------------
START TRANSACTION;
INSERT INTO sample.users (name, age) SELECT name, age FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;

USE sample;
SELECT * FROM users;
USE shop;
SELECT * FROM users;

