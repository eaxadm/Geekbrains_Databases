/* Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. */

USE vk;

-- вывод для наглядности - с именами пользователей, датами рождения и кол-вом лайков для каждого пользователя 
SELECT 
    (SELECT CONCAT(firstname, ' ', lastname) 
       FROM users 
      WHERE id = user_id) AS user, 
    birthday,
    (SELECT COUNT(*) 
       FROM likes 
      WHERE item_id = profiles.user_id 
        AND like_type_id = 3) AS likes
  FROM   profiles 
 ORDER BY birthday DESC LIMIT 10;

-- вывод по условию задачи
SELECT SUM(likes.summ) AS 10_youngest_users_likes_sum
  FROM 
    (SELECT 
        (SELECT COUNT(*)
           FROM likes 
          WHERE item_id = profiles.user_id
            AND like_type_id = 3) AS summ
       FROM profiles
      ORDER BY birthday DESC LIMIT 10) AS likes;

