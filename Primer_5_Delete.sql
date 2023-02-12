/*********************** Пример № 5 Удаление данных в таблицах *********************/

--удаление строк, у которых product_id больше пяти
DELETE FROM prodmag.product_remains WHERE product_id > 5;

--смотрим, что у нас осталось в таблице product_remains
SELECT * FROM prodmag.product_remains;

--удаление с использованием подзапроса тех строк в products, у которых есть соответствие по полю product_id в таблице product_remains
DELETE FROM prodmag.products AS p
USING prodmag.product_remains AS r
WHERE p.product_id = r.product_id;
	
--полная очистка таблицы
TRUNCATE TABLE prodmag.product_remains;

--снова смотрим, что у нас осталось в таблице product_remains
SELECT * FROM prodmag.product_remains;