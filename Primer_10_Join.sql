/*********************** Пример № 10 Соединение запросов  *******************************/

--создадим ещё одну табличку с телефонными кодами городов и заполним её значениями
CREATE TABLE public.tel_codes 
	(
	id SMALLSERIAL NOT NULL,
	code VARCHAR(5) NOT NULL,
	CONSTRAINT tel_codes_code_ukey UNIQUE(code),
	CONSTRAINT tel_codes_pkey PRIMARY KEY(id)
	);

INSERT INTO public.tel_codes (id, code) VALUES (1,'495'),(2,'481'),(4,'843'),(5,'381'),(6,'863'),(7,'395'),(9,'487'),(10,'3654'),(11,'855');

--делаем INNER JOIN двух таблиц с использованием USING
SELECT 
	t1.id,
	t1.name,
	t2.code
FROM public.city_1 AS t1
JOIN public.tel_codes AS t2 
	USING(id) --указываем поле, по которому делаем соединение таблиц
ORDER BY t1.id;

--делаем LEFT JOIN двух таблиц с использованием ON
SELECT 
	t1.id,
	t1.name,
	t2.code
FROM public.city_1 AS t1
LEFT JOIN public.tel_codes AS t2 
	ON t1.id = t2.id --указываем поля таблиц по которым делаем соединение
ORDER BY t1.id;

--делаем RIGHT JOIN двух таблиц с использованием ON
SELECT 
	t1.id,
	t1.name,
	t2.code
FROM public.city_1 AS t1
RIGHT JOIN public.tel_codes AS t2 
	ON t1.id = t2.id --указываем поля таблиц по которым делаем соединение
ORDER BY t1.id;

--делаем FULL JOIN двух таблиц с использованием ON
SELECT 
	t1.id,
	t1.name,
	t2.code
FROM public.city_1 AS t1
FULL JOIN public.tel_codes AS t2 
	ON t1.id = t2.id --указываем поля таблиц по которым делаем соединение
ORDER BY t1.id;
