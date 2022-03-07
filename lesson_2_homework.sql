--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
SELECT name, class
from ships
WHERE launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
SELECT name, class, launched
from ships
WHERE launched between 1921 and 1941

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
SELECT class, count(name)
from ships
group by class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
select distinct ships.class , country
from ships 
	join classes 
	on ships.class = classes.class
where bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
SELECT ship
FROM Outcomes
where battle = 'North Atlantic' and result = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
select ship
from Outcomes  
	join Battles  
	on Outcomes.battle = Battles.name
where result = 'sunk' and date = (select max(date) from Outcomes  
							join Battles  
							on Outcomes.battle = Battles.name)

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
select ship, class
from Outcomes  
	join Battles  
	on Outcomes.battle = Battles.name
		join ships 
		on Outcomes.ship = ships.name
where result = 'sunk' and date = (select max(date) from Outcomes  
							join Battles  
							on Outcomes.battle = Battles.name)
-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
select ship, ships.class
from Ships  
	join Outcomes  
	on Ships.name = Outcomes.ship
		join Classes 
		on Ships.Class = Classes.class
where result = 'sunk' and bore >= 16

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
select distinct class
from classes
where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select name, ships.class
from ships 
	join classes 
	on ships.class = classes.class
where country = 'USA'
