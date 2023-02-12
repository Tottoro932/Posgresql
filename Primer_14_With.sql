/*********************** Пример № 14 Табличные выражения  *******************************/

--Посмотрим суммарную стоимость билетов на рейсы, с аэропортов у которых вылетов в сутки более десяти
WITH top_airport AS
	(
    --ищем аэропорты в которых более 10 вылетов в сутки
    SELECT 
      f.departure_airport,
      f.scheduled_departure::date AS departure_date,
      count(*) AS flights_count
    FROM bookings.flights AS f
    JOIN bookings.airports_data AS a
        ON a.airport_code = f.departure_airport
    GROUP BY f.departure_airport, f.scheduled_departure::date
    HAVING count(*) > 10
    ),
total_amount AS
    (
    --суммируем стоимость билетов по рейсу
    SELECT 
      tf.flight_id,
      SUM(tf.amount) AS sum_amount
    FROM bookings.ticket_flights AS tf 
    GROUP BY tf.flight_id
    )
SELECT
	fl.flight_no,
    ad.city->>'ru' AS departure_city,
    fl.departure_airport,
    fl.scheduled_departure,
    aa.city->>'ru' AS arrival_city,
    fl.arrival_airport,
    fl.scheduled_arrival,
    ta.sum_amount  --тут использовали сумму билетов
FROM bookings.flights AS fl
JOIN total_amount AS ta
	ON ta.flight_id = fl.flight_id
JOIN bookings.airports_data AS ad
	ON ad.airport_code = fl.departure_airport
JOIN bookings.airports_data AS aa
	ON aa.airport_code = fl.arrival_airport
WHERE fl.departure_airport IN (SELECT DISTINCT ap.departure_airport FROM top_airport AS ap) --тут использовали список топовых аэропортов
ORDER BY ta.sum_amount DESC;

/*
Теперь поупражняемся с примером из прошлого урока.
Тут мы считали накопленную суточную массу по одному тегу.
Я немного усложнил запрос - теперь он считает массу по всем тегам у которых единица измерения "т/ч"
Вот что получилось без WITH
*/

