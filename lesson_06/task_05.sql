/* Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети. */

USE vk;

/* оценивал активность пользователя как сумму всех действий, произведенных им в соцсети, по всем таблицам: кол-во групп, в к-х он состоит + 
кол-во подтвержденных друзей + кол-во лайков, поставленных им + кол-во его медиафайлов и тд.
Для наглядности вывел все в одну таблицу */
SELECT
      id AS user,
      (SELECT CONCAT(firstname, ' ', lastname) 
         FROM users 
        WHERE id = user) AS fullname,
      (SELECT COUNT(*)
         FROM communities_users
        WHERE user_id = user) AS groups_count,
      (SELECT COUNT(*)
         FROM friendship
        WHERE (user_id = user OR friend_id = user)
            AND confirmed_at IS NOT NULL 
            AND status IS NOT NULL ) AS friends_count,
      (SELECT COUNT(*)
         FROM likes
        WHERE user_id = user) AS likes_count,
      (SELECT COUNT(*)
         FROM media
        WHERE user_id = user) AS media_count,
      (SELECT COUNT(*)
         FROM messages
        WHERE from_user_id = user) AS messages_count,
      (SELECT COUNT(*)
         FROM newsline
        WHERE user_id = user) AS news_count,
      (SELECT COUNT(*)
         FROM posts
        WHERE user_id = user) AS posts_count,
      (SELECT (groups_count + friends_count + likes_count + media_count + messages_count + news_count + posts_count)) AS activity
  FROM users
 ORDER BY activity LIMIT 10;
