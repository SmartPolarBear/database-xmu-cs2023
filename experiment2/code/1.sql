--- 1
select * from STUDENTS where grade=2001 order by sid asc

--- 2
SELECT sid, cid, score, 
       CASE WHEN score >= 60 THEN (score - 50) / 10 ELSE 0 END AS gpa
FROM CHOICES
WHERE score >= 60;

--- 3
SELECT cname
FROM COURSES
WHERE hour IN (48, 64);

--- 4
SELECT cid
FROM COURSES
WHERE cname LIKE '%data%';

--- 5
SELECT DISTINCT cid
FROM CHOICES;

--- 6
SELECT AVG(salary) AS avg_salary
FROM TEACHERS;

--- 7
SELECT TEACHERS.tid, AVG(CHOICES.score) AS avg_score
FROM TEACHERS
JOIN CHOICES ON TEACHERS.tid = CHOICES.tid
JOIN STUDENTS ON STUDENTS.sid = CHOICES.sid
GROUP BY TEACHERS.tid
ORDER BY avg_score desc

--- 8
SELECT COUNT(*),AVG(CHOICES.score) from CHOICES
GROUP BY cid

--- 9
SELECT sid from CHOICES
GROUP BY sid
HAVING COUNT(*)>=3
select * from CHOICES where sid=812917218 

--- 10
SELECT cname,score FROM CHOICES JOIN COURSES ON CHOICES.cid = COURSES.cid
where sid = 800009026

--- 11
SELECT sid FROM CHOICES where cid in (select cid from COURSES where cname like 'database')
select * from CHOICES where sid=870899566  
select * from COURSES

-- 12
SELECT cid, COUNT(DISTINCT sid) AS num_of_students
FROM CHOICES
GROUP BY cid;

--- 求出选择相同课程的学生数。
SELECT COUNT(DISTINCT c1.sid) AS num_of_students, c1.cid
FROM CHOICES c1
INNER JOIN CHOICES c2 ON c1.cid = c2.cid AND c1.sid <> c2.sid
GROUP BY c1.cid;


--- 13
SELECT cid FROM CHOICES 
GROUP BY cid
HAVING COUNT(*)>=2
select * from CHOICES where cid=10008

--- 14
select top(1) sid from CHOICES
where cid in (
	select cid from CHOICES where sid = 800009026
)
order by NEWID()

--- 15 854139983 
select * from STUDENTS JOIN CHOICES ON STUDENTS.sid = CHOICES.sid 
where STUDENTS.sid=854139983

--- 16 ???
select * from COURSES
select * from CHOICES where sid =  '850955252'

SELECT s.sname, c.cname, ch.score
FROM STUDENTS s, CHOICES ch, COURSES c
WHERE s.sid = ch.sid AND ch.cid = c.cid AND s.sid = '850955252';

--- 17
SELECT * FROM STUDENTS 
where grade in (SELECT grade from STUDENTS where sid='850955252')

--- 18
select * from STUDENTS 
where sid in (
select distinct sid from CHOICES
)

-- 19
select * from COURSES
where cid not in (
select distinct cid from CHOICES
)

--- 20

select sname from STUDENTS where
sid in (
select distinct sid from CHOICES where cid in (
select distinct cid from COURSES where hour in (
select hour from COURSES where cname like 'c++'
)
)
)

--- 21
select top (1) * from CHOICES
order by score DESC

--- 22
select cname from COURSES where hour in (
select hour from COURSES where cname like 'C++' or cname like 'UML'
)

--- 23
select sname from STUDENTS where sid in(
select distinct sid from CHOICES where cid = 10001
)

--- 24 ？？？

SELECT sid from CHOICES 
where not exists(
select * from COURSES where
cid not in (select CHOICES.cid from CHOICES where CHOICES.sid = sid)
)

SELECT sname
FROM STUDENTS
WHERE sid IN (
  SELECT sid
  FROM CHOICES
  GROUP BY sid
  HAVING COUNT(DISTINCT cid) = (
    SELECT COUNT(*) FROM COURSES
  )
);

--- 25

SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'C++')
UNION
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'Java');

--- 26 ？？？
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'C++')
INTERSECT
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'Java');

--- 27
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'C++')
EXCEPT
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'Java');