--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: ������� �������� ������ � �� (sqlite3, project name: task1_7). � ������� table1 �������� 1000 ����� � ���������� ���������� (3 �������, ��� int) �� 0 �� 1000.
-- ����� ��������� ����������� ������������� ���� ���� �������

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/
select email from 
(select email, count(*) as c
from person 
group by email
) where c >=2

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/
select e.name as Employee
from Employee e join Employee e2 on e.managerid=e2.id
where e.salary > e2.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
select score, dense_rank() over (order by score desc) as rank
from Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/
select firstName, lastName, city, state
from Person p full join Address a on p.personId=a.personId where p.firstName is not null