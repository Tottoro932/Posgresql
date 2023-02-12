/*********************** Пример № 3 Читаем наши таблицы *********************/

SELECT * FROM prodmag.products; --прочитаем все столбцы и строки из таблицы products

--читаем сразу все таблицы с использованием псевдонимов, условий и сортировки
SELECT
	p.products_name AS product,
	t.food_type_name AS prod_type,
	u.unit_name AS unit,
	p.qty,
	p.price,
	p.cost,
	p.deadline,
	s.seller_name, 
	s.address, 
	s.inn
FROM 
	prodmag.products AS p,
	prodmag.units AS u,
	prodmag.food_types AS t,
	prodmag.sellers AS s
WHERE
	p.food_type_id = t.food_type_id
	AND p.unit_id = u.unit_id
	AND p.seller_id = s.seller_id
ORDER BY t.food_type_name ASC, p.price DESC; --отсортировали по типам продуктов и по цене от дорогих к дешевым

--выбираем уникальные ИНН и продавцов из наших таблиц
SELECT
	DISTINCT s.inn,
	s.seller_name
FROM 
	prodmag.products AS p,
	prodmag.sellers AS s
WHERE
	p.seller_id = s.seller_id
ORDER BY s.inn ASC;

--читаем таблицу products с использованием условий OR, IN, BETWEEN 
SELECT
	t.food_type_name,
	p.products_name,
	p.qty,
	p.price,
	p.cost,
	p.deadline
FROM 
	prodmag.products AS p,
	prodmag.food_types AS t
WHERE
	p.food_type_id = t.food_type_id
	AND (t.food_type_name = 'Фрукты' OR t.food_type_name = 'Овощи')
	AND (p.price BETWEEN 20 AND 100)
	AND p.deadline IN (10,15,20,30,45)
ORDER BY p.price ASC;

--читаем таблицу products с использованием подзапроса и LIMIT 1
SELECT
	(SELECT t.food_type_name FROM prodmag.food_types AS t WHERE p.food_type_id = t.food_type_id ORDER BY t.food_type_id LIMIT 1) AS prod_type,
	p.products_name,
	p.qty,
	p.price,
	p.cost,
	p.deadline
FROM prodmag.products AS p
ORDER BY p.price ASC;