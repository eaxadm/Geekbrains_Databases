/* Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

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
SELECT id, name, 
    CASE
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 0 THEN 'mon'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 1 THEN 'tue'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 2 THEN 'wed'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 3 THEN 'thu'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 4 THEN 'fri'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 5 THEN 'sat'
	ELSE 'sun'
    END AS birth_weekday_2019
FROM users;

/* Не уверен, что именно должно быть в выводе, поэтому: */
-- --------- вариант 1 - только дни недели, на которые выпадают дни рождения (для 2019)
SELECT
    CASE
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 0 THEN 'mon'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 1 THEN 'tue'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 2 THEN 'wed'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 3 THEN 'thu'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 4 THEN 'fri'
	WHEN WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 5 THEN 'sat'
	ELSE 'sun'
    END AS weekday, 
    COUNT(*) AS birthdays
FROM users
GROUP BY weekday;

-- вариант 2 - вывод для всех дней недели (для 2019)
DROP TABLE IF EXISTS birth_weekdays_2019;
CREATE TABLE birth_weekdays_2019 (
    weekday CHAR(3),
    birthdays TINYINT 
);

INSERT INTO birth_weekdays_2019 VALUES
    ('mon', 0), ('tue', 0), ('wed', 0), ('thu', 0), 
    ('fri', 0), ('sat', 0), ('sun', 0);

UPDATE birth_weekdays_2019 SET 
    birthdays = (SELECT COUNT(*) AS birthdays FROM users WHERE WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 0) WHERE weekday = 'mon';
UPDATE birth_weekdays_2019 SET
    birthdays = (SELECT COUNT(*) AS birthdays FROM users WHERE WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 1) WHERE weekday = 'tue';
UPDATE birth_weekdays_2019 SET
    birthdays = (SELECT COUNT(*) AS birthdays FROM users WHERE WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 2) WHERE weekday = 'wed';
UPDATE birth_weekdays_2019 SET
    birthdays = (SELECT COUNT(*) AS birthdays FROM users WHERE WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 3) WHERE weekday = 'thu';
UPDATE birth_weekdays_2019 SET
    birthdays = (SELECT COUNT(*) AS birthdays FROM users WHERE WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 4) WHERE weekday = 'fri';
UPDATE birth_weekdays_2019 SET
    birthdays = (SELECT COUNT(*) AS birthdays FROM users WHERE WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 5) WHERE weekday = 'sat';
UPDATE birth_weekdays_2019 SET
    birthdays = (SELECT COUNT(*) AS birthdays FROM users WHERE WEEKDAY(CONCAT('2019-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) = 6) WHERE weekday = 'sun';

SELECT * FROM birth_weekdays_2019;

DROP TABLE IF EXISTS birth_weekdays_2019;

