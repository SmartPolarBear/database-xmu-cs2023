-- 1
-- 创建记录表
CREATE TABLE LowScoreStudent
(
    sno VARCHAR(10) PRIMARY KEY,
    cno VARCHAR(10),
    grade int,
    FOREIGN KEY (sno) REFERENCES Stu_Union(sno) ON DELETE CASCADE,
    FOREIGN KEY (cno) REFERENCES Course(cno) ON DELETE CASCADE
)

-- 创建触发器
CREATE TRIGGER Trigger_Sc_Insert ON sc
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sno VARCHAR(10), @Cno VARCHAR(10), @Score INT;

    SELECT @Sno = Sno, @Cno = Cno, @Score = Grade
    FROM inserted;

    IF (@Score < 60)
    BEGIN
        UPDATE sc SET grade = 60 WHERE Sno = @Sno AND Cno = @Cno;

        INSERT INTO LowScoreStudent (Sno, Cno, grade) VALUES (@Sno, @Cno, @Score);
    END
END

INSERT INTO Course(cno, cname, credit)
VALUES
	  ('45', '数据结构2', 3)

insert into sc(sno, cno, grade)
values ('201001', '45', 59)

select * from sc
select * from LowScoreStudent

--2 
-- 创建触发器
CREATE TRIGGER Trigger_StuUnion_UpdateSid ON stu_union
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE sc
    SET Sno = inserted.Sno
    FROM sc
    INNER JOIN inserted ON inserted.Sno = sc.Sno;
END

-- 3
-- 创建触发器
CREATE TRIGGER Trigger_Stu_Union_Delete ON stu_union
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sno VARCHAR(10);

    SELECT @Sno = deleted.sno
    FROM deleted;

    DELETE FROM sc WHERE Sno = @Sno;
END

-- 4
-- 删除触发器
DROP TRIGGER LowScoreTrigger;
DROP TRIGGER UpdateSidTrigger;
DROP TRIGGER DeleteStudentTrigger;

-- 删除记录表
DROP TABLE LowScoreStudents;