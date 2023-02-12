-- Task 4 
-- количество сотрудников в косвенном подчинении
WITH RECURSIVE go_up(id, parent_id) as (
  select id, parent_id, fio, post
  from public.staff AS p
  union all
  select p.id, p.parent_id,p.fio,p.post
  from go_up join public.staff AS p on p.id=go_up.parent_id
  )
select id, parent_id,fio,post, count(*)-1 from go_up
group by id,parent_id,fio,post
order by id

-- количество сотрудников в прямом водчинении
WITH RECURSIVE go_up_1(id, parent_id) as (
  select id, parent_id, fio, post, 0 as lvl
  from public.staff AS p
  union all
  select p.id, p.parent_id,p.fio,p.post,lvl+1 as lvl
  from go_up_1 join public.staff AS p on p.id=go_up_1.parent_id
  )
select id, parent_id,fio,post, count(*)FILTER(where lvl = 1) from go_up_1
group by id,parent_id,fio,post
order by id

-- Task_5
-- 1 --
-- case --
CREATE OR REPLACE FUNCTION public.f_get_number_case(_month_num INT) 
RETURNS INT AS
$$
DECLARE 
	_result INT;
BEGIN

    CASE  
    WHEN _month_num BETWEEN 1 AND 3 THEN _result := 1;
    WHEN _month_num BETWEEN 4 AND 6 THEN _result := 2;
	WHEN _month_num BETWEEN 7 AND 9 THEN _result := 3;
    WHEN _month_num BETWEEN 10 AND 12 THEN _result := 4;
	ELSE _result := 0;
	END CASE;
    
    RETURN _result;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT f_get_number_case(2);

-- if --
CREATE OR REPLACE FUNCTION public.f_get_number_if(_month_num INT) 
RETURNS INT AS
$$
DECLARE 
	_result INT;
BEGIN

    IF _month_num BETWEEN 1 AND 3 THEN _result := 1;
    ELSIF _month_num BETWEEN 4 AND 6 THEN _result := 2;
	ELSIF _month_num BETWEEN 7 AND 9 THEN _result := 3;
    ELSIF _month_num BETWEEN 10 AND 12 THEN _result := 4;
	ELSE _result := 0;
	END IF;
    
    RETURN _result;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT f_get_number_if(10);

