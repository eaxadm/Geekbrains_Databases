/* (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует. */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS aug;
CREATE TABLE aug (created_at DATE);
INSERT INTO aug VALUES ('2018-08-01'), ('2018-08-04'), ('2018-08-16'), ('2018-08-17');

DROP TABLE IF EXISTS aug_full;
CREATE TEMPORARY TABLE aug_full (created_at DATE);
INSERT INTO aug_full VALUES
	('2018-08-01'), ('2018-08-02'), ('2018-08-03'), ('2018-08-04'), ('2018-08-05'),
	('2018-08-06'), ('2018-08-07'), ('2018-08-08'), ('2018-08-09'), ('2018-08-10'),	
	('2018-08-11'), ('2018-08-12'), ('2018-08-13'), ('2018-08-14'), ('2018-08-15'),
	('2018-08-16'), ('2018-08-17'), ('2018-08-18'), ('2018-08-19'), ('2018-08-20'),
	('2018-08-21'), ('2018-08-22'), ('2018-08-23'), ('2018-08-24'), ('2018-08-25'),
	('2018-08-26'), ('2018-08-27'), ('2018-08-28'), ('2018-08-29'), ('2018-08-30'), ('2018-08-31');

SELECT 
    f.created_at AS created_at, 
    COUNT(a.created_at) AS is_in_aug
  FROM aug_full AS f 
  LEFT JOIN aug AS a 
    ON f.created_at = a.created_at 
 GROUP BY created_at 
 ORDER BY created_at;

-- SELECT created_at, IF(aug_full.created_at IN (SELECT created_at FROM aug), 1, 0) AS is_in_aug FROM aug_full;

