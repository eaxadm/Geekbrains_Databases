/* Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop. */

SELECT Host, User FROM mysql.user;

DROP USER IF EXISTS 'shop_read';
CREATE USER 'shop_read';
GRANT SELECT ON shop.* TO 'shop_read';

DROP USER IF EXISTS 'shop';
CREATE USER 'shop';
GRANT ALL ON shop.* TO 'shop';

SELECT Host, User FROM mysql.user;

