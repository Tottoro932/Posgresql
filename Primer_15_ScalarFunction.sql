/*********************** Пример № 15 скалярные Функции без аргументов*******************************/

--Напишем простую скалярную функцию на языке SQL, не имеющую входных параметров и возвращающую сумму всех бронирований
CREATE OR REPLACE FUNCTION public.f_get_sum_total_amount()
RETURNS NUMERIC AS
$$

	SELECT SUM(total_amount) FROM bookings.bookings;

$$
LANGUAGE SQL;

--теперь вызовем её
SELECT public.f_get_sum_total_amount();

--теперь создадим её аналог, но на языке PL/pgSQL, она будет возвращать нам среднее значение всех бронирований
CREATE OR REPLACE FUNCTION public.f_get_avg_total_amount()
RETURNS NUMERIC AS
$$
BEGIN

	RETURN avg(total_amount) 
	FROM bookings.bookings;
    
END;
$$
LANGUAGE PLPGSQL;

--теперь вызовем её
SELECT public.f_get_avg_total_amount();