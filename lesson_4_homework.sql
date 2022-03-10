--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
select t1.model, maker, t2.type
from (
  select model, price 
  from pc 
  union all  
  
  select model, price 
  from printer
  union all 
  
  select model, price 
  from laptop
) t1
left join 
(
  select maker, model, type
  from product 
) t2 
on t1.model = t2.model 

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
select *,
case when price > (select avg(price) from pc)
	then 1
	else 0
end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select t1.name from 
(select name from ships
union
select ship from outcomes) t1 left join ships on t1.name=ships.name
where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
select * from 
(SELECT name, EXTRACT(YEAR FROM date) as YEAR FROM battles) as bd
where bd.year not in (select launched
from ships)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select battle from (select *
from ships where class='Kongo') as t1 join outcomes on t1.name=outcomes.ship

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) 
--с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag
create view all_products_flag_300 as
select model, price,
	case when price > 300
	then 1
	else 0
end flag
from 
(
  select model, price 
  from pc 
  union all  
  
  select model, price 
  from printer
  union all 
  
  select model, price 
  from laptop
) t1

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) 
--с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag
create view all_products_flag_avg_price as
with t1 as (
  select model, price 
  from pc 
  union all  
  
  select model, price 
  from printer
  union all 
  
  select model, price 
  from laptop
)
select model, price,
	case when price > (select avg(price) from t1)
	then 1
	else 0
end flag
from t1

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам 
--производителя = 'D' и 'C'. Вывести model
with t1 as (select maker, printer.model, price 
from printer join product on printer.model = product.model)
select t1.model
from t1
where t1.maker = 'A' and price > (select avg(t1.price) from t1 where t1.maker = 'D' or t1.maker = 'C')

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам 
--производителя = 'D' и 'C'. Вывести model
with t3 as (select maker, printer.model, price 
from printer join product on printer.model = product.model)
select t2.model, price, maker
from (select model, price from pc
	union all
	select model, price from printer
		union all
	select model, price from laptop) as t1 
	left join (select maker, model from product)
 as t2 on t1.model = t2.model
where maker = 'A' and price > (select avg(t3.price) from t3 where t3.maker = 'D' or t3.maker = 'C')

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
select type, avg(price)
from (select model, price from pc
	union all
	select model, price from printer
		union all
	select model, price from laptop) as t1 
	left join (select maker, model, type from product)
 as t2 on t1.model = t2.model
where maker = 'A'
group by type

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) 
--по каждому производителю. Во view: maker, count
create view count_products_by_makers as
select maker, count(*)
from (select model, price from pc
	union all
	select model, price from printer
		union all
	select model, price from laptop) as t1 
	left join (select maker, model, type from product)
 as t2 on t1.model = t2.model
group by maker

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
SELECT *
from 
count_products_by_makers
order by count


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры 
--производителя 'D'
create table printer_updated as 
select printer.* from printer join product on printer.model=product.model where maker !='D'

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя 
--(название printer_updated_with_makers)
create view printer_updated_with_makers as 
select printer_updated.*, product.maker 
from printer_updated join product on printer_updated.model=product.model

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). 
--Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
create view sunk_ships_by_classes as
select case when tbl.class is null
		then '0'
		else tbl.class
end ship_class 
, tbl.count
from 
(select t2.class, count(*)
from (select ship 
from outcomes where result='sunk') as t1 
left join (select ships.name, classes.class
			from ships join classes on ships.class=classes.class) as t2
on t1.ship=t2.name
group by t2.class) as tbl

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
select ship_class, count 
from sunk_ships_by_classes

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
create table classes_with_flag as 
select *, case when numguns >= 9
				then 1
				else 0
			end flag
from classes 

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)
select country, count(*)
from classes 
group by country
order by count

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select count(t1.name) 
from 
(select name from ships
union
select ship from outcomes) t1 left join ships on t1.name=ships.name
where t1.name like 'O_%' or t1.name like 'M_%' 

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select count(t1.name) 
from 
(select name from ships
union
select ship from outcomes) t1 left join ships on t1.name=ships.name
where t1.name like '% %' and t1.name not like '% % %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
select launched as year, count(*)
from ships 
group by year
order by count
