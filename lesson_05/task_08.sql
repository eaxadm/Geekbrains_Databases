/* (по желанию) Подсчитайте произведение чисел в столбце таблицы 
value
  1
  2
  3
  4
  5  */


CREATE DATABASE IF NOT EXISTS shop;

USE shop;

DROP TABLE IF EXISTS multipl;

CREATE TABLE multipl (id SERIAL PRIMARY KEY, value TINYINT);
INSERT INTO multipl (value) VALUES (1), (2), (3), (4), (5);

SELECT value FROM multipl;

-- работает для условия задачи (числа > 0) 
SELECT round(exp(sum(ln(value)))) AS mult FROM multipl;

