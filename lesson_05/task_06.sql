/* Подсчитайте средний возраст пользователей в таблице users */

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
  ('Сергей', '1988-08-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-28');

-- все для наглядности
SELECT id, name, birthday_at FROM users;

-- средний возраст до целого числа
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS average_age FROM users;

