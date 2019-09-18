/*Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы. */

-- мне кажется, что можно создать индекс на связку фамилия+имя пользователя для ускорения поиска 
-- (юзеры же будут искать друг друга по фамилии-имени, а не по id)  
-- для запросов типа SELECT id FROM users WHERE lastname = x AND firstname = y
CREATE INDEX users_lastname_firstname_idx ON users(lastname, firstname);

-- еще среди юзеров могут быть популярны запросы поиска особей противоположного пола опредленного возраста и локации
-- не знаю только, насколько оправдано создание такого индекса (на несколько столбцов)
-- запросы типа SELECT user_id FROM profiles WHERE sex = x AND birthday <= y AND hometown = z;
CREATE INDEX profiles_sex_birthday_hometown_idx ON profiles(sex, birthday, hometown);

-- также можно добавить индекс для поиска группы по имени
-- SELECT id FROM communities WHERE name = x
CREATE UNIQUE INDEX communities_name_idx ON communities(name);

-- аналогично для поиска медиафайлов по названию
CREATE INDEX media_filename_idx ON media(filename);

-- в ВК под каждой сущностью (типа пост, фото, видео и тп) отображается количество лайков и сами лайкнувшие юзеры.
-- а поскольку вся сеть заполнена постами-фото-видео-музыкой, то, как я понимаю, запрос вида 
-- SELECT user_id FROM likes WHERE item_id = x тоже будет довольно частым
-- значит, возможно имеет смысл создать индекс
CREATE INDEX likes_item_id_idx ON likes(item_id);

