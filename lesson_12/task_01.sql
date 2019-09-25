/* 1. Проверить, исправить при необходимости и оптимизировать следующий запрос:
SELECT CONCAT(u.firstname, ' ', u.lastname) AS user,
COUNT(l.id) + COUNT(m.id) + COUNT(t.id) AS overall_activity
FROM users AS u
LEFT JOIN
likes AS l
ON l.user_id = u.id
LEFT JOIN
media AS m
ON m.user_id = u.id
LEFT JOIN
messages AS t
ON t.from_user_id = u.id
GROUP BY u.id
ORDER BY overall_activity
LIMIT 10;
*/

USE vk;

-- В моей таблице messages нет поля id, поэтому COUNT(t.id) заменил на COUNT(t.body). Вообще, здесь аналогичная разобранному на вебинаре примеру ситуация с учетом неуникальных значений. Лечится также DISTINCTом:
SELECT 	
	CONCAT(u.firstname, ' ', u.lastname) AS user,
	COUNT(DISTINCT l.id) + COUNT(DISTINCT m.id) + COUNT(DISTINCT t.body) AS overall_activity
  FROM users AS u
  LEFT JOIN likes AS l
	 ON l.user_id = u.id
  LEFT JOIN media AS m
	 ON m.user_id = u.id
  LEFT JOIN messages AS t
	 ON t.from_user_id = u.id
 GROUP BY u.id
 ORDER BY overall_activity
 LIMIT 10;

-- сделаем explain и увидим, что все грустно.
EXPLAIN SELECT 	
	CONCAT(u.firstname, ' ', u.lastname) AS user,
	COUNT(DISTINCT l.id) + COUNT(DISTINCT m.id) + COUNT(DISTINCT t.body) AS overall_activity
  FROM users AS u
  LEFT JOIN likes AS l
	 ON l.user_id = u.id
  LEFT JOIN media AS m
	 ON m.user_id = u.id
  LEFT JOIN messages AS t
	 ON t.from_user_id = u.id
 GROUP BY u.id
 ORDER BY overall_activity
 LIMIT 10 \G

-- добавим индексы
CREATE INDEX users_id_idx ON users(id);
CREATE INDEX likes_user_id_idx ON likes(user_id);
CREATE INDEX media_user_id_idx ON media(user_id);
CREATE INDEX messages_from_user_id_idx ON messages(from_user_id);

-- повторим explain. видим, что картина кардинально поменялась - при всех соединениях теперь ипользуются индексы, количество выбранных строк уменьшилось с исходных 300 до 3 (везде кроме users, поскольку используем LEFT JOIN, а значит все равно выбираем всех пользователей - в моем случае 100)
EXPLAIN SELECT 	
	CONCAT(u.firstname, ' ', u.lastname) AS user,
	COUNT(DISTINCT l.id) + COUNT(DISTINCT m.id) + COUNT(DISTINCT t.body) AS overall_activity
  FROM users AS u
  LEFT JOIN likes AS l
	 ON l.user_id = u.id
  LEFT JOIN media AS m
	 ON m.user_id = u.id
  LEFT JOIN messages AS t
	 ON t.from_user_id = u.id
 GROUP BY u.id
 ORDER BY overall_activity
 LIMIT 10 \G

-- итоговая "стоимость" запроса для моих данных согласно MySQL Workbench составила примерно 795