SELECT
	sel_2.tag_name,
    sel_2.hour_num,
	COALESCE(SUM(sel_2.hour_avg_val) OVER (PARTITION BY sel_2.tag_name ORDER BY sel_2.hour_num ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS 
	accumulated_hour_mass --обратите внимание: в рамочной функции добавилось PARTITION BY sel_2.tag_name, это группировка внутри окна по имени тега
FROM
	(
    SELECT
        sel_1.pi_tag AS tag_name,
        sel_1."hour" + 1 AS hour_num,
        AVG(sel_1."value") AS hour_avg_val
    FROM
        (
        SELECT 
          t.pi_tag,
          tv.date_value,
          date_part('hour', tv.date_value)::integer AS "hour",
          tv."value"
        FROM dictionary.technological AS t
        JOIN dictionary.units AS u
        	ON u.id = t.unit_id
        JOIN result.technological_values AS tv
        	ON tv.id_tag = t.id
        WHERE u.name = 'т/ч'
            AND tv.date_value BETWEEN '2022-10-01 00:00:00 +03:00' AND '2022-10-01 23:59:00 +03:00'
        ) AS sel_1
    GROUP BY sel_1.pi_tag, sel_1."hour"
    ORDER BY sel_1.pi_tag, sel_1."hour" ASC
    ) AS sel_2;
 
--так этот запрос выглядит с использованием WITH 
WITH tag_values AS --начитываем значения по тегам
	(
    SELECT 
      t.pi_tag,
      tv.date_value,
      date_part('hour', tv.date_value)::integer AS "hour",
      tv."value"
    FROM dictionary.technological AS t
    JOIN dictionary.units AS u
        ON u.id = t.unit_id
    JOIN result.technological_values AS tv
        ON tv.id_tag = t.id
    WHERE u.name = 'т/ч'
        AND tv.date_value BETWEEN '2022-10-01 00:00:00 +03:00' AND '2022-10-01 23:59:00 +03:00'
    ),
avg_values AS --считаем средне-часовые значения, сгруппировав по имени тега и номеру часа
	(
    SELECT 
        v.pi_tag AS tag_name,
        v."hour" + 1 AS hour_num,
        AVG(v."value") AS hour_avg_val
    FROM tag_values AS v
    GROUP BY v.pi_tag, v."hour"
    ORDER BY v.pi_tag, v."hour" ASC
    )
SELECT --считаем набегающий итог
	av.tag_name,
    av.hour_num,
	COALESCE(SUM(av.hour_avg_val) OVER (PARTITION BY av.tag_name ORDER BY av.hour_num ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS accumulated_hour_mass
FROM avg_values AS av;


/*
Рекурсивные CTE
В рекурсивной CTE обязательно должна быть стартовая часть и рекурсивная часть, разделенные UNION.
*/

--Простейший пример: вывести цифры от 1 до 20
WITH RECURSIVE numbers AS
	(
	SELECT 1 AS n --стартовая часть
	
    UNION
		
	SELECT n + 1 --рекурсивная часть
	FROM numbers 
	WHERE n < 20 --не забываем ставить условие выхода из рекурсии!!!!
	)
SELECT * FROM numbers;

--Посчитаем факториал чисел от 1 до 20
WITH RECURSIVE res AS 
	(
    SELECT 
        1 AS i, 
        1 AS factorial
    
    UNION 
    
    SELECT 
        i + 1 AS i, 
        factorial * (i + 1) AS factorial 
    FROM res
    WHERE i < 12 --больше не ставим т.к. выйдем за рамки типа INTEGER
	)
SELECT * FROM res;	

--пример из рабочей БД МНПЗ. Читаем древовидную структуру объектов производства
WITH RECURSIVE cte AS
    (
    SELECT --корневые объекты
        ps."level" - 1 AS "Level",
        ps.id AS "ObjectID",
        ps."level" AS "ObjectTypeID",
        ps.parent_id AS "ParentID",
        ps."name" AS "ObjectName",
        ps.cell->>'description' AS "ObjectDescription",
        '&' || ps."name" || '&' AS "WayByName"
    FROM web_api.uom AS ps
    WHERE component = 'oldPlantStructure'
        AND ps.parent_id IS NULL

    UNION

    SELECT --дочерние объекты
        cte."Level" + 1 AS "Level",
        psp.id AS "ObjectID",
        psp."level" AS "ObjectTypeID",
        psp.parent_id AS "ParentID",
        psp."name" AS "ObjectName",
        psp.cell->>'description' AS "ObjectDescription",
        cte."WayByName" || psp.name || '&' AS "WayByName"
    FROM web_api.uom AS psp
    JOIN cte 
        ON cte."ObjectID" = psp.parent_id
    WHERE component = 'oldPlantStructure'
    )
SELECT
    cte."Level", 
    dt."name" AS object_type,
    cte."ObjectDescription",
    cte."WayByName"
FROM cte
JOIN dictionary.plant_structure_types AS dt
    ON dt.id = cte."ObjectTypeID"::integer
ORDER BY cte."ObjectTypeID", cte."ParentID", cte."ObjectName";

--пример построения посуточного отчета
--создадим табличку
CREATE TABLE public.sales 
	(
    day date, 
    sum numeric
    );
	
 --заполним произвольными суммами, причем поступления сумм не каждый день   
INSERT INTO public.sales VALUES 
	('2023-01-01', 2000),
    ('2023-01-02', 2200),
    ('2023-01-02', 1030),
    ('2023-01-05', 6600),
    ('2023-01-06', 1100),
    ('2023-01-06', 2500),
    ('2023-01-08', 9900),
    ('2023-01-11', 2250),
    ('2023-01-12', 3400),
    ('2023-01-14', 4200),
    ('2023-01-16', 5700),
    ('2023-01-18', 1700),
    ('2023-01-18', 2900),
    ('2023-01-20', 7100),
    ('2023-01-21', 1000),
    ('2023-01-21', 8060),
    ('2023-01-22', 5020),
    ('2023-01-23', 3030),
    ('2023-01-23', 1100),
    ('2023-01-23', 4100);
	
--смотрим, что получилось
SELECT * FROM public.sales;

--делаем рекурсию, которая создаст список дат от начала месяца до текущей даты и считаем сумму денег по каждому дню, где нет поступлений, ставим ноль
WITH RECURSIVE date_list AS 
	(
    SELECT date_trunc('month',CURRENT_DATE) AS d
       
    UNION
     
    SELECT d + INTERVAL '1 day' FROM date_list
    WHERE d < CURRENT_DATE
	) 
SELECT 
	date_list.d::DATE, 
    COALESCE(SUM(s.sum), 0) AS total_day_sum 
FROM date_list
LEFT JOIN sales AS s
	ON s.day = date_list.d
GROUP BY date_list.d;