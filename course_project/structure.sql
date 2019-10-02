DROP DATABASE IF EXISTS dns_shop;
CREATE DATABASE dns_shop;

USE dns_shop;

SET FOREIGN_KEY_CHECKS = 0;

-- чтобы не делать кучу таблиц, систему подкаталогов (когда каждый раздел имеет свои подразделы) решил реализовать в одной общей таблице, добавив поле parent_id - id родительского каталога (каталога "предыдущего" уровня). 0 - высший уровень (у каталога нет родителя).
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs( 
	id SERIAL PRIMARY KEY,
	parent_id BIGINT(20) UNSIGNED NOT NULL DEFAULT 0, -- id родителя предыдущего уровня
 	name VARCHAR(100) NOT NULL COMMENT 'Название раздела',
	INDEX (name)	
) COMMENT 'Разделы интернет-магазина';

-- поскольку у разных групп товаров помимо общих, есть и совершенно уникальные (не свойственные другим группам) атрибуты, решил реализовать этот момент через JSON поле. Другие варианты мне кажутся менее удобными: 1) можно создать одну общую таблицу свойств и характеристик товаров, где указать абсолютно все атрибуты, присущие всем категориям. но тогда при добавлении товара из новой, не существовавшей ранее категории, придется добавлять и новые столбцы в таблицу (новые характеристики), а также заполнять их для всех уже существовавших товаров, если у них есть такие свойства. плюс большинство полей будут иметь значение NULL, так как у товара нет такого свойства в принципе (например "диагональ экрана" для товаров категории "процессоры"). 2) создавать для каждой категории товаров таблицу атрибутов, свойственных только им. что мне тоже кажется не очень удобным, поскольку категорий может быть очень и очень много.
DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	catalog_id BIGINT(20) UNSIGNED NOT NULL,     -- раздел, к которому относится конкретный товар
	name VARCHAR(255) NOT NULL COMMENT 'Название',
	description VARCHAR(10000) COMMENT 'Описание',
	price DECIMAL (11,2) COMMENT 'Цена',
	attributes JSON NOT NULL COMMENT 'Характеристики', -- атрибуты товара в виде "атрибут : значение"
	picture_id BIGINT(20) UNSIGNED,     -- основная картинка товара
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (picture_id) REFERENCES pictures(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (catalog_id) REFERENCES catalogs(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	INDEX (name),
	INDEX (price)
) COMMENT 'Товарные позиции';

-- фотографии товаров
DROP TABLE IF EXISTS pictures;
CREATE TABLE pictures(
	id SERIAL PRIMARY KEY,
	product_id BIGINT(20) UNSIGNED NOT NULL, -- к какому товару эта картинка относится
	filename VARCHAR(255) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE NO ACTION ON UPDATE CASCADE
) COMMENT 'Фотографии товаров';

-- пользователи
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100) NOT NULL COMMENT 'Имя',
	lastname VARCHAR(100) NOT NULL COMMENT 'Фамилия',
	sex CHAR(1) NOT NULL COMMENT 'Пол',
	birthday DATE COMMENT 'Дата рождения',
	email VARCHAR(100) NOT NULL UNIQUE COMMENT 'Email',
	phone VARCHAR(15) NOT NULL UNIQUE COMMENT 'Телефон',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Покупатели';

-- магазины, они же склады, они же пункты выдачи
DROP TABLE IF EXISTS shops;
CREATE TABLE shops(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL, -- название
	region VARCHAR(50) NOT NULL, -- регион
	city VARCHAR(50) NOT NULL,   -- город
	address VARCHAR(100) NOT NULL, -- адрес
	schedule VARCHAR(100) NOT NULL DEFAULT 'Пн-Вс с 10:00 до 21:00' -- график работы	
) COMMENT 'Магазины';

-- наличие товара на складах (в магазинах)
DROP TABLE IF EXISTS shops_products;
CREATE TABLE shops_products(
	id SERIAL PRIMARY KEY,
	shop_id BIGINT(20) UNSIGNED NOT NULL,
	product_id BIGINT(20) UNSIGNED NOT NULL,
 	total INT UNSIGNED COMMENT 'Количество товара в магазине',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (shop_id) REFERENCES shops(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT ON UPDATE CASCADE
) COMMENT 'Наличие товара';

-- заказы
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
	user_id BIGINT(20) UNSIGNED NOT NULL,  -- чей заказ
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE CASCADE
) COMMENT 'Заказы';

-- связь товаров и заказов
DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
	id SERIAL PRIMARY KEY,
	order_id BIGINT(20) UNSIGNED NOT NULL, -- номер заказа
	product_id BIGINT(20) UNSIGNED NOT NULL, -- номер товарной позиции
	quantity INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT ON UPDATE CASCADE
) COMMENT 'Состав заказа';

-- таблица со скидками
DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
	id SERIAL PRIMARY KEY,
	product_id BIGINT(20) UNSIGNED NOT NULL,
	discount DECIMAL(11,1) UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
	started_at DATETIME,  -- дата начала действия
	finished_at DATETIME, -- срок действия скидки
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
	INDEX (discount)
) COMMENT 'Скидки';

-- уцененные товары
DROP TABLE IF EXISTS markdowns;
CREATE TABLE markdowns(
	id SERIAL PRIMARY KEY,
	product_id BIGINT(20) UNSIGNED UNIQUE NOT NULL,
	price DECIMAL (11,2) NOT NULL COMMENT 'Новая цена',
	reason VARCHAR(100) COMMENT 'Причина уценки',
	shop_id BIGINT(20) UNSIGNED NOT NULL COMMENT 'Магазин',
	FOREIGN KEY (shop_id) REFERENCES shops(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
	INDEX (price)
) COMMENT 'Уцененные товары';

-- отзывы на товар
DROP TABLE IF EXISTS opinions;
CREATE TABLE opinions(
	id SERIAL PRIMARY KEY,
	user_id BIGINT(20) UNSIGNED NOT NULL,
	product_id BIGINT(20) UNSIGNED NOT NULL,
	mark ENUM('1', '2', '3', '4', '5') NOT NULL COMMENT 'Оценка',
	description VARCHAR(10000) COMMENT 'Отзыв',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
	INDEX (mark)
) COMMENT 'Отзывы';

SET FOREIGN_KEY_CHECKS = 1;
