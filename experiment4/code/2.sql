CREATE TABLE Course
(
    cno varchar(10) PRIMARY KEY,
    cname varchar(50),
    credit int
);

INSERT INTO Course(cno, cname, credit)
VALUES('01', '数据库原理', 4),
      ('02', '操作系统', 3),
      ('03', '数据结构', 3),
	  ('45', '数据结构2', 3)

CREATE TABLE sc
(
    sno varchar(10),
    cno varchar(10),
    grade int,
    PRIMARY KEY (sno, cno),
    FOREIGN KEY (sno) REFERENCES Stu_Union(sno) ON DELETE CASCADE,
    FOREIGN KEY (cno) REFERENCES Course(cno) ON DELETE CASCADE
);

INSERT INTO sc(sno, cno, grade)
VALUES('201001', '01', 80),
      ('201002', '01', 90),
      ('201001', '02', 85),
      ('201002', '02', 70);

-- 3
INSERT INTO sc(sno, cno, grade)
VALUES('201003', '04', 75);
-- 违反参照完整性，因为Course表中不存在cno为'04'的记录。

-- 4
DELETE FROM Stu_Union
WHERE StudentID = '201001';
-- 此时，sc表中该学生所选的所有课程，都会被级连删除。

-- 5

DELETE FROM Course
WHERE cno = '01';
-- 此时，sc表中所有选了该课程的学生，都会被级连删除。


--6

CREATE TABLE Stu_Card
(
    card_id varchar(10) PRIMARY KEY,
    sno varchar(10),
    create_date datetime,
    FOREIGN KEY (sno) REFERENCES Stu_Union(StudentID) ON DELETE CASCADE
);

INSERT INTO Stu_Card(card_id, sno, create_date)
VALUES('20100101', '201001', '2021-01-01'),
      ('20100102', '201002', '2021-01-02');

CREATE TABLE ICBC_Card
(
    bank_id varchar(10) PRIMARY KEY,
    stu_card_id varchar(10),
    expired_date datetime,
    FOREIGN KEY (stu_card_id) REFERENCES Stu_Card(card_id) ON DELETE CASCADE
);

INSERT INTO ICBC_Card(bank_id, stu_card_id, expired_date)
VALUES('955880001', '20100101', '2026-01-01'),
      ('955880002', '20100102', '2027-01-01');

-- 7
DELETE FROM Stu_Union
WHERE StudentID = '201002';
-- 此时，sc表中该学生所选的所有课程，以及Stu_Card、ICBC_Card中与该学生相关的记录，都会被级连删除。
SELECT * FROM SC
SELECT * FROM Stu_Card
SELECT * FROM ICBC_Card
-- 8

SET XACT_ABORT ON;
BEGIN TRAN;
DELETE FROM Stu_Union
WHERE StudentID = '201001';
-- 通过修改外键属性，禁止级连删除
ALTER TABLE ICBC_Card
DROP CONSTRAINT FK_ICBC_Card_stu_card_id;

ALTER TABLE Stu_Card
DROP CONSTRAINT FK_Stu_Card_stu_id;

ALTER TABLE Stu_Union
DROP CONSTRAINT FK_sc_sno;

-- 在这种情况下，将无法删除sc表中与该学生相关的记录，整个事务会回滚
DELETE FROM Stu_Union
WHERE StudentID = '201001';

COMMIT TRAN

-- 10

CREATE TABLE Course_Teacher_Teaching (
    CourseId INT NOT NULL,
    TeacherId INT NOT NULL,
    PRIMARY KEY (CourseId)
);

CREATE TABLE Teacher_Listening (
    TeacherId INT NOT NULL,
    CourseId INT NOT NULL,
    PRIMARY KEY (TeacherId)
);

ALTER TABLE Course_Teacher_Teaching
ADD CONSTRAINT fk_Course_Teacher_Teaching_Teacher_Listening
FOREIGN KEY (TeacherId) REFERENCES Teacher_Listening(TeacherId);


ALTER TABLE Teacher_Listening
ADD CONSTRAINT fk_Teacher_Listening_Course_Teacher_Teaching
FOREIGN KEY (CourseId) REFERENCES Course_Teacher_Teaching(CourseId);

CREATE TRIGGER trg_Teacher_Listening
ON Teacher_Listening
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN Course_Teacher_Teaching ct ON i.CourseId = ct.CourseId WHERE ct.TeacherId <> i.TeacherId)
    BEGIN
        RAISERROR ('Error: A teacher can only listen one course taught by himself', 16, 1)
        ROLLBACK
    END
END

