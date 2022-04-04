--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select classes.class, count(t1.ship)
FROM classes
left join
(select outcomes.ship, ships.class
       from outcomes
      left join ships on ships.name = outcomes.ship
       where outcomes.result = 'sunk'
    ) as t1 on t1.class = classes.class or t1.ship = classes.class
group by classes.class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
select ships_count_by_class.class, sunk_ships.count from
(select class, count(*)
from ships 
group by class) as ships_count_by_class
right join 
(select class, count(*)
from outcomes join ships on outcomes.ship = ships.name
where result = 'sunk'
group by class) as sunk_ships on ships_count_by_class.class=sunk_ships.class
where ships_count_by_class.count > 3

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения 
--(учесть корабли из таблицы Outcomes).
with class_by_maxguns as 
(
select * from (select displacement, max(numguns) as max_guns
from classes 
group by displacement) t1 join classes on t1.displacement = classes.displacement where classes.numguns = t1.max_guns
)
select ss.name--, classes.class, classes.displacement 
from (select distinct name, class from 
outcomes full outer join ships on outcomes.ship=ships.name) ss 
	join classes 
	on ss.class=classes.class where ss.class in (select class from class_by_maxguns)
	
--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM 
--и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
with t1 as
(
select *
from pc
join product
on pc.model = product.model
where (ram = (select min(ram) from pc))
) 
select maker
from t1
where speed = (select max(speed) from t1) 
		and maker in (select maker from product 
						join printer 
						on product.model=printer.model)
