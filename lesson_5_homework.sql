--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов 
--(не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц
create view pages_all_products as
select *, 
      case when num % 2 = 1 then 1 else 2 end as num_in_page,
      case when num % 2 = 0 then num/2 else num/2 + 1 end as page_num
from (
      select *, row_number() over (order by price desc) as num
      from Laptop
) t1

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров 
--по типу устройства. Вывод: производитель, тип, процент (%)
create view distribution_by_type as 
select maker, type, count(type)*100/(select count(*) from product) as percent
from product
group by maker, type
order by maker
--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/


--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words as 
(select *
from ships 
where name like '% %' and name not like '% % %')
--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
select a.ship 
from ((select ship
from ships full join outcomes on ships.name=outcomes.ship 
where class is null) 
union 
(select name
from ships full join outcomes on ships.name=outcomes.ship 
where class is null) ) as a
where ship is not null

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' 
--и три самых дорогих (через оконные функции). Вывести model
select t.model from (select p.model, p.price, p2.maker, rank(*) over (order by price) as rnk
from printer p join product p2 on p.model=p2.model) as t
where t.rnk in (1,2,3) or (t.maker = 'A' 
		and (t.price > (select avg(price) from printer p join product p2 on p.model=p2.model where maker = 'C') 
		or t.price > 0))
