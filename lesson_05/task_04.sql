/* (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august') */

CREATE DATABASE IF NOT EXISTS shop;

USE shop;

/* не понял фразу "Месяцы заданы в виде списка английских названий ('may', 'august')", поэтому сделал в двух варинатах:
-------------------------- вариант 1 */
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at VARCHAR(55) COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-october-05'),
  ('Наталья', '1984-november-12'),
  ('Александр', '1985-may-20'), -- май
  ('Сергей', '1988-august-14'), -- август
  ('Иван', '1998-january-12'),
  ('Мария', '1992-august-29'); -- август

-- все
SELECT id, name, birthday_at FROM users;

-- май и август
SELECT id, name, birthday_at FROM users WHERE birthday_at LIKE '%may%' OR birthday_at LIKE '%august%'; 


/* не понял фразу "Месяцы заданы в виде списка английских названий ('may', 'august')", поэтому сделал в двух варинатах:
-------------------------- вариант 2 */
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'), -- май
  ('Сергей', '1988-08-14'), -- август
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29'); -- август

-- все
SELECT id, name, birthday_at FROM users;

-- май и август
SELECT id, name, birthday_at FROM users WHERE MONTH(birthday_at) = 8 OR MONTH(birthday_at) = 5;

