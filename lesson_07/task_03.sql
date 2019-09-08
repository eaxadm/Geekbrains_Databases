/* (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов. */

CREATE DATABASE IF NOT EXISTS avia;
USE avia;

DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
  label VARCHAR(10) COMMENT 'название города англ.',
  name VARCHAR(10) COMMENT 'название города рус');

INSERT INTO cities  
VALUES 
  ('moscow', 'Москва'),
  ('novgorod', 'Новгород'),
  ('irkutsk', 'Иркутск'),
  ('omsk', 'Омск'),
  ('kazan', 'Казань');

DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
  id SERIAL PRIMARY KEY,
  city_from VARCHAR(10) COMMENT 'город отправления англ.',
  city_to VARCHAR(10) COMMENT 'город прибытия англ.');

INSERT INTO flights 
  (city_from, city_to) 
VALUES 
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');

SELECT * FROM cities;
SELECT * FROM flights;

-- вложенные запросы
SELECT
     id AS flight_num,
     (SELECT name FROM cities WHERE label = flights.city_from) AS city_from,
     (SELECT name FROM cities WHERE label = flights.city_to) AS city_to
  FROM
     flights;

-- JOIN-соединения 
SELECT
     f.id AS flight_num,
     c1.name AS city_from,
     c2.name AS city_to
  FROM
     flights AS f
  JOIN
     cities AS c1
  JOIN
     cities AS c2
    ON c1.label = f.city_from AND c2.label = f.city_to
 ORDER BY flight_num;

