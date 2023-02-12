/*********************** Пример № 19 работа с переменными в функциях *******************************/

--создадим функцию, считающую площадь треугольника
CREATE OR REPLACE FUNCTION public.f_get_triangle_square(ab REAL, bc REAL, ca REAL) 
RETURNS REAL AS
$$
DECLARE 
	perimeter REAL; --задекларировали переменную
BEGIN
	
	perimeter := (ab + bc + ca) / 2; --присвоили ей значение
	RETURN SQRT(perimeter * (perimeter - ab) * (perimeter - bc) * (perimeter - ca));
	
END;
$$
LANGUAGE PLPGSQL;

--делаем вызов
SELECT public.f_get_triangle_square(3.5, 4.8, 1.9);

--сделаем выборку цен бронирования на основе корридора от среднего прайса
CREATE OR REPLACE FUNCTION public.f_get_booking_amount_by_interval()
RETURNS SETOF NUMERIC AS
$$
DECLARE
	avg_price NUMERIC;
    low_price NUMERIC;
    high_price NUMERIC;
BEGIN

	SELECT AVG(total_amount) INTO avg_price FROM bookings.bookings;
    
    low_price := avg_price * 0.5;
    high_price := avg_price * 1.5;
    
    RETURN QUERY 
    SELECT DISTINCT total_amount FROM bookings.bookings
    WHERE total_amount BETWEEN low_price AND high_price
    ORDER BY total_amount;

END;
$$
LANGUAGE PLPGSQL;

--читаем результат
SELECT * FROM public.f_get_booking_amount_by_interval();

--пример функции с использованием временной таблицы

--напишем функцию, которая покажет, есть ли недоплаты по бронированию билетов
--т.е. идет сравнение суммы из бронирования с суммарной ценой билетов по каждой броне
CREATE OR REPLACE FUNCTION public.f_get_booking_underpayments()
RETURNS TABLE
	(
    book_ref CHAR(6),
    book_date TIMESTAMPTZ,
    book_total_amount NUMERIC(10,2),
    tickets_sum_amount NUMERIC(10,2)
    ) 
AS
$$
BEGIN

	CREATE TEMP TABLE ticket_sum_price_tmp
		(
		book_ref CHAR(6),
        sum_amount NUMERIC(10,2)
		) ON COMMIT DROP;
    
    INSERT INTO ticket_sum_price_tmp
    SELECT 
		t.book_ref,
		SUM(tf.amount)
	FROM bookings.tickets t 
	JOIN bookings.ticket_flights tf 
		ON tf.ticket_no = t.ticket_no 
	GROUP BY t.book_ref; 
    
    RETURN QUERY 
    SELECT 
        b.book_ref, 
        b.book_date, 
        b.total_amount,
        t.sum_amount 
	FROM bookings.bookings as b
	JOIN ticket_sum_price_tmp AS t
		ON t.book_ref = b.book_ref
	WHERE b.total_amount <> t.sum_amount;

END;
$$
LANGUAGE PLPGSQL;

--создадим фейковую недоплату
UPDATE bookings.bookings SET total_amount = 25000 WHERE total_amount = 34500;

--посмотрим на результат
SELECT * FROM public.f_get_booking_underpayments();