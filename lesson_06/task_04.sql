/* Определить кто больше поставил лайков (всего) - мужчины или женщины? */

USE vk;

SELECT
     (SELECT SUM(men.likes)
        FROM
           (SELECT
                 (SELECT COUNT(id) 
                    FROM likes 
                   WHERE likes.user_id = profiles.user_id) AS likes
              FROM profiles 
             WHERE sex = 'm') AS men) AS men_likes,	
     (SELECT SUM(women.likes)
        FROM
           (SELECT
                 (SELECT COUNT(id) 
                    FROM likes 
                   WHERE likes.user_id = profiles.user_id) AS likes
              FROM profiles 
             WHERE sex = 'f') AS women) AS women_likes;
