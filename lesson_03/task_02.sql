-- Таблица лайков для медиафайлов
/*
media_id - какой именно медиафайл из таблицы media
user_id - кем пролайкан из таблицы users
liked_at - когда пролайкан */
CREATE TABLE likes_media (
    media_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    liked_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (media_id, user_id)
);

-- Таблица лайков для пользователей
/*
user_id - кто пролайкан
liked_by -кем
liked_at - когда
*/
CREATE TABLE likes_users (
    user_id INT UNSIGNED NOT NULL,
    liked_by INT UNSIGNED NOT NULL,
    liked_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (user_id, liked_by)
);

-- Таблица с постами
/*
body - текст поста
user_id - каким пользователем создан
is_media - содержит медиа-файлы или нет
created_at - дата создания поста*/
CREATE TABLE posts (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    body TEXT NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    is_media BOOLEAN,
    created_at DATETIME DEFAULT NOW()
);

-- Таблица связи постов и медиафайлов
CREATE TABLE posts_media(
    post_id INT UNSIGNED NOT NULL,
    media_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (post_id, media_id)
);

-- Таблица лайков для постов
/*
аналогично медиалайкам и юзерлайкам*/
CREATE TABLE likes_posts (
    post_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    liked_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (post_id, user_id)
);
