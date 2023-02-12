/*********************** Пример № 6 Работа с коммандой COPY *********************/

--сохраним все данные из таблицы prodmag.products в файл products.csv на сервере
COPY
	(
	SELECT 
		product_id,
		products_name,
		food_type_id,
		unit_id,
		qty,
		price,
		--cost его не копируем т.к. это калькулируемое поле и оно считается при вставке значений из полей qty * price
		deadline,
		seller_id
	FROM prodmag.products
	) TO 'C://DataImportExport//products.csv' CSV DELIMITER ';' HEADER ENCODING 'WIN1251';

--теперь очистим таблицу prodmag.products
TRUNCATE TABLE prodmag.products;

--проверим, что таблица пуста
SELECT * FROM prodmag.products;

--теперь заполним нашу таблицу данными из файла products.csv
COPY prodmag.products
	(
	product_id,
	products_name,
	food_type_id,
	unit_id,
	qty,
	price,
	--cost его не копируем т.к. это калькулируемое поле и оно считается при вставке значений из полей qty * price
	deadline,
	seller_id
	)
FROM 'C://DataImportExport//products.csv' WITH (FORMAT CSV, DELIMITER ';', ENCODING 'WIN1251', HEADER);

--и снова читаем таблицу
SELECT * FROM prodmag.products;