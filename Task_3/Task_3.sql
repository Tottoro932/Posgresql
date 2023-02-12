   
 ---------------------------- 3 -----------------------------
    -- 1 --
CREATE OR REPLACE VIEW my_viev as 
(
SELECT f.flight_no as "ном.рейса", f.scheduled_departure as "время вылета",f.departure_airport as "код аэр.вылета",
ap.city as "г.вылета", ap.airport_name as "аэр.вылета",
f.scheduled_arrival as "время прилета", f.arrival_airport as "код аэр.прилета",
ap1.city as "г.прилета", ap1.airport_name as "аэр.прилета", ac.model as "модель"
from bookings.flights as f
join bookings.airports_data as ap
   on ap.airport_code = f.departure_airport
join bookings.airports_data as ap1
   on ap1.airport_code = f.arrival_airport  
join bookings.aircrafts_data as ac
   on ac.aircraft_code = f.aircraft_code  
where (cast (ap.city as text) like '%Москва%' or
   cast (ap.city as text) like '%Санкт-Петербург%') and 
   date_part('hour',f.scheduled_departure) < 12
)
   
SELECT * FROM my_viev;

 -- 2 --

CREATE OR REPLACE VIEW my_viev_2 as 
(
SELECT tg.tag_name  AS "Имя тега", u.unit_type AS "Ед.Изм.",
td.tag_dv_date AS "Дата/время",td.tag_dv_value AS "Значение" 
FROM tag_data.tag_dv AS td 
JOIN tag_data.tag AS tg 
    ON td.tag_id = tg.tag_id 
JOIN tag_data.units AS u 
    ON tg.unit_id = u.unit_id 
JOIN tag_data.take_param AS tp 
    ON tg.take_param_id  = tp.take_param_id
)

with a as (
SELECT * FROM my_viev_2
where cast("Имя тега" as text) like '%92%'
ORDER BY "Имя тега" DESC LIMIT 10 ),  

 b as (
SELECT * FROM my_viev_2
where cast("Имя тега" as text) like '%FCA3%'
ORDER BY "Имя тега" DESC LIMIT 10 ),

 c as (
SELECT * FROM my_viev_2
where cast("Имя тега" as text) like '%159%'
ORDER BY "Имя тега" DESC LIMIT 10 )

SELECT * from a UNION SELECT * from b UNION SELECT * from c 

  -- 3 --
--создадим две тестовые таблички и заполним их данными
CREATE TABLE public.prog_1 
	(
	id SMALLSERIAL NOT NULL,
	name VARCHAR(16) NOT NULL,
	CONSTRAINT prog_1_name_ukey UNIQUE(name),
	CONSTRAINT prog_1_pkey PRIMARY KEY(id)
	);
	
CREATE TABLE public.prog_2 
	(
	id SMALLSERIAL NOT NULL,
	name VARCHAR(16) NOT NULL,
	CONSTRAINT prog_2_name_ukey UNIQUE(name),
	CONSTRAINT prog_2_pkey PRIMARY KEY(id)
	);
	
INSERT INTO public.prog_1 (name) VALUES ('Python'),('C'),('PHP'),('C++'),('Kotlin'),('JavaScript'),('Fortran');
INSERT INTO public.prog_2 (name) VALUES ('C#'),('Java'),('C++'),('Go'),('Fortran'),('Python'),('Ruby');

-- все языки, присутствующие в таблицах
SELECT s.name FROM
	(
	SELECT t1.name FROM public.prog_1 AS t1
	UNION --ALL
	SELECT t2.name FROM public.prog_2 AS t2
	) AS s
ORDER BY s.name;

-- общие языки в таблицах
SELECT s.name FROM
	(
	SELECT t1.name FROM public.prog_1 AS t1
	INTERSECT
	SELECT t2.name FROM public.prog_2 AS t2
	) AS s
ORDER BY s.name;

-- уникальные языки таблицы prog_1
SELECT s.name FROM
	(
	SELECT t1.name FROM public.prog_1 AS t1
	EXCEPT
	SELECT t2.name FROM public.prog_2 AS t2
	) AS s
ORDER BY s.name;

-- уникальные языки таблицы prog_2
SELECT s.name FROM
	(
	SELECT t2.name FROM public.prog_2 AS t2
	EXCEPT
	SELECT t1.name FROM public.prog_1 AS t1
	) AS s
ORDER BY s.name;