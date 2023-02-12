/*********************** Пример № 21 циклы *******************************/


--посчитаем ряд фибоначи до числа _num и вернем в массив
--пример цикла WHILE
CREATE OR REPLACE FUNCTION public.f_calc_fib(_num INT) 
RETURNS INT[] AS
$$
DECLARE 
	i INT = 0;
    j INT = 1;
    cnt INT = 0;
    res INT[];
BEGIN

    IF _num < 0
    THEN RETURN 0;
    END IF;
    
    WHILE cnt <= _num --выполняем цикл, пока счетчик cnt меньше или равен _num
    LOOP
    	
        cnt := cnt + 1;
        SELECT j, i+j INTO i, j;
        res[cnt] := i;
    	
    END LOOP;
    
    RETURN res;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT public.f_calc_fib(20);

--пример цикла LOOP
CREATE OR REPLACE FUNCTION public.f_calc_fib_v2(_num INT) 
RETURNS INT[] AS
$$
DECLARE 
	i INT = 0;
    j INT = 1;
    cnt INT = 0;
    res INT[];
BEGIN

    IF _num < 0
    THEN RETURN 0;
    END IF;
    
    LOOP
    	
		EXIT WHEN cnt > _num; --выходим из цикла, когда счетчик cnt больше _num
        cnt := cnt + 1;
        SELECT j, i+j INTO i, j;
        res[cnt] := i;
    	
    END LOOP;
    
    RETURN res;
	
END;
$$
LANGUAGE PLPGSQL;

--пример цикла FOR
CREATE OR REPLACE FUNCTION public.f_calc_fib_v3(_num INT) 
RETURNS INT[] AS
$$
DECLARE 
	i INT = 0;
    j INT = 1;
    cnt INT = 0;
    res INT[];
BEGIN

    IF _num < 0
    THEN RETURN 0;
    END IF;
    
    FOR cnt IN 0 .. _num
    LOOP
    	
        cnt := cnt + 1;
        SELECT j, i+j INTO i, j;
        res[cnt] := i;
    	
    END LOOP;
    
    RETURN res;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT public.f_calc_fib_v3(20);

--пример цикла FOR по результатам запроса
--функция ищет самый длительный по времени перелет за указанные сутки
CREATE OR REPLACE FUNCTION public.f_get_longest_flight(_date DATE)
RETURNS SETOF bookings.flights
AS
$$
DECLARE 
	rec RECORD; --декларируем переменную типа RECORD, в которую будут помещаться текущие строки в цикле
    flight_interval INTERVAL = 0;
    row_id INTEGER;
BEGIN
        
    FOR rec IN --запускаем цикл по результату запроса
        SELECT 
        	f.flight_id AS id,
            f.scheduled_departure AS departure,
            f.scheduled_arrival AS arrival
        FROM bookings.flights AS f
        WHERE f.scheduled_departure::DATE = _date
    LOOP
    
    	IF (rec.arrival - rec.departure) > flight_interval
        THEN
         
        	flight_interval := (rec.arrival - rec.departure);
            row_id := rec.id;
            
        END IF;
    
    END LOOP;
    
    RETURN QUERY
    SELECT * FROM bookings.flights AS res WHERE res.flight_id = row_id;
    
END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM public.f_get_longest_flight('2017-05-10');



--Пример цикла FOREACH и передачи на вход функции массива
CREATE OR REPLACE FUNCTION public.f_get_flights_from_array(CHAR(6)[]) --не указал имя входной переменной, так то же можно
RETURNS TABLE
	(
    flight_no CHAR(6),
    scheduled_departure TIMESTAMPTZ,
    departure_airport_code CHAR(3),
    departure_city TEXT,
    departure_airport_name TEXT,
    scheduled_arrival TIMESTAMPTZ,
    arrival_airport_code CHAR(3),
    arrival_city TEXT,
    arrival_airport_name TEXT,
    aircraft_model TEXT
    ) 
