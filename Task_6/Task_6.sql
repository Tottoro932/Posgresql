------- Task_6 -------------------------
-- 1 --
-- создаем таблицу
CREATE TABLE prodmag.products_log 
	(
	product_id SERIAL NOT NULL,
	products_name VARCHAR(24) NOT NULL,
	food_type_id SMALLINT NOT NULL,
	unit_id SMALLINT NOT NULL,
	qty INTEGER NOT NULL DEFAULT 0,
	price NUMERIC(6,2) NOT NULL,
	cost NUMERIC(10,2) NOT null, 
	seller_id INTEGER NOT NULL,
	deadline SMALLINT NOT null,
	add_date TIMESTAMP not null,
	operation VARCHAR(6) NOT NULL,
	_row VARCHAR(3) NOT null
	);

--drop table prodmag.products_log 

--создадим триггерную функцию, добавляющую записи в таблицу products_log
CREATE OR REPLACE FUNCTION public.fun_trg() RETURNS TRIGGER AS
$$
DECLARE

BEGIN
	IF TG_LEVEL = 'ROW' --TG_LEVEL уровень строка или операция
	THEN
		CASE TG_OP --TG_OP имя оператора
		WHEN 'INSERT' THEN 
		    
		    INSERT INTO prodmag.products_log(product_id, products_name, food_type_id, unit_id,
				                             qty, price, cost, seller_id, deadline, add_date, operation, _row)
			values(new.product_id, new.products_name, new.food_type_id, new.unit_id,
			       new.qty, new.price, new.cost, new.seller_id, new.deadline, current_timestamp,'insert','new');
				
		WHEN 'UPDATE' THEN 
		    
		    INSERT INTO prodmag.products_log(product_id, products_name, food_type_id, unit_id,
				                             qty, price, cost, seller_id, deadline, add_date, operation, _row)
			values(old.product_id, old.products_name, old.food_type_id, old.unit_id,
			       old.qty, old.price, old.cost, old.seller_id, old.deadline, current_timestamp,'update','old');
			      
			INSERT INTO prodmag.products_log(product_id, products_name, food_type_id, unit_id,
				                             qty, price, cost, seller_id, deadline, add_date, operation, _row)
			values(new.product_id, new.products_name, new.food_type_id, new.unit_id,
			       new.qty, new.price, new.cost, new.seller_id, new.deadline, current_timestamp,'update','new');
			
		WHEN 'DELETE' THEN 
		    
		    INSERT INTO prodmag.products_log(product_id, products_name, food_type_id, unit_id,
				                             qty, price, cost, seller_id, deadline, add_date, operation, _row)
			values(old.product_id, old.products_name, old.food_type_id, old.unit_id,
			       old.qty, old.price, old.cost, old.seller_id, old.deadline, current_timestamp,'delete','old');
		END CASE;
		
	END IF;

	RETURN null;

END;
$$
LANGUAGE PLPGSQL;


--создаем триггер на уровне оператора AFTER ROW
CREATE TRIGGER trig_after_row
AFTER INSERT OR UPDATE OR DELETE   --события
ON prodmag.products                --таблица
FOR EACH ROW                       --уровень
EXECUTE FUNCTION public.fun_trg(); --функция

-- удаление триггера
--drop TRIGGER trig_after_row on prodmag.products;

-- добавление данных
INSERT INTO prodmag.products(products_name, food_type_id, unit_id, qty, price, seller_id, deadline) 
VALUES('Киви',9 ,2 ,3 ,11.02 ,6 ,20);

--апдейт сущестующей строки
UPDATE prodmag.products SET price  = 109
WHERE products_name = 'Киви';

-- удаление
DELETE FROM prodmag.products WHERE product_id > 37;

-- 2 --

-- триггер не обновление и вставку записей в таблицу (с проверкой правильности)
--drop FUNCTION public.fun_trg_2() cascade 
CREATE OR REPLACE FUNCTION public.fun_trg_2() RETURNS TRIGGER as
$$
BEGIN
	
	IF NEW.food_type_id NOT IN (SELECT food_type_id FROM prodmag.food_types)
	THEN 
		RAISE EXCEPTION 'Неверно указан тип продукта: id = %', NEW.food_type_id
		USING HINT = 'Добавьте новый тип родукта в таблицу food_types.food_type_id или используйте существующие типы', ERRCODE = 23503;
	END IF;

	RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER trig_before_row_prod
BEFORE INSERT OR UPDATE              --события
ON prodmag.products                  --таблица
FOR EACH ROW                         --уровень
EXECUTE FUNCTION public.fun_trg_2(); --функция

-- добавление данных (корректные)
INSERT INTO prodmag.products(products_name, food_type_id, unit_id, qty, price, seller_id, deadline) 
VALUES('Гранат',10 ,2 ,3 ,11.02 ,6 ,20);

-- добавление данных (с ошибкой)
INSERT INTO prodmag.products(products_name, food_type_id, unit_id, qty, price, seller_id, deadline) 
VALUES('Гранат',13 ,2 ,3 ,11.02 ,6 ,20);

-- обновление данных (с ошибкой)
UPDATE prodmag.products SET food_type_id  = -10
WHERE products_name = 'Гранат';
