/*********************** Пример № 20 условные операторы *******************************/

--функция конвертации температуры
CREATE OR REPLACE FUNCTION public.f_convert_temp(_temp REAL, _to_celsius BOOLEAN DEFAULT TRUE) 
RETURNS REAL AS
$$
DECLARE 
	_result REAL;
BEGIN
	
	IF _to_celsius
    THEN 
    	
        _result := ((5.0/9.0) * (_temp - 32.0));	
    
    ELSE
    
    	 _result := ((9.0 * _temp + 32.0 * 5.0) / 5.0);	
    
	END IF;
    
    RETURN _result;
	
END;
$$
LANGUAGE PLPGSQL;


SELECT public.f_convert_temp(25, TRUE);

--пример функции с ELSIF
CREATE OR REPLACE FUNCTION public.f_get_season(_month_num INT) 
RETURNS VARCHAR AS
$$
DECLARE 
	_result VARCHAR;
BEGIN
	
	IF _month_num BETWEEN 3 AND 5 THEN _result := 'Весна';
    ELSIF _month_num BETWEEN 6 AND 8 THEN _result := 'Лето';
	ELSIF _month_num BETWEEN 9 AND 11 THEN _result := 'Осень';
	ELSE _result := 'Зима';
	END IF;
    
    RETURN _result;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT f_get_season(1);

--пример краткой формы CASE
CREATE OR REPLACE FUNCTION public.f_get_season_v2(_month_num INT) 
RETURNS VARCHAR AS
$$
DECLARE 
	_result VARCHAR;
BEGIN
	
    CASE _month_num 
    WHEN 3,4,5 THEN _result := 'Весна';
    WHEN 6,7,8 THEN _result := 'Лето';
	WHEN 9,10,11 THEN _result := 'Осень';
	ELSE _result := 'Зима';
	END CASE;
    
    RETURN _result;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT f_get_season_v2(1);

--пример полной формы CASE
CREATE OR REPLACE FUNCTION public.f_get_season_v3(_month_num INT) 
RETURNS VARCHAR AS
$$
DECLARE 
	_result VARCHAR;
BEGIN

    CASE  
    WHEN _month_num BETWEEN 3 AND 5 THEN _result := 'Весна';
    WHEN _month_num BETWEEN 6 AND 8 THEN _result := 'Лето';
	WHEN _month_num BETWEEN 9 AND 11 THEN _result := 'Осень';
	ELSE _result := 'Зима';
	END CASE;
    
    RETURN _result;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT f_get_season_v3(10);