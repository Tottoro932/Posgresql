/*********************** Пример № 16 скалярные Функции с аргументами *******************************/

--скалярная функция на языке SQL получает на вход дату и выдёт мин и макс суммы бронирований за эту дату
CREATE OR REPLACE FUNCTION public.f_get_min_max_amount_by_date(IN _date TIMESTAMPTZ, OUT _min NUMERIC, OUT _max NUMERIC)
--RETURNS писать не нужно, если используются выходные аргументы
AS
$$

	SELECT MIN(total_amount), MAX(total_amount) --важен порядок полей в селекте, он должен соотвествовать порядку OUT параметров
    FROM bookings.bookings 
    WHERE book_date = _date;

$$
LANGUAGE SQL;

--теперь вызовем её
SELECT * FROM public.f_get_min_max_amount_by_date('2017-05-15');


--скалярная функция на языке PL/pgSQL получает на вход дату и выдёт сумму и среднее из бронирований за эту дату
CREATE OR REPLACE FUNCTION public.f_get_sum_and_avg_amount_by_date(IN _date TIMESTAMPTZ, OUT _sum NUMERIC, OUT _avg NUMERIC)
AS
$$
BEGIN

	SELECT SUM(total_amount), AVG(total_amount) INTO _sum, _avg --тут мы явно указываем какое значение в какую переменную пишем
    FROM bookings.bookings
    WHERE book_date = _date;
    
END;
$$
LANGUAGE PLPGSQL;

--теперь вызовем её
SELECT * FROM public.f_get_sum_and_avg_amount_by_date('2017-05-15');


--Пример функции с аргументом INOUT. Возвращает квадрат числа
CREATE OR REPLACE FUNCTION f_get_square (INOUT NUMERIC) 
AS 
$$
    SELECT $1 * $1;
$$ 
LANGUAGE SQL;

SELECT f_get_square(2);

--пример с типом VARIADIC возвращает минимальное значение из массива
--https://postgrespro.ru/docs/postgrespro/12/functions-srf
--https://stackoverflow.com/questions/10674735/in-postgresql-what-is-gi-in-FROM-generate-subscripts1-1-gi
CREATE OR REPLACE FUNCTION f_get_array_min(VARIADIC arr NUMERIC[]) 
RETURNS NUMERIC 
AS 
$$
    SELECT MIN($1[i]) FROM generate_subscripts($1, 1) g(i);
$$ 
LANGUAGE SQL;

SELECT f_get_array_min(10, -1, 5, 4.4, -2.05);