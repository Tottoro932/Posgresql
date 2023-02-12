/*********************** Пример № 9 Сочетание запросов  *******************************/

--создадим две тестовые таблички и заполним их данными
CREATE TABLE public.city_1 
	(
	id SMALLSERIAL NOT NULL,
	name VARCHAR(32) NOT NULL,
	CONSTRAINT city_1_name_ukey UNIQUE(name),
	CONSTRAINT city_1_pkey PRIMARY KEY(id)
	);
	
CREATE TABLE public.city_2 
	(
	id SMALLSERIAL NOT NULL,
	name VARCHAR(32) NOT NULL,
	CONSTRAINT city_2_name_ukey UNIQUE(name),
	CONSTRAINT city_2_pkey PRIMARY KEY(id)
	);
	
INSERT INTO public.city_1 (name) VALUES ('Москва'),('Смоленск'),('Новгород'),('Казань'),('Омск'),('Ростов'),('Иркутск'),('Хабаровск'),('Тула'),('Ялта');
INSERT INTO public.city_2 (name) VALUES ('Ярославль'),('Руза'),('Казань'),('Чита'),('Норильск'),('Москва'),('Томск'),('Рязань'),('Ижевск'),('Уссурийск');

--пробуем объединить запросы из обоих таблиц
SELECT s.name FROM
	(
	SELECT t1.name FROM public.city_1 AS t1
	UNION --ALL
	SELECT t2.name FROM public.city_2 AS t2
	) AS s
ORDER BY s.name;

--тестируем пересечение запросов
SELECT s.name FROM
	(
	SELECT t1.name FROM public.city_1 AS t1
	INTERSECT
	SELECT t2.name FROM public.city_2 AS t2
	) AS s
ORDER BY s.name;

--тестируем вычитание запросов 
SELECT s.name FROM
	(
	SELECT t1.name FROM public.city_1 AS t1
	EXCEPT
	SELECT t2.name FROM public.city_2 AS t2
	) AS s
ORDER BY s.name;