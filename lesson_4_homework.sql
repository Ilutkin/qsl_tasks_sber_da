--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type
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
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"
select *,
case when price > (select avg(price) from pc)
	then 1
	else 0
end flag
from printer

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)
select t1.name from 
(select name from ships
union
select ship from outcomes) t1 left join ships on t1.name=ships.name
where class is null

--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.
select * from 
(SELECT name, EXTRACT(YEAR FROM date) as YEAR FROM battles) as bd
where bd.year not in (select launched
from ships)

--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.
select battle from (select *
from ships where class='Kongo') as t1 join outcomes on t1.name=outcomes.ship

--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) 
--� ������, ���� ��������� ������ > 300. �� view ��� �������: model, price, flag
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
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) 
--� ������, ���� ��������� ������ c������ . �� view ��� �������: model, price, flag
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
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� 
--������������� = 'D' � 'C'. ������� model
with t1 as (select maker, printer.model, price 
from printer join product on printer.model = product.model)
select t1.model
from t1
where t1.maker = 'A' and price > (select avg(t1.price) from t1 where t1.maker = 'D' or t1.maker = 'C')

--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� 
--������������� = 'D' � 'C'. ������� model
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
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)
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
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) 
--�� ������� �������������. �� view: maker, count
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
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)
SELECT *
from 
count_products_by_makers
order by count


--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� 
--������������� 'D'
create table printer_updated as 
select printer.* from printer join product on printer.model=product.model where maker !='D'

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� 
--(�������� printer_updated_with_makers)
create view printer_updated_with_makers as 
select printer_updated.*, product.maker 
from printer_updated join product on printer_updated.model=product.model

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). 
--�� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)
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
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)
select ship_class, count 
from sunk_ships_by_classes

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0
create table classes_with_flag as 
select *, case when numguns >= 9
				then 1
				else 0
			end flag
from classes 

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)
select country, count(*)
from classes 
group by country
order by count

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".
select count(t1.name) 
from 
(select name from ships
union
select ship from outcomes) t1 left join ships on t1.name=ships.name
where t1.name like 'O_%' or t1.name like 'M_%' 

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.
select count(t1.name) 
from 
(select name from ships
union
select ship from outcomes) t1 left join ships on t1.name=ships.name
where t1.name like '% %' and t1.name not like '% % %'

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)
select launched as year, count(*)
from ships 
group by year
order by count