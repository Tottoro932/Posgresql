/*********************** Пример № 27 Event Trigger *******************************/

--создадим триггерную функцию
CREATE OR REPLACE FUNCTION public.event_trg() RETURNS EVENT_TRIGGER AS
$$
DECLARE
	rec RECORD;
BEGIN
	
	RAISE INFO 'ddl trigger: %, query: %', tg_tag, current_query();
	FOR rec IN SELECT * FROM pg_event_trigger_ddl_commands()
	LOOP
    RAISE INFO 'subcommand: %, %, %, query:%', 
		rec.command_tag, 
		rec.schema_name, 
		rec.objid::regclass::text, 
		current_query();
		
	END LOOP;

END;
$$
LANGUAGE PLPGSQL;


--создаем event триггер
CREATE EVENT TRIGGER tr_after_ddl
ON DDL_COMMAND_END 
EXECUTE FUNCTION public.event_trg(); 

--создаем табличку и смотрим, что выдает наш триггер
CREATE TABLE public.event_trg_test
	(
    id serial NOT NULL PRIMARY KEY,
    code CHAR(5) NOT NULL UNIQUE,
    name VARCHAR(20)
    );