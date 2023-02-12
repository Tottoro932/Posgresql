----------------------------------2----------------------------------------------------------
-- создаем временную таблицу со структурой, аналогичной структуре файла с данными
CREATE TABLE tag_data.tem 
	(
	tem_id SERIAL NOT NULL,
	tem_plant VARCHAR(15) NOT NULL,
	tem_name VARCHAR(30) NOT NULL,
	tem_descript VARCHAR(70) NOT NULL,
	tem_param VARCHAR(20) NOT NULL,
	tem_units VARCHAR(10) NOT NULL,
	tem_date TIMESTAMP NOT NULL,
	tem_value REAL NOT NULL,
	
	CONSTRAINT tem_id_pkey PRIMARY KEY(tem_id) -- уникальность для id
	);

-- заполняем временную таблицу данными из файла
COPY tag_data.tem
	(
	tem_plant,
	tem_name,
	tem_descript,
	tem_param,
	tem_units,
	tem_date,
	tem_value
	)
FROM 'C://DataImportExport//tag_data.csv' WITH (FORMAT CSV, DELIMITER ';', ENCODING 'UTF8', HEADER);

-- проверяем заполненную таблицу
SELECT * FROM tag_data.tem;

-- заполняем таблицы-словари (plant, take_param,units)
INSERT INTO tag_data.plant (plant_type)
SELECT DISTINCT 
	tem_plant FROM tag_data.tem;

INSERT INTO tag_data.take_param (take_param_type)
SELECT DISTINCT 
	tem_param FROM tag_data.tem;

INSERT INTO tag_data.units (unit_type)
SELECT DISTINCT 
	tem_units FROM tag_data.tem;

-- заполняем таблицу tag
INSERT INTO tag_data.tag (tag_name,tag_descript,take_param_id, unit_id,plant_id)
SELECT DISTINCT 
	t.tem_name,
	t.tem_descript,
	pr.take_param_id,
	u.unit_id, 
	pl.plant_id
	FROM tag_data.tem AS t, tag_data.plant AS pl, tag_data.take_param AS pr,tag_data.units AS u 
    WHERE t.tem_param = pr.take_param_type AND 
    t.tem_units = u.unit_type AND
    t.tem_plant = pl.plant_type ;
    
-- заполняем таблицу tag_dv
INSERT INTO tag_data.tag_dv (tag_dv_date, tag_dv_value,tag_id)
SELECT
	tm.tem_date,
	tm.tem_value,
	tg.tag_id 
	FROM tag_data.tem AS tm, tag_data.tag AS tg
    WHERE  tm.tem_descript = tg.tag_descript;
   
    
-- удаление временной таблицы tem
--DROP TABLE tag_data.tem;
   
-- вывод всех данных вместе
SELECT p.plant_type AS "Установка", tg.tag_name  AS "Имя тега", 
tg.tag_descript AS "Описание тега",tp.take_param_type AS "Измеряемый параметр",
u.unit_type AS "Ед.Изм.",td.tag_dv_date AS "Дата/время",td.tag_dv_value AS "Значение" 
FROM tag_data.tag_dv AS td 
JOIN tag_data.tag AS tg 
    ON td.tag_id = tg.tag_id 
JOIN tag_data.plant AS p 
    ON tg.plant_id = p.plant_id 
JOIN tag_data.units AS u 
    ON tg.unit_id = u.unit_id 
JOIN tag_data.take_param AS tp 
    ON tg.take_param_id  = tp.take_param_id  