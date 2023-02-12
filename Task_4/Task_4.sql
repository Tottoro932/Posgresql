-- 1 --

-- суммарное количество рейсов по каждому типу самолета посуточно за январь 2017г
SELECT ac.model->>'ru' as "модель", DATE(f.scheduled_departure) as "дата",
count(f.scheduled_departure) as "кол-во рейсов"
from bookings.flights as f
join bookings.aircrafts_data as ac
   on ac.aircraft_code = f.aircraft_code  
where (f.scheduled_departure >= '2017-01-01 0:00:00.000' and f.scheduled_departure < '2017-02-01 0:00:00.000')
group by ac.model, DATE(f.scheduled_departure)
ORDER BY ac.model ASC

--сумма бронирований и среднее значение бронирований посуточно за январь
SELECT DATE(b.book_date) as "день", SUM(b.total_amount) as "сумма", AVG(b.total_amount) as "среднее"
from bookings.bookings as b
where b.book_date >= '2017-01-01 0:00:00.000'and b.book_date < '2017-02-01 0:00:00.000'
group by DATE(b.book_date)

-- 2 --

-- сама таблица
select * from public.staff  

-- сколько у каждого человека сотрудников в подчинении

WITH RECURSIVE r AS
    (
    SELECT --корневые объекты (люди, у которых никого нет в подчинении)
        ps.id,
        ps.parent_id, 
        ps.fio,
        ps.post,
        0 AS reports
    FROM public.staff AS ps
      where id not in (select ps.parent_id from public.staff AS ps where ps.parent_id is not null)
    union all
    select 
        p.id,
        p.parent_id, 
        p.fio,
        p.post,
        r.reports + 1 AS reports 
    from public.staff AS p
    join r on r.id = p.parent_id
    )
    
select * from r
ORDER BY id asc;
