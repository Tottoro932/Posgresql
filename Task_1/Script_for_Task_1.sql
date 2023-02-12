-- создание схемы
CREATE SCHEMA tag_data; 

--создадим таблицу для типов измеряемых параметров
CREATE TABLE tag_data.take_param 
	(
	take_param_id SMALLSERIAL NOT NULL,
	take_param_type VARCHAR(20) NOT NULL,
	CONSTRAINT take_param_ukey UNIQUE(take_param_type),  -- уникальность для типа измерения
	CONSTRAINT take_param_pkey PRIMARY KEY(take_param_id) -- уникальность для id
	);

--создадим таблицу для единиц измерения
CREATE TABLE tag_data.units 
	(
	unit_id SMALLSERIAL NOT NULL,
	unit_type VARCHAR(10) NOT NULL,
	CONSTRAINT unit_ukey UNIQUE(unit_type),   -- уникальность для типа измерения
	CONSTRAINT unit_pkey PRIMARY KEY(unit_id) -- уникальность для id
	);

--создадим таблицу для имени + описания тега
CREATE TABLE tag_data.tag 
	(
	tag_id SMALLSERIAL NOT NULL,
	tag_name VARCHAR(30) NOT NULL,
	tag_descript VARCHAR(70) NOT NULL,
	CONSTRAINT tag_name_ukey UNIQUE(tag_name),           -- уникальность для типа измерения
	CONSTRAINT tag_descript_ukey UNIQUE(tag_descript),   -- уникальность для типа измерения
	CONSTRAINT tag_pkey PRIMARY KEY(tag_id)              -- уникальность для id
	);

--создадим таблицу для установок
CREATE TABLE tag_data.plant
	(
	plant_id SMALLSERIAL NOT NULL,
	plant_type VARCHAR(15) NOT NULL,
	CONSTRAINT plant_ukey UNIQUE(plant_type),   -- уникальность для типа измерения
	CONSTRAINT plant_pkey PRIMARY KEY(plant_id) -- уникальность для id
	);

-- создадим таблицу дата/время + значение тега
-- таблица ссылается на 4 предыдущих по полю take_param_id, unit_id, tag_id и plant_id
CREATE TABLE tag_data.tag_tv 
	(
	tag_tv_id SERIAL NOT NULL,
	tag_tv_time TIMESTAMP NOT NULL,
	tag_tv_value NUMERIC(15) NOT NULL,
	
	take_param_id SMALLINT NOT NULL,
	unit_id SMALLINT NOT NULL,
	tag_id SMALLINT NOT NULL,
	plant_id SMALLINT NOT NULL,
	
	CONSTRAINT tag_tv_id_pkey PRIMARY KEY(tag_tv_id),
	CONSTRAINT take_param_id_fk FOREIGN KEY (take_param_id)
		REFERENCES tag_data.take_param(take_param_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT unit_id_fk FOREIGN KEY (unit_id)
		REFERENCES tag_data.units(unit_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT tag_id_fk FOREIGN KEY (tag_id)
		REFERENCES tag_data.tag(tag_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT plant_id_fk FOREIGN KEY (plant_id)
		REFERENCES tag_data.plant(plant_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT tag_tv_value_chk CHECK (tag_tv_value > 0)
	);

