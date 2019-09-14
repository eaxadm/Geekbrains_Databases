/* Переписать запросы, заданые к ДЗ урока 6 с использованием JOIN (четыре запроса). */

USE vk; 

/* 1. Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользоваетелем. */

SELECT 
    (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = temp.friend) AS friend_name,                              -- имя друга
    COUNT(*) AS messages                                                                            -- количество сообщений в обе стороны 
     FROM (                                                                     
         SELECT
             IF(f.user_id = 10, f.friend_id, f.user_id) AS friend -- берем только id друзей, независимо от того кто кому предложил дружбу
           FROM friendship AS f
           JOIN messages   AS m                                              -- учитываем все варианты - кто кого дружил и кто кому писал
             ON 
               (f.user_id = 10 AND m.from_user_id = 10 AND m.to_user_id = f.friend_id AND confirmed_at IS NOT NULL)
             OR
               (f.user_id = 10 AND m.from_user_id = f.friend_id AND m.to_user_id = 10 AND confirmed_at IS NOT NULL)
             OR
               (f.friend_id = 10 AND m.from_user_id = 10 AND m.to_user_id = f.user_id AND confirmed_at IS NOT NULL)
             OR
               (f.friend_id = 10 AND m.from_user_id = f.user_id AND m.to_user_id = 10 AND confirmed_at IS NOT NULL)
     ) AS temp
GROUP BY temp.friend 
ORDER BY messages DESC LIMIT 1
;
   
/* 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. */

-- сделал для лайков только пользователям
SELECT SUM(temp2.likes_count) AS 10_youngest_users_likes_sum
  FROM (
     SELECT COUNT(*) AS likes_count 
       FROM (
         SELECT p.user_id AS user
           FROM likes AS l
           JOIN (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10) AS p  -- берем только 10 самых юных
           JOIN like_types AS lt
             ON 
               l.like_type_id = lt.id WHERE lt.name = 'users' AND l.item_id = p.user_id  
            ) AS temp
      GROUP BY temp.user
  ) AS temp2
;

-- но почему-то тоже самое не работает, когда пытаюсь учесть и лайки на всех производных пользователя(медиа, постах и тп)
/* SELECT SUM(temp2.likes_count) AS 10_youngest_users_likes_sum
  FROM (
     SELECT COUNT(*) AS likes_count 
       FROM (
         SELECT p.user_id AS user
           FROM likes AS l
           JOIN (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10) AS p 
           JOIN like_types AS lt
             ON 
               l.like_type_id = lt.id WHERE lt.name = 'users' AND l.item_id = p.user_id
           JOIN media AS m
             ON
               l.like_type_id = lt.id WHERE lt.name = 'media' AND m.user_id = p.user_id
           JOIN posts AS ps
             ON
               l.like_type_id = lt.id WHERE lt.name = 'posts' AND ps.user_id = p.user_id
           JOIN newsline AS n
             ON
               l.like_type_id = lt.id WHERE lt.name = 'newsline' AND n.user_id = p.user_id
             ) AS temp
      GROUP BY temp.user
  ) AS temp2
;

/* 3. Определить кто больше поставил лайков (всего) - мужчины или женщины? */
SELECT 
    (SELECT COUNT(id)
       FROM profiles AS p
       JOIN likes AS l
         ON l.user_id = p.user_id AND p.sex = 'm') AS men_likes,
    (SELECT COUNT(id)
       FROM profiles AS p
       JOIN likes AS l
         ON l.user_id = p.user_id AND p.sex = 'f') AS women_likes;

/* 4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети. */
-- на основе количества лайков, постов, новостей и отправленных сообщений
SELECT
    u.id AS user, 
    CONCAT(u.firstname, ' ', u.lastname) AS fullname,
    COUNT(distinct l.id) AS likes_count, 
    COUNT(distinct ms.body) AS messages_count,
    COUNT(distinct n.id) AS news_count,
    COUNT(distinct p.id) AS posts_count,
    (COUNT(distinct l.id) + COUNT(distinct ms.body) + COUNT(distinct n.id) + COUNT(distinct p.id)) AS activity
  FROM users AS u
  LEFT JOIN likes AS l
    ON l.user_id = u.id 
  LEFT JOIN messages AS ms
    ON ms.from_user_id = u.id
  LEFT JOIN newsline AS n
    ON n.user_id = u.id
  LEFT JOIN posts AS p
    ON p.user_id = u.id
 GROUP BY user 
 ORDER BY activity, user LIMIT 10;	


