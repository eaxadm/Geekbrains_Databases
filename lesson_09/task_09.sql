/* (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55. */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DELIMITER //

DROP FUNCTION IF EXISTS fib;
CREATE FUNCTION fib(num INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE x, y INT DEFAULT 1;
    DECLARE i INT DEFAULT 2;
    WHILE i < num DO
	SET y = x + y;
	SET x = y - x;
	SET i = i + 1;
    END WHILE;
    RETURN y;
END//

DELIMITER ;

SELECT fib(10);
SELECT fib(5);
SELECT fib(20);

