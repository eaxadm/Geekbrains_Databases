/* 7. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DELIMITER //

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
    DECLARE hour TIME DEFAULT HOUR(CURTIME());
    IF hour >= 6 AND hour < 12 THEN RETURN 'Доброе утро!';
    ELSEIF hour >= 12 AND hour < 18 THEN RETURN 'Добрый день!';
    ELSEIF hour >= 18 AND hour <= 23 THEN RETURN 'Добрый вечер!';
    ELSE RETURN 'Доброй ночи!';
    END IF;
END//

SELECT hello()//

DELIMITER ;
