/*********************** Пример № 8 Работа с представлениями *******************************/

--создадим представление из нашего запроса по продуктам
CREATE OR REPLACE VIEW prodmag.v_products AS
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
FROM prodmag.products AS p
JOIN prodmag.units AS u USING(unit_id)
JOIN prodmag.food_types AS t USING(food_type_id)
JOIN prodmag.sellers AS s USING(seller_id)
ORDER BY t.food_type_name ASC, p.price DESC;

--почитаем данныне из нашего представления
SELECT * FROM prodmag.v_products;