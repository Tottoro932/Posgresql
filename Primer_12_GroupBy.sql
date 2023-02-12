/*********************** Пример № 12 Группировка  *******************************/

--сгруппируем наш запрос по продуктам магазина по типу товара
SELECT
	t.food_type_name,
	SUM(p.qty), --суммарное количество
	MAX(p.price),  --максимальная цена в группе
	MIN(p.deadline) --минимальное время хранения
FROM prodmag.products AS p
JOIN prodmag.food_types AS t  
	USING(food_type_id)
GROUP BY t.food_type_name
ORDER BY t.food_type_name ASC;

--применим другие агрегатные функции
SELECT
	t.food_type_name,
	STRING_AGG(p.products_name, '; ') AS prod_names,  --собрали в строку через ";"
	ARRAY_AGG(p.qty) AS qty_array, --собрали значения в массив
	JSON_AGG(p.price), --собрали значения в массив json
	JSON_OBJECT_AGG('deadline', p.deadline) --собрали значения в объект json
FROM prodmag.products AS p
JOIN prodmag.food_types AS t  
	USING(food_type_id)
GROUP BY t.food_type_name
ORDER BY t.food_type_name ASC;

--пример из рабочей базы: получить последние значения, сгруппированные по имени тега
(SELECT 
  	(ARRAY_AGG(t.zifra_tag_name ORDER BY v.date DESC))[1],
    MAX(v.date),
  	(ARRAY_AGG(v.value ORDER BY v.date DESC))[1] --собираем значения в массив, отсортированный по дате в обратном порядке и выводим из массива первое значение [1]
FROM dictionary.lims_tag AS t
JOIN result.lims_values AS v
	ON v.id_lab = t.id
GROUP BY t.id;