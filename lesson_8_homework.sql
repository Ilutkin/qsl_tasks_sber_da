--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select member_name, status, sum(amount * unit_price) as costs
from FamilyMembers
join Payments
on FamilyMembers.member_id = Payments.family_member
where YEAR(date) = 2005
group by member_name, status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select t1.name
from 
(select name, count(name) as count
from Passenger
group by name) t1
where t1.count >1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(first_name) as count
from Student
where first_name like "Anna"

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select count(classroom) as count
from Schedule
where date='2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(first_name) as count 
from Student 
where first_name like 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32


--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
select good_type_name, sum(amount*unit_price) as costs 
from GoodTypes gt join Goods g on gt.good_type_id = g.type
join Payments p on g.good_id = p.good
where year(date)=2005
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
select min(TIMESTAMPDIFF(year, birthday, current_date)) as year
from student 

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
select floor(max(datediff(now(), birthday) / 365)) as max_year 
from Student s join Student_in_class sic on s.id=sic.student
join Class c on sic.class=c.id
where c.name like '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
select fm.status, fm.member_name, sum(p.amount*p.unit_price) as costs 
from FamilyMembers as fm join Payments as p on fm.member_id =p.family_member 
join Goods as g on p.good = g.good_id 
join GoodTypes as gt on g.type = gt.good_type_id 
where good_type_name = 'entertainment'
group by fm.status, fm.member_name 

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
delete from Company
where Company.id in (
	select company from Trip
	group by company 
	having count(id) = (
		select min(count)
		from (select count(id) as count
				from Trip 
				group by company) as min_count
				)
				)
				
--task13  (lesson8) 
-- https://sql-academy.org/ru/trainer/tasks/45
select classroom 
from Schedule 
group by classroom 
having count(classroom) = 
	(select count(classroom)
	from Schedule 
	group by classroom 
	order by count(classroom) desc 
	limit 1)
	
--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select last_name
from Teacher t join Schedule sch on t.id=sch.teacher
join Subject s on sch.subject=s.id 
where s.name = 'Physical Culture'
order by t.last_name 

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
select concat(last_name, '.', left(first_name, 1), '.',left(middle_name, 1), '.') as name
from Student 
order by last_name, first_name