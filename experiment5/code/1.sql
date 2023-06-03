-- 1

DECLARE @sum INT
SET @sum = 0
DECLARE @i INT
SET @i = 1
WHILE @i <= 100
BEGIN
    SET @sum = @sum + @i
    SET @i = @i + 1
END
IF @@ERROR <> 0
BEGIN
    PRINT '执行失败'
END
ELSE
BEGIN
    PRINT '1+2+3+...+100 = ' + CAST(@sum AS VARCHAR(10))
END

-- 2

use School

CREATE TABLE STUDENTS (
    sid VARCHAR(20) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(2) NOT NULL,
    birthday DATE NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(100) NOT NULL
);

INSERT INTO STUDENTS (sid, name, gender, birthday, email, phone, address) VALUES
('80000759500', '张三', '男', '1999-01-01', 'zhangsan@qq.com', '13888888888', '福建省厦门市思明区厦大路'),
('80000759501', '李四', '女', '1999-02-02', 'lisi@qq.com', '13999999999', '福建省厦门市思明区岛内'),
('80000759502', '王五', '男', '2000-03-03', 'wangwu@qq.com', '15888888888', '福建省厦门市集美区杏林湾');

UPDATE STUDENTS SET email = 'ddff@sina.com' WHERE sid = '80000759500'

IF @@ROWCOUNT = 0
BEGIN
    PRINT '警告！没有数据被更新'
END
ELSE
BEGIN
    PRINT '有数据被更新'
END

-- 3

USE School;


CREATE TABLE COURSES (
    cid VARCHAR(20) PRIMARY KEY,
    cname VARCHAR(50) NOT NULL,
    credit INT NOT NULL
);

INSERT INTO COURSES (cid, cname, credit) VALUES
('010101', '高等数学', 4),
('020201', '大学英语', 3),
('030301', '物理实验', 2);

CREATE TABLE SC (
    sid VARCHAR(20) NOT NULL,
    cid VARCHAR(20) NOT NULL,
    score INT NOT NULL,
    PRIMARY KEY(sid, cid),
    FOREIGN KEY(sid) REFERENCES STUDENTS(sid),
    FOREIGN KEY(cid) REFERENCES COURSES(cid)
);

INSERT INTO SC (sid, cid, score) VALUES
('80000759500', '010101', 80),
('80000759500', '020201', 85),
('80000759502', '010101', 75),
('80000759502', '030301', 90),
('80000759501', '010101', 95),
('80000759501', '020201', 80);


IF (EXISTS(SELECT * FROM STUDENTS WHERE sid='80000759500'))
BEGIN
    SELECT * FROM SC WHERE sid='80000759500';
END
ELSE
BEGIN
    PRINT '查无此人';
END

-- 4
DECLARE @sum INT
SET @sum = 0
DECLARE @i INT
SET @i = 1
WHILE @i <= 100
BEGIN
    SET @sum = @sum + @i
    SET @i = @i + 1
END
SELECT @sum AS '1+2+3+...+100'

-- 5

SELECT CASE 
    WHEN score >= 80 THEN '优秀'
    WHEN score >= 60 AND score < 80 THEN '及格'
    ELSE '不及格'
END AS '成绩'
FROM SC
WHERE sid = '80000759500' AND cid = '020201';

-- 6

CREATE PROCEDURE SP_UPDATE_SCORE
    @sid VARCHAR(20),
    @msg VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @result INT;
    DECLARE @transactionName VARCHAR(20);
    SET @transactionName = 'UpdateScoreTransaction';
    
    BEGIN TRY
        BEGIN TRANSACTION @transactionName;

        -- 判断学生是否存在
        IF EXISTS(SELECT 1 FROM STUDENTS WHERE sid=@sid)
        BEGIN
            -- 更新成绩
            UPDATE SC SET score=CASE
                WHEN score < 60 THEN 60
                WHEN score > 80 THEN 80
                ELSE score
            END WHERE sid=@sid;

            -- 提交事务
            SET @result = 1;
            SET @msg = '更改成功';
            COMMIT TRANSACTION @transactionName;
        END
        ELSE
        BEGIN
            -- 回滚事务
            SET @result = 0;
            SET @msg = '查无此人';
            ROLLBACK TRANSACTION @transactionName;
        END
    END TRY
    BEGIN CATCH
        -- 回滚事务
        SET @result = -1;
        SET @msg = '更改失败';
        ROLLBACK TRANSACTION @transactionName;
    END CATCH

    RETURN @result;