AS
$$
DECLARE 
	cur_flight_no CHAR(6); --объявил переменную, в которую будет писаться текущее значение из массива
BEGIN

    --объявляю временную таблицу
	CREATE TEMP TABLE flights_tmp
		(
		flight_no CHAR(6),
        scheduled_departure TIMESTAMPTZ,
        departure_airport_code CHAR(3),
        departure_city TEXT,
        departure_airport_name TEXT,
        scheduled_arrival TIMESTAMPTZ,
        arrival_airport_code CHAR(3),
        arrival_city TEXT,
        arrival_airport_name TEXT,
        aircraft_model TEXT
		) ON COMMIT DROP;
        
    --перебираю элементы массива в цикле
	FOREACH cur_flight_no IN ARRAY $1 --обратился к входной переменной по номеру т.к. она безимянная
    LOOP
    
    	INSERT INTO flights_tmp
        SELECT 
            f.flight_no,
            f.scheduled_departure,
            f.departure_airport, 
            ap1.city,
            ap1.airport_name,
            f.scheduled_arrival,
            f.arrival_airport, 
            ap2.city,
            ap2.airport_name,
            a.model
        FROM bookings.flights AS f 
        JOIN bookings.aircrafts AS a 
            ON a.aircraft_code = f.aircraft_code 
        JOIN bookings.airports AS ap1
            ON ap1.airport_code = f.departure_airport 
        JOIN bookings.airports AS ap2
            ON ap2.airport_code = f.arrival_airport
        WHERE f.flight_no = cur_flight_no --пишу во временную таблицу строки у которых номер рейса равен текущему значению из массива
        ORDER BY f.scheduled_departure DESC
        LIMIT 1;
    
    END LOOP;
    
    --возвращаю строки из временной таблицы
	RETURN QUERY SELECT * FROM flights_tmp;
	
END;
$$
LANGUAGE PLPGSQL;

--передаю в функцию массив
SELECT * FROM public.f_get_flights_from_array(ARRAY['PG0216','PG0212','PG0416','PG0055','PG0341','PG0335','PG0335','PG0239','PG0542','PG0029','PG0454','PG0383']);

--пример с FOR и RETURN NEXT
--создадим табличный тип данных
CREATE TYPE public.ct_products AS 
	(
	product VARCHAR(24),
    prod_type VARCHAR(16),
    unit VARCHAR(5),
    qty INT,
    price NUMERIC(6,2),
    cost NUMERIC(10,2),
    deadline SMALLINT,
    seller_name VARCHAR(32),
    address VARCHAR(100),
    inn CHAR(11)
	);
	
CREATE OR REPLACE FUNCTION public.f_set_after_new_year_sale()
RETURNS SETOF public.ct_products AS --возвращаем записи, как у табличного типа ct_products
$$
DECLARE rec RECORD; --объявляем переменную типа RECORD
BEGIN

	FOR rec IN 
	SELECT
		p.products_name,
		t.food_type_name,
		u.unit_name,
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
	ORDER BY t.food_type_name ASC, p.price DESC
	
	LOOP --в цикле манипулируем ценой
	
		IF rec.deadline < 10 THEN
		rec.price := rec.price * 0.5;
		rec.cost := rec.price * rec.qty;
		ELSIF rec.deadline < 30 THEN
		rec.price := rec.price * 0.75;
		rec.cost := rec.price * rec.qty;
		ELSE 
		rec.price := rec.price * 0.95;
		rec.cost := rec.price * rec.qty;
		END IF;
		
		RETURN NEXT rec; --и измененные записи выдаем наружу
	
	END LOOP;

END;
$$
LANGUAGE PLPGSQL;

--выборка из функции
SELECT * FROM public.f_set_after_new_year_sale();
--убеждаемся, что данные в таблице не менялись
SELECT * FROM public.v_products; 