/* Добавить необходимые внешние ключи для всех таблиц базы данных vk (приложить команды) */

USE vk; 

ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
     FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
     FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

-- для постов, новостей и медиафайлов не уверен стОит ли их удалять при удалении 
-- пользователя (делает ли так ВК). поэтому пока restrict
ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
     ON DELETE RESTRICT;

ALTER TABLE newsline
  ADD CONSTRAINT newsline_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
     ON DELETE RESTRICT;

-- для сообщений также не уверен - стОит ли их удалять при удалении пользователя, т.к.
-- для них есть и второй "участник"
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id)
     ON DELETE RESTRICT,
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id)
     ON DELETE RESTRICT;

ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
     ON DELETE RESTRICT,
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
    ON DELETE RESTRICT;

ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  ADD CONSTRAINT likes_like_type_id_fk 
    FOREIGN KEY (like_type_id) REFERENCES like_types(id)
     ON DELETE RESTRICT;

ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
     ON DELETE CASCADE,
  ADD CONSTRAINT friendship_friend_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id)
     ON DELETE CASCADE;

ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
     ON DELETE CASCADE,
  ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id)
     ON DELETE CASCADE;

