/* Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения. */

CREATE DATABASE IF NOT EXISTS shop;

USE shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(50) DEFAULT NULL,
  updated_at VARCHAR(50) DEFAULT NULL
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

-- заполняем поля created_at и updated_at случайными значениями типа "20.10.2017 8:10" согласно условию задачи
UPDATE 
  users 
SET 
  created_at = 	CONCAT(FLOOR(1 + RAND()*30), '.', FLOOR(1 + RAND()*12), '.', FLOOR(1980 + RAND()*25), 
		' ', FLOOR(0 + RAND()*23), ':', FLOOR(0 + RAND()*59)),
  updated_at = 	CONCAT(FLOOR(1 + RAND()*30), '.', FLOOR(1 + RAND()*12), '.', FLOOR(1980 + RAND()*25),
		' ', FLOOR(0 + RAND()*23), ':', FLOOR(0 + RAND()*59));

SELECT * FROM users;
DESC users;

-- преобразуем содержимое created_at и updated_at в тип datetime
UPDATE 
  users 
SET 
  created_at = str_to_date(created_at, '%d.%m.%Y %H:%i'),
  updated_at = str_to_date(updated_at, '%d.%m.%Y %H:%i');

-- меняем тип полей created_at и updated_at с VARCHAR на DATETIME
ALTER TABLE users MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

SELECT * FROM users;
DESC users;

