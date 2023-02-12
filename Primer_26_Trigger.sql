/*********************** Пример № 26 Trigger *******************************/

--создадим триггерную функцию
CREATE OR REPLACE FUNCTION public.trg() RETURNS TRIGGER AS
$$
DECLARE
	rec RECORD;
	str TEXT := '';
BEGIN
	
	IF TG_LEVEL = 'ROW' --TG_LEVEL уровень строка или операция
	THEN
	
		CASE TG_OP --TG_OP имя оператора
		WHEN 'INSERT' THEN 
			rec := NEW;
			str := NEW::TEXT;
		WHEN 'UPDATE' THEN 
			rec := NEW;
			str := OLD || ' -> ' || NEW;
		WHEN 'DELETE' THEN 
			rec := OLD;
			str := OLD::TEXT;
		END CASE;
		
	END IF;
		
	RAISE NOTICE '% % % %: %', 
		TG_TABLE_NAME, --имя таблицы, на которой сработал триггер
		TG_WHEN, --условие фильтра
		TG_OP, --имя оператора
		TG_LEVEL, --уровень строка или операция
		str;
		
	RETURN rec;

END;
$$
LANGUAGE PLPGSQL;

--создадим тестовую таблицу
CREATE TABLE public.trg_test
	(
	id SERIAL PRIMARY KEY,
	txt TEXT
	);
	
--создаем триггер на уровне оператора BEFORE STATEMENT
CREATE TRIGGER tr_before_stmt
BEFORE INSERT OR UPDATE OR DELETE --события
ON trg_test                       --таблица
FOR EACH STATEMENT                --уровень
EXECUTE FUNCTION public.trg();    --функция

--создаем триггер на уровне оператора BEFORE ROW
CREATE TRIGGER tr_before_row
BEFORE INSERT OR UPDATE OR DELETE --события
ON trg_test                       --таблица
FOR EACH ROW                      --уровень
EXECUTE FUNCTION public.trg();    --функция

--создаем триггер на уровне оператора AFTER ROW
CREATE TRIGGER tr_after_row
AFTER INSERT OR UPDATE OR DELETE  --события
ON trg_test                       --таблица
FOR EACH ROW                      --уровень
EXECUTE FUNCTION public.trg();    --функция

--создаем триггер на уровне оператора AFTER STATEMENT
CREATE TRIGGER tr_after_stmt
AFTER INSERT OR UPDATE OR DELETE  --события
ON trg_test                       --таблица
FOR EACH STATEMENT                --уровень
EXECUTE FUNCTION public.trg();    --функция

--вставка
INSERT INTO public.trg_test(txt) VALUES('aaa'),('bbb'),('ccc');

--апдейт сущестующей строки
UPDATE public.trg_test SET txt = 'aaa-uuu' WHERE id = 1;

--апдейт несуществующей
UPDATE public.trg_test SET txt = 'fff' WHERE id = 10;

--INSERT с ON CONFLICT(id) DO UPDATE
INSERT INTO public.trg_test 
VALUES(1,'aaad'),(2,'bbbq'),(5,'fff')
ON CONFLICT(id) DO UPDATE
SET txt = EXCLUDED.txt;

--удаление
DELETE FROM public.trg_test WHERE id < 3;



--создадим триггерную функцию для работы с переходными таблицами
CREATE OR REPLACE FUNCTION public.tbl_trg() RETURNS TRIGGER AS
$$
DECLARE
	rec RECORD;
	str TEXT := '';
BEGIN
	
	IF TG_OP = 'UPDATE' OR TG_OP = 'DELETE'
	THEN
	
		RAISE NOTICE 'Старое состояние';
		FOR rec IN SELECT * FROM old_table 
		LOOP
		
			RAISE NOTICE '%', rec;
		
		END LOOP;
		
	END IF;
	
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE'
	THEN
	
		RAISE NOTICE 'Новое состояние';
		FOR rec IN SELECT * FROM new_table 
		LOOP
		
			RAISE NOTICE '%', rec;
		
		END LOOP;
		
	END IF;
		
	RETURN NULL;

END;
$$
LANGUAGE PLPGSQL;


--создаем тестовую таблицу
CREATE TABLE public.tbl_trg_test
	(
	id INT PRIMARY KEY,
	txt TEXT
	);
	
--тут мы для каждого события должны создать отдельный триггер	
CREATE TRIGGER tr_after_insert_stmt
AFTER INSERT ON tbl_trg_test 
REFERENCING --прикрепляем ссылку на переходную таблицу
	NEW TABLE AS new_table --для insert только NEW
FOR EACH STATEMENT 
EXECUTE FUNCTION public.tbl_trg(); 

CREATE TRIGGER tr_after_update_stmt
AFTER UPDATE ON tbl_trg_test 
REFERENCING
	OLD TABLE AS old_table --для update обе
	NEW TABLE AS new_table
FOR EACH STATEMENT 
EXECUTE FUNCTION public.tbl_trg(); 

CREATE TRIGGER tr_after_delete_stmt
AFTER DELETE ON tbl_trg_test 
REFERENCING
	OLD TABLE AS old_table --для delete только OLD
FOR EACH STATEMENT 
EXECUTE FUNCTION public.tbl_trg(); 

--делаем вставку    
INSERT INTO public.tbl_trg_test VALUES(1,'qwerty'),(2,'uiop'),(3,'asdfg'),(4,'hjkl'),(5,'zxcvb');

--делаем обновление	
UPDATE public.tbl_trg_test
SET 
	id = id + 10,
    txt = UPPER(txt)
WHERE id < 5;

--удаляем записи
DELETE FROM public.tbl_trg_test
WHERE id > 12;
