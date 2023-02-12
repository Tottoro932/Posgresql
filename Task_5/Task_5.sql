------------------- Task_5 -------------------------

-- 1 --
-- case --
CREATE OR REPLACE FUNCTION public.f_get_number_case(_month_num INT) 
RETURNS INT AS
$$
DECLARE 
	_result INT;
BEGIN

    CASE  
    WHEN _month_num BETWEEN 1 AND 3 THEN _result := 1;
    WHEN _month_num BETWEEN 4 AND 6 THEN _result := 2;
	WHEN _month_num BETWEEN 7 AND 9 THEN _result := 3;
    WHEN _month_num BETWEEN 10 AND 12 THEN _result := 4;
	ELSE _result := 0;
	END CASE;
    
    RETURN _result;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT f_get_number_case(2);

-- if --
CREATE OR REPLACE FUNCTION public.f_get_number_if(_month_num INT) 
RETURNS INT AS
$$
DECLARE 
	_result INT;
BEGIN

    IF _month_num BETWEEN 1 AND 3 THEN _result := 1;
    ELSIF _month_num BETWEEN 4 AND 6 THEN _result := 2;
	ELSIF _month_num BETWEEN 7 AND 9 THEN _result := 3;
    ELSIF _month_num BETWEEN 10 AND 12 THEN _result := 4;
	ELSE _result := 0;
	END IF;
    
    RETURN _result;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT f_get_number_if(10);

-- 2 --
-- функция (вход: месяц, город вылета, выход: список номеров рейсов)
CREATE OR REPLACE FUNCTION public.f_get_flight(IN mon NUMERIC, IN town VARCHAR(40))
RETURNS SETOF char(6) AS
$$
	SELECT f.flight_no
	FROM bookings.flights AS f
	JOIN bookings.airports_data AS a
		ON f.departure_airport = a.airport_code 
	WHERE (a.city->>'ru' = town) AND (EXTRACT(MONTH FROM f.scheduled_departure) = mon)
$$
LANGUAGE SQL;

SELECT * FROM public.f_get_flight(5,'Екатеринбург');

-- 3 --
--создадим табличный тип данных
CREATE TYPE public.ct_products AS 
	(
	product_id INTEGER, 
	products_name VARCHAR(24),
	food_type_id SMALLINT,
	unit_id SMALLINT,
	qty INTEGER,
	price NUMERIC(6,2),
	seller_id INTEGER,
	deadline SMALLINT
	);

--drop TYPE public.ct_products cascade

--создадим процедуру записи значений
CREATE OR REPLACE PROCEDURE public.p_w_ct_products_json(input_values JSON) AS
$$
BEGIN

	INSERT INTO prodmag.products (product_id,products_name,food_type_id,unit_id,qty,price,seller_id,deadline)
    SELECT * FROM JSON_POPULATE_RECORDSET(NULL::public.ct_products, input_values) AS t;
    
END;
$$
LANGUAGE PLPGSQL;

--Вызовем нашу процедуру и передадим данные в формате JSON
CALL public.p_w_ct_products_json('[{"product_id": 37,"products_name": "Абрикос","food_type_id": 10,"unit_id":2,"qty": 4,"price": 117.02,"seller_id": 5,"deadline":37}]');

--Посмотрим, что упало в таблицу
SELECT * FROM prodmag.products

-- 4 --
-- функция (вход - массив numeric, выход - среднее арифметическое)
CREATE OR REPLACE FUNCTION public.f_get_array_average(VARIADIC arr NUMERIC[]) 
RETURNS NUMERIC AS 
$$
 declare
    _sum numeric;
    _count numeric;
    elem numeric;
 begin
 	_sum := 0;
    _count := 0;
   foreach elem in array arr
      loop
	      _sum := _sum + elem;
	      _count := _count + 1;
      end loop;
    return _sum / _count;  
 end;
$$ 
LANGUAGE PLPGSQL;

SELECT public.f_get_array_average(10, -1, 5, 4.4, -2.05);


