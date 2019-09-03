/* Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять). */

USE vk;

-- --------------------------------------------------- Получаем данные пользователя ------------------------------------------------------------------------
-- orig:
SELECT
  firstname,
  lastname,
  (SELECT filename FROM media WHERE id = 
    (SELECT photo_id FROM profiles WHERE user_id = 1)
  ),
  (SELECT hometown FROM profiles WHERE user_id = 1)
  FROM users
    WHERE id = 1;     

-- upd тут можно добавить названия столбцам с фото и городом для удобства чтения таблицы: 
SELECT
  firstname,
  lastname,
  (SELECT filename FROM media WHERE id = 
    (SELECT photo_id FROM profiles WHERE user_id = 1)
  ) AS photo,
  (SELECT hometown FROM profiles WHERE user_id = 1) AS city
  FROM users
    WHERE id = 1; 

-- ------------------------------------------------- -- Найдём кому принадлежат 10 самых больших медиафайлов -------------------------------------------------------
-- orig:
SELECT 
  filename, 
  size,
  (SELECT CONCAT(firstname, ' ', lastname) 
     FROM users u 
    WHERE u.id = m.user_id) AS owner 
  FROM media m
 ORDER BY size DESC
 LIMIT 10;

-- upd сюда еще можно добавить тип файла:
SELECT 
  filename, 
  size,
  (SELECT name FROM media_types WHERE id = media_type_id) AS media_type,	
  (SELECT CONCAT(firstname, ' ', lastname) 
    FROM users u 
      WHERE u.id = m.user_id) AS owner 
  FROM media m
  ORDER BY size DESC
  LIMIT 10;

-- -------------------------------------------- Выбираем только друзей с подтверждённым статусом ----------------------------------------------------------------
-- orig:
(SELECT friend_id
  FROM friendship 
  WHERE user_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
)
UNION
(SELECT user_id
  FROM friendship 
  WHERE friend_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
);

-- upd здесь можно улучшить оформление - указать имя пользователя, перечислить имена друзей (а не просто их id), а также
-- указать дату и время "начала" дружбы:
(SELECT 
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = 1) 
    AS 'Пользователь',
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = friend_id) 
    AS 'Друзья',
  confirmed_at 
    AS 'Дружат с'
  FROM friendship 
  WHERE user_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
)
UNION
(SELECT 
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = 1), 
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = user_id),
  confirmed_at
  FROM friendship 
  WHERE friend_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
);

-- ------------------------------- Объединяем медиафайлы пользователя и его друзей для создания ленты новостей ------------------------------------------------
-- orig:
SELECT filename, user_id, created_at FROM media WHERE user_id = 1
UNION
SELECT filename, user_id, created_at FROM media WHERE user_id IN (
  (SELECT friend_id 
  FROM friendship 
  WHERE user_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
  )
  UNION
  (SELECT user_id 
    FROM friendship 
    WHERE friend_id = 1
      AND confirmed_at IS NOT NULL 
      AND status IS NOT NULL
  )
);

-- upd можно заменить user_id на имена и отсортировать по дате создания:
(SELECT 
  filename, 
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = 1) 
    AS user, 
  created_at 
  FROM media 
    WHERE user_id = 1)
UNION
(SELECT 
  filename, 
  (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id = user_id) 
    AS user, 
  created_at 
  FROM media 
    WHERE user_id IN (
      (SELECT friend_id 
        FROM friendship 
        WHERE user_id = 1
          AND confirmed_at IS NOT NULL 
          AND status IS NOT NULL
      )
      UNION
      (SELECT user_id 
        FROM friendship 
        WHERE friend_id = 1
          AND confirmed_at IS NOT NULL 
          AND status IS NOT NULL
      )
)) ORDER BY created_at DESC;

-- ----------------------------- -- Подсчитываем лайки для медиафайлов пользователя и его друзей -----------------------------------------
-- orig:
SELECT item_id AS mediafile, COUNT(*) AS likes 
  FROM likes 
    WHERE item_id IN (
      SELECT id FROM media WHERE user_id = 1  
      UNION
      SELECT id FROM media WHERE user_id IN (
        SELECT friend_id 
          FROM friendship 
            WHERE user_id = 1 
	AND status IS NOT NULL)
)
GROUP BY item_id;

-- upd. учитываем всех друзей (пропущены те, которые сами отправляли нашему пользователю запрос в друзья) и заменим id на имена файлов:
SELECT (SELECT filename FROM media WHERE id = item_id) AS mediafile, COUNT(*) AS likes 
  FROM likes 
    WHERE item_id IN (
      SELECT id FROM media WHERE user_id = 1
      UNION
      SELECT id FROM media WHERE user_id IN (
      (SELECT friend_id 
        FROM friendship 
        WHERE user_id = 1
          AND confirmed_at IS NOT NULL 
          AND status IS NOT NULL
      )
      UNION
      (SELECT user_id 
        FROM friendship 
        WHERE friend_id = 1
          AND confirmed_at IS NOT NULL 
          AND status IS NOT NULL
      ))
)
GROUP BY mediafile;

-- --------------------------------------------------------------- Непрочитанные сообщения ------------------------------------------------------------------
-- orig:
SELECT from_user_id, 
  to_user_id, 
  body, 
  IF(delivered, 'delivered', 'not delivered') AS status 
    FROM messages
	WHERE to_user_id = 2
        AND delivered IS NOT TRUE
    ORDER BY created_at DESC;

-- upd. условие IF(delivered, 'delivered', 'not delivered') здесь, как мне кажется, лишнее, т.к. мы выбираем только непрочитанные (AND delivered IS NOT TRUE)
-- а значит delivered в колонке status не будет в принципе:
SELECT from_user_id, 
  to_user_id, 
  body, 
  'not delivered' AS status 
    FROM messages
	WHERE to_user_id = 2
        AND delivered IS NOT TRUE
    ORDER BY created_at DESC;

-- -------------------------------------- Выводим друзей пользователя с преобразованием пола и возраста ---------------------------------------------------
-- orig:
SELECT 
    (SELECT CONCAT(firstname, ' ', lastname) 
      FROM users 
      WHERE id = user_id) AS friend,    
    CASE (sex)      
      WHEN 'm' THEN 'man'
      WHEN 'f' THEN 'women'
    END AS sex,
    TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
  FROM profiles
    WHERE user_id IN (
      SELECT friend_id 
        FROM friendship
          WHERE user_id = 1
          AND confirmed_at IS NOT NULL
	  AND status IS NOT NULL);

-- upd. здесь также не учтены друзья, сами отправившие запрос нашему пользователю:
SELECT 
    (SELECT CONCAT(firstname, ' ', lastname) 
       FROM users 
      WHERE id = user_id) AS friend,    
    CASE (sex)      
      WHEN 'm' THEN 'man'
      WHEN 'f' THEN 'women'
    END AS sex,
    TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
  FROM profiles
    WHERE user_id IN (
      (SELECT friend_id 
         FROM friendship 
        WHERE user_id = 1
          AND confirmed_at IS NOT NULL 
          AND status IS NOT NULL)
      UNION
      (SELECT user_id 
        FROM friendship 
        WHERE friend_id = 1
          AND confirmed_at IS NOT NULL 
          AND status IS NOT NULL) );

