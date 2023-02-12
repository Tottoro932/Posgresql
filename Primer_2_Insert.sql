/*********************** Пример № 2 Заполняем таблицы данными *********************/

INSERT INTO prodmag.food_types (food_type_name) --указываем только поле food_type_name для вставки т.к. поле ID у нас проставится автоинкрементом 
VALUES 
	('Консервы'),
	('Крупы'),
	('Масла'),
	('Молочка'),
	('Мясо'),
	('Овощи'),
	('Птица'),
	('Рыба'),
	('Специи'),
	('Фрукты');

INSERT INTO prodmag.units (unit_name) 
VALUES
	('г'),
	('кг'),
	('л'),
	('шт');
	
INSERT INTO prodmag.sellers (seller_name, address, inn) 
VALUES
	('ВнешПлодИмпорт', 'г. Калининград, ул. Ленина, д2, стр. 4', '77594632186'),
	('Вологодская птицефабрика', 'Вологодская обл., деревня Куроедово, д.18', '77156954155'),
	('МурманскРыбФлот', 'г. Мурманск, ул. Прибрежная, д. 15', '77621554893'),
	('РусАгро', 'г. Ростов, ул. Мира, д.1', '77885126294'),
	('Совхоз им.Ленина', 'Московская обл, Ленинский район, Совхоз им. Ленина', '77516654466'),
	('Томбовский мясник', 'г. Томбов, ул. Живодерская, стр. 1-Б', '77512365121'),
	('Фермер Иванов А.М.', 'Рязанская обл., село Морозово, д.2', '77459563210');
	
INSERT INTO prodmag.products 
	(
	products_name,
	food_type_id,
	unit_id,
	qty,
	price,
	--cost его не вставляем т.к. это калькулируемое поле и оно считается при вставке значений из полей qty * price
	deadline,
	seller_id
	)
VALUES
	(
	'Авокадо', 
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Фрукты'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	24,
	115.50,
	30,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'ВнешПлодИмпорт')
	),
	(
	'Ананас',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Фрукты'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	65,
	325.50,
	20,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'ВнешПлодИмпорт')
	),
	(
	'Бананы',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Фрукты'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	360,
	81.10,
	15,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'ВнешПлодИмпорт')
	),
	(
	'Говядина туша',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Мясо'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	312,
	329.15,
	12,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Томбовский мясник')
	),
	(
	'Говядина тушеная',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Консервы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'шт'),
	150,
	75.50,
	2500,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Горошек зеленый',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Консервы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'шт'),
	358,
	59.20,
	2500,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'ВнешПлодИмпорт')
	),
	(
	'Гречка',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Крупы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	1420,
	45.50,
	120,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Груши',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Фрукты'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	320,
	125.25,
	20,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'ВнешПлодИмпорт')
	),
	(
	'Индейка',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Птица'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	420,
	165.00,
	10,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Вологодская птицефабрика')
	),
	(
	'Камбала',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Рыба'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	154,
	225.15,
	50,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'МурманскРыбФлот')
	),
	(
	'Капуста качанная',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	850,
	22.15,
	80,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Капуста цветная',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	85,
	95.95,
	15,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Картофель',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	15200,
	25.30,
	30,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Фермер Иванов А.М.')
	),
	(
	'Корица',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Специи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'г'),
	1250,
	85.55,
	240,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'ВнешПлодИмпорт')
	),
	(
	'Кофе в зернах',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Крупы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	450,
	285.15,
	300,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'ВнешПлодИмпорт')
	),
	(
	'Курица',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Птица'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	720,
	102.25,
	10,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Вологодская птицефабрика')
	),
	(
	'Лосось',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Рыба'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	280,
	1240.95,
	10,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'МурманскРыбФлот')
	),
	(
	'Лук репка',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	550,
	39.90,
	30,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Фермер Иванов А.М.')
	),
	(
	'Макароны',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Крупы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	1450,
	33.60,
	240,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Манка',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Крупы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	1240,
	55.10,
	240,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Масло подсолнечное',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Масла'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'л'),
	59,
	268.30,
	100,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Ментай',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Рыба'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	440,
	55.20,
	120,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'МурманскРыбФлот')
	),
	(
	'Молоко',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Молочка'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'л'),
	150,
	68.90,
	3,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Фермер Иванов А.М.')
	),	
	(
	'Молоко сгущеное',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Консервы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'шт'),
	150,
	95.80,
	1825,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Морковь',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	550,
	16.95,
	30,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Фермер Иванов А.М.')
	),
	(
	'Мука пшеничная',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Крупы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	254,
	74.00,
	100,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),	
	(
	'Огурцы',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	241,
	63.20,
	20,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Совхоз им.Ленина')
	),					
	(
	'Перец сладкий',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	152,
	98.80,
	20,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Совхоз им.Ленина')
	),		
	(
	'Пшено',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Крупы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	960,
	63.00,
	240,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),			
	(
	'Редис',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	24,
	75.00,
	20,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Совхоз им.Ленина')
	),
	(
	'Рис',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Крупы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	2500,
	65.60,
	180,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Сахар песок',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Крупы'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	2800,
	74.55,
	180,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'РусАгро')
	),
	(
	'Свинина туша',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Мясо'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	125,
	158.85,
	20,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Томбовский мясник')
	),		
	(
	'Творог',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Молочка'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	45,
	88.20,
	3,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Фермер Иванов А.М.')
	),	
	(
	'Томаты',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Овощи'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	185,
	198.40,
	20,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Совхоз им.Ленина')
	),
	(
	'Яблоки',
	(SELECT food_type_id FROM prodmag.food_types WHERE food_type_name = 'Фрукты'),
	(SELECT unit_id FROM prodmag.units WHERE unit_name = 'кг'),
	1200,
	35.85,
	45,
	(SELECT seller_id FROM prodmag.sellers WHERE seller_name = 'Фермер Иванов А.М.')
	);	
