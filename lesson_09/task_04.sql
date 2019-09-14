/* (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей. */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS sample;
CREATE TABLE sample (id SERIAL PRIMARY KEY, created_at DATE);
INSERT INTO sample (created_at) VALUES 
    (FROM_UNIXTIME(RAND() * 2147483647)), 
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647));
SELECT * FROM sample;

DROP TABLE IF EXISTS temp;
CREATE TEMPORARY TABLE temp (id SERIAL PRIMARY KEY, created_at DATE);
INSERT INTO temp SELECT * FROM sample ORDER BY created_at DESC LIMIT 5;
TRUNCATE TABLE sample;
INSERT INTO sample SELECT * FROM temp; 

-- DELETE FROM sample WHERE created_at NOT IN (SELECT created_at FROM temp);

SELECT * FROM sample;


