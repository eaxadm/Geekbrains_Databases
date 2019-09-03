/* Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользоваетелем. */

USE vk;

-- фразу "общался больше всех" можно трактовать как:
-- вариант 1 - дольше всех (первый ставший другом):
SELECT 
     (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = 10) AS 'user',
     (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = friend_id) AS 'friend',
     confirmed_at AS 'since'
  FROM friendship 
 WHERE user_id = 10
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL 
UNION
SELECT 
     (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = 10),
     (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = user_id),
     confirmed_at
  FROM friendship 
 WHERE friend_id = 10
     AND confirmed_at IS NOT NULL 
     AND status IS NOT NULL 
 ORDER BY since LIMIT 1;


-- вариант 2 - активнее всех (больше всего сообщений между ними):
SELECT 
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = 10) AS 'user',
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = friend_id) AS 'friend',
  (SELECT                                                                    -- подсчитываем сообщения от пользователя другу + от друга нашему пользователю
      (SELECT COUNT(*) FROM messages WHERE from_user_id = 10 AND to_user_id = friend_id)
      + 
      (SELECT COUNT(*) FROM messages WHERE from_user_id = friend_id AND to_user_id = 10))AS messages
  FROM friendship 	
 WHERE user_id = 10
     AND confirmed_at IS NOT NULL 
     AND status IS NOT NULL 
UNION
SELECT 
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = 10),
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = user_id),
  (SELECT 
      (SELECT COUNT(*) FROM messages WHERE from_user_id = user_id AND to_user_id = 10)
      + 
      (SELECT COUNT(*) FROM messages WHERE from_user_id = 10 AND to_user_id = user_id))
  FROM friendship 
 WHERE friend_id = 10
     AND confirmed_at IS NOT NULL 
     AND status IS NOT NULL
 ORDER BY messages DESC, friend LIMIT 1;

