--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
SELECT name, class
from ships
WHERE launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
SELECT name, class, launched
from ships
WHERE launched between 1921 and 1941

-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
SELECT class, count(name)
from ships
group by class

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
select distinct ships.class , country
from ships 
	join classes 
	on ships.class = classes.class
where bore >= 16

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
SELECT ship
FROM Outcomes
where battle = 'North Atlantic' and result = 'sunk'

-- ������� 6: ������� �������� (ship) ���������� ������������ �������
select ship
from Outcomes  
	join Battles  
	on Outcomes.battle = Battles.name
where result = 'sunk' and date = (select max(date) from Outcomes  
							join Battles  
							on Outcomes.battle = Battles.name)

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
select ship, class
from Outcomes  
	join Battles  
	on Outcomes.battle = Battles.name
		join ships 
		on Outcomes.ship = ships.name
where result = 'sunk' and date = (select max(date) from Outcomes  
							join Battles  
							on Outcomes.battle = Battles.name)
-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
select ship, ships.class
from Ships  
	join Outcomes  
	on Ships.name = Outcomes.ship
		join Classes 
		on Ships.Class = Classes.class
where result = 'sunk' and bore >= 16

-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
select distinct class
from classes
where country = 'USA'

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class
select name, ships.class
from ships 
	join classes 
	on ships.class = classes.class
where country = 'USA'
