/*********************** Пример № 18 процедуры принимающие множества *******************************/

--Пример с JSON
--создадим таблицу, куда будем писать значения
CREATE TABLE public.tag_values
	(
    tag_id INTEGER NOT NULL,
    date_time TIMESTAMP NOT NULL,
    tag_value REAL NOT NULL,
    CONSTRAINT tag_values_pkey PRIMARY KEY(tag_id, date_time)
    );

--создадим табличный тип данных
CREATE TYPE public.ct_tag_values AS 
	(
	tag_id INTEGER,
    date_time TIMESTAMP,
    tag_value REAL
	);

--создадим процедуру записи значений
CREATE OR REPLACE PROCEDURE public.p_set_tag_values_json(input_values JSON) AS
$$
BEGIN

	INSERT INTO public.tag_values
    SELECT *
    FROM JSON_POPULATE_RECORDSET(NULL::public.ct_tag_values, input_values) AS t;
    
END;
$$
LANGUAGE PLPGSQL;

--Вызовем нашу процедуру и передадим данные в формате JSON
CALL public.p_set_tag_values_json('[{"tag_id":1,"date_time":"2023-01-25 00:00:00","tag_value":2.26954},{"tag_id":2,"date_time":"2023-01-25 00:00:00","tag_value":890.587894},{"tag_id":3,"date_time":"2023-01-25 00:00:00","tag_value":-9.587894},{"tag_id":1,"date_time":"2023-01-25 00:01:00","tag_value":2.35784},{"tag_id":2,"date_time":"2023-01-25 00:01:00","tag_value":891.74594},{"tag_id":3,"date_time":"2023-01-25 00:01:00","tag_value":-9.7940894}]');

--Посмотрим, что упало в таблицу
SELECT * FROM public.tag_values;


--создадим процедуру записи значений из составного типа
CREATE OR REPLACE PROCEDURE public.p_set_tag_values_ct(input_values public.ct_tag_values) 
AS
$$
BEGIN

	INSERT INTO public.tag_values
    VALUES (input_values.tag_id, input_values.date_time, input_values.tag_value);
    
END;
$$
LANGUAGE PLPGSQL;

--Вызовем нашу процедуру и передадим данные
CALL public.p_set_tag_values_ct('(2,''2023-01-25 00:02:00'',265.26954)'::public.ct_tag_values);

--Вызовем нашу процедуру и передадим данные вариант с помощью табличного конструктора ROW
CALL public.p_set_tag_values_ct(ROW(2,'2023-01-25 00:05:00',262.25954));


--Посмотрим, что упало в таблицу
SELECT * FROM public.tag_values;