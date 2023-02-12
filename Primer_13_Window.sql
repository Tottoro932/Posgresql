/*********************** Пример № 13 Оконные функции  *******************************/

--создадим таблицу
CREATE TABLE public.city_3 
	(
	id SMALLSERIAL NOT NULL,
	name VARCHAR(32) NOT NULL,
	CONSTRAINT city_3_pkey PRIMARY KEY(id)
	);

--скопируем города из таблиц city_1 и city_2
INSERT INTO public.city_3(name)
SELECT name FROM public.city_1;

INSERT INTO public.city_3(name)
SELECT name FROM public.city_2;

--создадим нумерацию по имени города
SELECT
	ROW_NUMBER() OVER(PARTITION BY name ORDER BY id ASC) AS rn,
	name
FROM public.city_3
ORDER BY name;

--теперь используя данную нумерацию удалим дубликаты городов из таблицы city_3
DELETE FROM public.city_3 AS t
USING 
	(
	SELECT
		id AS id_to_del,
		ROW_NUMBER() OVER(PARTITION BY name ORDER BY id ASC) AS rn
	FROM public.city_3
	) AS s
WHERE t.id = s.id AND s.rn > 1;

--посмотрим, что получилось
SELECT * FROM public.city_3
ORDER BY name;

--пример из реальной жизни: подсчет накопленной суточной массы по тегу расхода на установке МНПЗ

SELECT --считаем набегающий итог
	sel_2.hour_num,
	COALESCE(SUM(sel_2.hour_avg_val) OVER (ORDER BY sel_2.hour_num ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS accumulated_hour_mass
FROM
	(
    SELECT --считаем средне-часовые значения, сгруппировав номеру часа
        sel_1."hour" + 1 AS hour_num,
        AVG(sel_1."value") AS hour_avg_val
    FROM
        (
        SELECT --начитываем значения по тегу
          tv.date_value,
          date_part('hour', tv.date_value)::integer AS "hour",
          tv."value"
        FROM result.technological_values AS tv
        WHERE tv.id_tag = 190
            AND tv.date_value BETWEEN '2022-10-01 00:00:00 +03:00' AND '2022-10-01 23:59:00 +03:00'
        ) AS sel_1
    GROUP BY sel_1."hour"
    ORDER BY sel_1."hour" ASC
    ) AS sel_2;