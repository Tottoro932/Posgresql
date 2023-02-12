/************************** СХЕМЫ ****************************/

-- Создание схемы 
CREATE SCHEMA test;

--Удалить пустую схему (не содержащую объектов)

DROP SCHEMA test;

--Удалить схему со всеми содержащимися в ней объектами

DROP SCHEMA test CASCADE;

--Cоздать схему, владельцем которой будет другой пользователь

CREATE SCHEMA test AUTHORIZATION test_user;

--Переименовать схему 

ALTER SCHEMA test RENAME TO new_test;

--Сменить владельца схемы

ALTER SCHEMA test OWNER TO test_user;