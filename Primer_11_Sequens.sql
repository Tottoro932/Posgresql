/*********************** Пример № 11 Последовательности  *******************************/

--Создадим тестовую табличку
CREATE TABLE public.seq_test_tbl
	(
	id INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL
	);
	
--создадим последовательность для таблицы с шагом 10 от 100
CREATE SEQUENCE public.test_seq INCREMENT 10 MINVALUE 100 MAXVALUE 2147483647 START 100 OWNED BY public.seq_test_tbl.id;

--присоединим последовательность к полю id таблицы seq_test_tbl
ALTER TABLE public.seq_test_tbl ALTER COLUMN id SET DEFAULT nextval('public.test_seq');

--вставим несколько записей в таблицу
INSERT INTO public.seq_test_tbl(name) VALUES ('aaa'),('bbb'),('ccc'),('ddd'),('eee'),('fff');

--посмотрим результат
SELECT * FROM public.seq_test_tbl;

--удалим последовательность
DROP SEQUENCE public.test_seq --CASCADE; --без CASCADE не получается удалить т.к. test_seq привязан к таблице через SET DEFAULT

--пробуем снова сделать вставку, ожидаемо получаем ошибку т.к. значения по умолчанию для поля id больше нет
INSERT INTO public.seq_test_tbl(name) VALUES ('xxx');