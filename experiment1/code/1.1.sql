insert into Test.dbo.PERSON values ('aaa','xkz',12,'student')
insert into Test.dbo.PERSON values ('bbb','xzh',15,'student')

select * from  Test.dbo.PERSON 

update  Test.dbo.PERSON SET PAge=25 where P#='bbb'

delete from  Test.dbo.PERSON  where P#='bbb'

drop table Test.dbo.PERSON