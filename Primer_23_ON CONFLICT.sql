/*********************** Пример № 23 ON CONFLICT *******************************/

--запрос ничего не вставит
INSERT INTO prodmag.sellers
	(
  	seller_name,
  	address,
  	inn
	)
VALUES ('РусАгро', 'г. Ростов, ул. Мира, д.1, стр. В', '77885126294')
ON CONFLICT(seller_name) DO NOTHING;

--произойдет обновление полей адрес и ИНН
INSERT INTO prodmag.sellers
	(
  	seller_name,
  	address,
  	inn
	)
VALUES ('РусАгро', 'г. Ростов, ул. Мира, д.1, стр. Б', '77885126294')
ON CONFLICT(seller_name) DO UPDATE
SET
	address = excluded.address,
    inn     = excluded.inn;
    
--Смотрим результат
SELECT *  FROM prodmag.sellers ;