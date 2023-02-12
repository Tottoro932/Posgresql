/*********************** Пример № 22 курсор *******************************/

--создадим функцию, возвращающую рейсы с опозданиями по вылету и (или) прибытию, а так же с величиной опоздания
CREATE OR REPLACE FUNCTION public.f_get_late_flights()
RETURNS TABLE
	(
	flight_no CHAR(6),
	departure_late INTERVAL,
	arrival_late INTERVAL
	)
AS
$$
DECLARE 
	fl_cursor REFCURSOR; --декларируем переменную типа CURSOR, в которую будут помещаться текущие строки в цикле
	cur_flight_no CHAR(6); --декларирую переменные, в которые будут записываться значения из строки текущей итерации
	cur_scheduled_departure TIMESTAMPTZ;
	cur_scheduled_arrival TIMESTAMPTZ;
	cur_actual_departure TIMESTAMPTZ;
	cur_actual_arrival TIMESTAMPTZ;
BEGIN
        
    CREATE TEMPORARY TABLE late_flights_tmp
		(
		flight_no CHAR(6),
		departure_late INTERVAL,
		arrival_late INTERVAL
		)
	ON COMMIT DROP;
	
	OPEN fl_cursor --открываем курсор для запроса
    FOR SELECT  
		f.flight_no,
		f.scheduled_departure,
		f.scheduled_arrival,
		f.actual_departure,
		f.actual_arrival
    FROM bookings.flights AS f;
    
    LOOP --перебираем строки результата запроса в цикле
	FETCH NEXT FROM fl_cursor INTO cur_flight_no, cur_scheduled_departure, cur_scheduled_arrival, cur_actual_departure, cur_actual_arrival;
	
	EXIT WHEN NOT FOUND; --выходим из цикла, если строк больше нет
	
		--выполняем проверку задержки вылета и прилета со значениями курсора в цикле
		IF(cur_actual_departure > cur_scheduled_departure) OR (cur_actual_arrival > cur_scheduled_arrival)
        THEN
         
        	--если есть опоздание, пишем во временную таблицу
			INSERT INTO late_flights_tmp VALUES
				(
				cur_flight_no, 
				(cur_actual_departure - cur_scheduled_departure),
				(cur_actual_arrival - cur_scheduled_arrival)
				);
            
        END IF;
	
    END LOOP;
	
	CLOSE fl_cursor; --закрываем курсор
    
    RETURN QUERY --возвращаем знгачения из временной таблицы
    SELECT * FROM late_flights_tmp;
    
END;
$$
LANGUAGE PLPGSQL;

--смотрим результат
SELECT * FROM public.f_get_late_flights();