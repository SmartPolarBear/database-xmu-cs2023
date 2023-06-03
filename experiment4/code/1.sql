use school

CREATE TABLE Stu_Union
(
    sno varchar(10) PRIMARY KEY,
    sname varchar(50),
    gender varchar(10),
    age int,
    major varchar(50)
);

INSERT INTO Stu_Union(sno, sname, Gender, Age, Major)
VALUES('201001', '张三', '男', 22, '计算机科学与技术');
INSERT INTO Stu_Union(sno, sname, Gender, Age, Major)
VALUES('201002', '李四', '男', 23, '软件工程');

-- 2
INSERT INTO Stu_Union(sno, sname, Gender, Age, Major)
VALUES('12345678', '王五', '男', 23, '软件工程');

INSERT INTO Stu_Union(sno, sname, Gender, Age, Major)
VALUES('201001', '李四', '男', 23, '软件工程');

-- 违反主键约束，将无法插入第二条记录

-- 3
SELECT * FROM Stu_Union
UPDATE Stu_Union
SET sno = '201002'
WHERE sno = '201001';
-- 如果更新后sno不再是唯一的，则会违反主键约束


-- 4
SET XACT_ABORT ON;
BEGIN TRAN;
INSERT INTO Stu_Union(sno, sname, Gender, Age, Major)
VALUES('1111111111', '小明', '男', 20, '数学');
UPDATE Stu_Union
SET sname = 'xkz'
WHERE sno = '2222222222';
-- 第一条语句插入成功，第二条语句更新失败，整个事务将回滚
ROLLBACK TRAN;

--5
CREATE TABLE Scholarship
(
    ID int PRIMARY KEY,
    sno varchar(10),
    ScholarshipType varchar(50),
    FOREIGN KEY (sno) REFERENCES Stu_Union(sno)
);

INSERT INTO Scholarship(ID, sno, ScholarshipType)
VALUES(1, '3333333333', '全额奖学金');
-- 如果sno不存在于Stu_Union表中，则会违反参照完整性，无法插入该记录

