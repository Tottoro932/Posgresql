/*********************** Пример № 24 EXCEPTION *******************************/

--добавим вызов исключения в функцию вывода времени года по номеру месяца
CREATE OR REPLACE FUNCTION public.f_get_seasone(_month_num INT)
RETURNS VARCHAR AS
$$
DECLARE 
	res VARCHAR;
BEGIN

	IF _month_num NOT BETWEEN 1 AND 12
	THEN 
		RAISE EXCEPTION 'Неверный номер месяца: %',_month_num
		USING HINT = 'Номер месяца должен быть от 1 до 12', ERRCODE = 12882;
	END IF;
	
	CASE 
		WHEN _month_num BETWEEN 3 AND 5 THEN res := 'Весна';
		WHEN _month_num BETWEEN 6 AND 8 THEN res := 'Лето';
		WHEN _month_num BETWEEN 9 AND 11 THEN res := 'Осень';
		ELSE res := 'Зима';
	END CASE;
	
	RETURN res;
	
END;
$$
LANGUAGE PLPGSQL;

--тестируем
SELECT public.f_get_seasone(18);

--теперь попробуем поймать исключение при делении на ноль
CREATE OR REPLACE FUNCTION public.f_get_divesion(divisible_num FLOAT, divider_num FLOAT)
RETURNS FLOAT AS
$$
DECLARE
	err_msg TEXT;
	err_code TEXT;
	err_context TEXT;
	err_details TEXT;
BEGIN

	RETURN divisible_num / divider_num;
	
	EXCEPTION
	
    	WHEN division_by_zero THEN --отлавливаем деление на 0 и выводим предупреждение и значение NULL в качестве результата
		
            GET STACKED DIAGNOSTICS
            err_msg     = MESSAGE_TEXT,
            err_code    = RETURNED_SQLSTATE,
            err_context = PG_EXCEPTION_CONTEXT,
            err_details = PG_EXCEPTION_DETAIL;
            RAISE WARNING 'ERROR [%', err_code || '] - ' || err_msg || '; ' || err_context || '; ' || err_details;
            RETURN NULL::FLOAT;
			
        WHEN OTHERS THEN --в случае остальных ошибок генерим исключение, значение NULL уже не возвращаем т.к. идет откат транзакции
			
			--можно добавить логирование ошибок, если не вызывать EXCEPTION
			--INSERT INTO logger.error_log (code, message) VALUES (SQLSTATE, SQLERRM);
		
			RAISE EXCEPTION 'ERROR [%', SQLSTATE || '] - ' || SQLERRM;
	
END;
$$
LANGUAGE PLPGSQL;

--тестируем
SELECT public.f_get_divesion(18.7, 0);