/*********************** Пример № 25 DO *******************************/

--создадим таблицу, позднее мы её будем использовать для тестирования индексов
CREATE TABLE public.index_test
	(
    id INTEGER,
    first_arg VARCHAR(64),
    second_arg VARCHAR(64)
    );
    

--с помощью анонимной функции заполним таблицу рандомными текстовыми значениями (~1мин. 30сек.)
DO $$
DECLARE 
    cnt INT;
BEGIN

    FOR cnt IN 1 .. 5000000
    LOOP
    	
        INSERT INTO public.index_test VALUES
			(
			cnt, 
			UPPER(GEN_RANDOM_UUID()::VARCHAR), 
			UPPER(MD5(RANDOM()::VARCHAR))
			);
    	
    END LOOP;
    
END$$;