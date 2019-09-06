/* Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине. */ 

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

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
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

INSERT INTO orders (user_id) VALUES (2), (4), (3), (4), (6);

SELECT * FROM users;
SELECT * FROM orders;

-- вложенные запросы
SELECT 
     name, 
     (SELECT COUNT(id) FROM orders WHERE user_id = users.id) AS orders_count 
  FROM users 
 WHERE id IN (SELECT user_id FROM orders);

-- JOIN-соединения
SELECT 
     u.name, 
     o.id AS order_number 
  FROM users AS u 
  JOIN orders AS o 
    ON u.id = o.user_id 
 ORDER BY u.name; 