END

DECLARE @sid VARCHAR(20);
DECLARE @msg VARCHAR(50);

SET @sid = '80000759500';

EXEC SP_UPDATE_SCORE @sid=@sid, @msg=@msg OUTPUT;

PRINT @msg;

select * from sc

-- 7

SELECT UPPER(email) AS 'Email', SUBSTRING(cname, 1, 3) AS 'CourseName'
FROM STUDENTS
JOIN SC ON STUDENTS.sid = SC.sid
JOIN COURSES ON COURSES.cid = SC.cid
WHERE STUDENTS.sid = '80000759500';

-- 8

CREATE FUNCTION FN_AVG_SCORE(@sid VARCHAR(20))
RETURNS FLOAT
AS
BEGIN
    DECLARE @avgScore FLOAT;
    SELECT @avgScore = AVG(score) FROM SC WHERE sid = @sid;
    RETURN @avgScore;
END;

CREATE FUNCTION FN_SHOW_COURSE_SCORE(@name VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT COURSES.cname AS 'CourseName', SC.score AS 'Score'
    FROM SC
    JOIN STUDENTS ON SC.sid = STUDENTS.sid
    JOIN COURSES ON SC.cid = COURSES.cid
    WHERE STUDENTS.name = @name
);


CREATE FUNCTION FN_SHOW_STUDENT_SCORE(@cname VARCHAR(50))
RETURNS @tb_scores TABLE (name VARCHAR(50), score INT)
AS
BEGIN
    DECLARE @cid VARCHAR(20)
    SELECT @cid = cid FROM COURSES WHERE cname = @cname;
    INSERT INTO @tb_scores(name, score)
    SELECT STUDENTS.name, SC.score
    FROM SC
    JOIN STUDENTS ON STUDENTS.sid = SC.sid
    WHERE SC.cid = @cid
    RETURN
END;

DECLARE @sid VARCHAR(20)
SET @sid = '80000759501'
SELECT dbo.FN_AVG_SCORE(@sid)

SELECT * FROM dbo.FN_SHOW_COURSE_SCORE('李四');
SELECT * FROM dbo.FN_SHOW_STUDENT_SCORE('高等数学');


-- 9


--- 9.1

DECLARE @sid VARCHAR(20)
DECLARE @cname VARCHAR(50)
DECLARE @score INT

DECLARE cur_student CURSOR FOR
SELECT COURSES.cname, SC.score
FROM SC
JOIN COURSES ON SC.cid = COURSES.cid
WHERE SC.sid = '80000759501'

OPEN cur_student

FETCH NEXT FROM cur_student INTO @cname, @score

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'CourseName: ' + @cname + ', Score: ' + CAST(@score AS VARCHAR(10))
    FETCH NEXT FROM cur_student INTO @cname, @score
END

CLOSE cur_student
DEALLOCATE cur_student

-- 9.2

DECLARE @sid VARCHAR(20)
DECLARE @cid VARCHAR(20)
DECLARE @score INT

DECLARE cur_score CURSOR FOR
SELECT SC.cid, SC.score
FROM SC
WHERE SC.sid = '80000759501'
ORDER BY SC.score DESC OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY

OPEN cur_score

FETCH NEXT FROM cur_score INTO @cid, @score

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE SC SET score = 75 WHERE cid = @cid AND sid = '800007595'
    FETCH NEXT FROM cur_score INTO @cid, @score
END

CLOSE cur_score
DEALLOCATE cur_score

-- 9.3

CREATE TABLE Customers (
    customer_id INT,
    customer_name VARCHAR(50),
    city VARCHAR(50)
)

INSERT INTO Customers VALUES (1, 'John', 'New York')
INSERT INTO Customers VALUES (2, 'Jane', 'Washington')
INSERT INTO Customers VALUES (3, 'David', 'Tokyo')

DECLARE @customer_id INT
DECLARE cur_customer CURSOR FOR
SELECT customer_id FROM Customers

OPEN cur_customer

FETCH NEXT FROM cur_customer INTO @customer_id

WHILE @@FETCH_STATUS = 0
BEGIN
    DELETE FROM Customers WHERE customer_id = @customer_id
    FETCH NEXT FROM cur_customer INTO @customer_id
END

CLOSE cur_customer
DEALLOCATE cur_customer