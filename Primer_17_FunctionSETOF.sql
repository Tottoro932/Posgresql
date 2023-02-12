/*********************** Пример № 17 Функции возвращающие множества *******************************/
--функция на языке SQL возвращает средние стоимости брони по датам
CREATE OR REPLACE FUNCTION public.f_get_avg_amount_group_by_date()
RETURNS SETOF NUMERIC
AS
$$

	SELECT AVG(total_amount)
    FROM bookings.bookings 
    GROUP BY book_date::DATE; --привел таймштамп к дате, чтобы была группировка по суткам

$$
LANGUAGE SQL;

--теперь вызовем её
SELECT * FROM public.f_get_avg_amount_group_by_date();
--получилось не очень наглядно т.к. нету самой даты, давайте добавим


--функция на языке SQL возвращает средние стоимости брони по датам
CREATE OR REPLACE FUNCTION public.f_get_avg_amount_group_by_date_v2(OUT date TIMESTAMPTZ, OUT avg_amount NUMERIC)
RETURNS SETOF RECORD
AS
$$

	SELECT book_date::DATE, AVG(total_amount)
    FROM bookings.bookings 
    GROUP BY book_date::DATE --привел таймштамп к дате, чтобы была группировка по суткам
	ORDER BY book_date::DATE;

$$
LANGUAGE SQL;

--смотрим, что теперь получилось
SELECT * FROM public.f_get_avg_amount_group_by_date_v2();

--что будет, если не указывать OUT параметры?
--пробуем:
CREATE OR REPLACE FUNCTION public.f_get_avg_amount_group_by_date_v3()
RETURNS SETOF RECORD
AS
$$

	SELECT book_date::DATE, AVG(total_amount)
    FROM bookings.bookings 
    GROUP BY book_date::DATE --привел таймштамп к дате, чтобы была группировка по суткам
	ORDER BY book_date::DATE;

$$
LANGUAGE SQL;

--делаем селект
SELECT * FROM public.f_get_avg_amount_group_by_date_v3();

--ожидаемо не таботает, т.к. у на получился на выходе анонимный тип RECORD, 
--но решение есть, нужно добавить описание типов после имени функции в скобках: 
SELECT * FROM public.f_get_avg_amount_group_by_date_v3() AS (date TIMESTAMPTZ, avg_amount NUMERIC); 

--теперь напишем функцию, которая вернет таблицу с моделями самолетов и их максимальной дальностью перелета
CREATE OR REPLACE FUNCTION public.f_get_aircraft_ranges()
RETURNS TABLE
	(
	aircraft_model TEXT,
	range INTEGER
	)
AS
$$

	SELECT 
		model->>'ru', --выдергиваем значение из объекта json
		range
	FROM bookings.aircrafts_data;

$$
LANGUAGE SQL;

--делаем селект
SELECT * FROM public.f_get_aircraft_ranges();

--теперь аналогичный запрос на PL/pgSQL
CREATE OR REPLACE FUNCTION public.f_get_aircraft_ranges_v2()
RETURNS TABLE
	(
	aircraft_model TEXT,
	range INTEGER
	)
AS
$$
BEGIN
	
    RETURN QUERY --таблицу возвращаем через RETURN QUERY
    SELECT 
		ad.model->>'ru',
		ad.range
	FROM bookings.aircrafts_data AS ad;
    
END;
$$
LANGUAGE PLPGSQL;

--делаем селект
SELECT * FROM public.f_get_aircraft_ranges_v2();


--и теперь последний вариант SETOF table, которая вернет нам все колонки из таблицы с описанием самолетов
CREATE OR REPLACE FUNCTION public.f_get_aircraft_data()
RETURNS SETOF bookings.aircrafts_data
AS
$$

	SELECT * FROM bookings.aircrafts_data;

$$
LANGUAGE SQL;

--делаем селект
SELECT * FROM public.f_get_aircraft_data();