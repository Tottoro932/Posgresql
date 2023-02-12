/*********************** Пример № 4 Изменяем данные в таблицах *********************/

-- сделаем скидку на продукты с малым сроком хранения
UPDATE prodmag.products SET price = price * 0.95 WHERE deadline <= 10;


-- создадим табличку с остатками продуктов и обновим таблицу products из неё

--создаем таблицу
CREATE TABLE prodmag.product_remains
	(
	product_id INTEGER,
	qty_remains INTEGER
	);

--запитсываем в неё ID продуктов из таблицы products и случайное число от 0 до 99 в поле остатка
INSERT INTO prodmag.product_remains
SELECT 
	product_id,
	(RANDOM() * 100)::INTEGER
FROM prodmag.products;

--посмотрим, что получилось
SELECT * FROM prodmag.product_remains;

--обновим данные в таблице products из таблицы product_remains
UPDATE prodmag.products
SET qty = s.new_qty
FROM
	(
	SELECT 
		product_id AS new_id,
		qty_remains AS new_qty
	FROM prodmag.product_remains
	) AS s
WHERE product_id = s.new_id;

--смотрим результат
SELECT
	p.products_name,
	p.qty,
	p.price,
	p.cost --замечаем, что после изменения поля qty пересчиталось значение в расчетном поле cost
FROM prodmag.products AS p
ORDER BY p.products_name ASC;