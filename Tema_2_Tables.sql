/************************** ПРИМЕР №1 продуктовый магазин ****************************/

--создадим схему
CREATE SCHEMA prodmag;

--создадим таблицу для типов продуктов
CREATE TABLE prodmag.food_types 
	(
	food_type_id SMALLSERIAL NOT NULL,
	food_type_name VARCHAR(16) NOT NULL,
	CONSTRAINT food_types_ukey UNIQUE(food_type_name),
	CONSTRAINT food_types_pkey PRIMARY KEY(food_type_id)
	);
	
--создадим таблицу для единиц измерения
CREATE TABLE prodmag.units
	(
	unit_id SMALLSERIAL NOT NULL,
	unit_name VARCHAR(5) NOT NULL,
	CONSTRAINT units_ukey UNIQUE(unit_name),
	CONSTRAINT units_pkey PRIMARY KEY(unit_id)
	);
	
--создадим таблицу для поставщиков
CREATE TABLE prodmag.sellers
	(
	seller_id SERIAL NOT NULL,
	seller_name VARCHAR(32) NOT NULL,
	address VARCHAR(64) NOT NULL,
	inn char(11),
	CONSTRAINT sellers_name_ukey UNIQUE(seller_name),
	CONSTRAINT sellers_inn_ukey UNIQUE(inn),
	CONSTRAINT sellers_pkey PRIMARY KEY(seller_id)
	);

--таблица продуктов ссылается на первую по полю food_type_id, вторую по полю unit_id и третью по полю seller_id
CREATE TABLE prodmag.products 
	(
	product_id SERIAL NOT NULL,
	products_name VARCHAR(24) NOT NULL,
	food_type_id SMALLINT NOT NULL,
	unit_id SMALLINT NOT NULL,
	qty INTEGER NOT NULL DEFAULT 0,
	price NUMERIC(6,2) NOT NULL,
	cost NUMERIC(10,2) NOT NULL GENERATED ALWAYS AS (qty * price) STORED,
	deadline SMALLINT NOT NULL,
	seller_id INTEGER NOT NULL,
	CONSTRAINT product_id_pkey PRIMARY KEY(product_id),
	CONSTRAINT food_type_id_fk FOREIGN KEY (food_type_id)
		REFERENCES prodmag.food_types(food_type_id)
		ON DELETE NO ACTION --RESTRICT, CASCADE, SET NULL(поля), SET DEFAULT(поля)
		ON UPDATE NO ACTION,
	CONSTRAINT price_chk CHECK (price > 0)
	);

--попробуем удалить схему с таблицами
DROP SCHEMA prodmag;

--теперь удалим схему каскадно
DROP SCHEMA prodmag CASCADE;


--******************************************************************
--создадим всю структуру снова

--создадим схему
CREATE SCHEMA prodmag;

--создадим таблицу для типов продуктов
CREATE TABLE prodmag.food_types 
	(
	food_type_id SMALLSERIAL NOT NULL,
	food_type_name VARCHAR(16) NOT NULL,
	CONSTRAINT food_types_ukey UNIQUE(food_type_name),
	CONSTRAINT food_types_pkey PRIMARY KEY(food_type_id)
	);
	
--создадим таблицу для единиц измерения
CREATE TABLE prodmag.units
	(
	unit_id SMALLSERIAL NOT NULL,
	unit_name VARCHAR(5) NOT NULL,
	CONSTRAINT units_ukey UNIQUE(unit_name),
	CONSTRAINT units_pkey PRIMARY KEY(unit_id)
	);
	
--создадим таблицу для поставщиков
CREATE TABLE prodmag.sellers
	(
	seller_id SERIAL NOT NULL,
	seller_name VARCHAR(32) NOT NULL,
	address VARCHAR(48) NOT NULL,
	inn char(11),
	CONSTRAINT sellers_name_ukey UNIQUE(seller_name),
	CONSTRAINT sellers_inn_ukey UNIQUE(inn),
	CONSTRAINT sellers_pkey PRIMARY KEY(seller_id)
	);

--таблица продуктов ссылается на первую по полю food_type_id, вторую по полю unit_id и третью по полю seller_id
CREATE TABLE prodmag.products 
	(
	product_id SERIAL NOT NULL,
	products_name VARCHAR(24) NOT NULL,
	food_type_id SMALLINT NOT NULL,
	unit_id SMALLINT NOT NULL,
	qty INTEGER NOT NULL DEFAULT 0,
	price NUMERIC(6,2) NOT NULL,
	cost NUMERIC(10,2) NOT NULL GENERATED ALWAYS AS (qty * price) STORED, --калькулируемое поле
	--deadline SMALLINT NOT NULL, специально пропустил (типа ошибка)
	seller_id INTEGER NOT NULL,
	CONSTRAINT product_id_pkey PRIMARY KEY(product_id),
	CONSTRAINT food_type_id_fk FOREIGN KEY (food_type_id)
		REFERENCES prodmag.food_types(food_type_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT price_chk CHECK (price > 0)
	);
	
--УПС!!! мы забыли добавить поле для колонки "Срок реализации (сутки)", создадим его 
ALTER TABLE prodmag.products ADD COLUMN deadline SMALLINT NOT NULL;

--УПС!!! в поле "Адрес постовщика" есть строки длиннее 48 символов, давайте пименяем тип поля на VARCHAR(100)
ALTER TABLE prodmag.sellers ALTER COLUMN address TYPE VARCHAR(100);

--УПС!!! мы забыли добавить внешние ключи на колонки "unit_id" и "seller_id", создадим их
ALTER TABLE prodmag.products
  ADD CONSTRAINT products_unit_id_fk FOREIGN KEY (unit_id)
    REFERENCES prodmag.units(unit_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
	
ALTER TABLE prodmag.products
  ADD CONSTRAINT products_seller_id_fk FOREIGN KEY (seller_id)
    REFERENCES prodmag.sellers(seller_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;