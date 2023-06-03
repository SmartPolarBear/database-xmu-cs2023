-- 1
-- 创建 STUDENTS 表
CREATE TABLE STUDENTS (
    sno VARCHAR(10) PRIMARY KEY,
    sname VARCHAR(50),
    email VARCHAR(50),
    grade INT
);

-- 在 sname 字段上创建聚簇索引
CREATE CLUSTERED INDEX idx_sname ON STUDENTS(sname);

-- 在 grade 字段上创建非聚簇索引
CREATE NONCLUSTERED INDEX idx_grade ON STUDENTS(grade);

-- 2
-- 创建 CHOICES 表
CREATE TABLE CHOICES (
    no INT IDENTITY(1,1) PRIMARY KEY,
    sid VARCHAR(10),
    tid VARCHAR(10),
    cid VARCHAR(10),
    score INT
);

-- 为 cid 字段添加索引（实验2A）
SELECT COUNT(*) FROM CHOICES WHERE cid = '101';


-- 为 cid 字段添加非聚簇索引（实验2B）
CREATE NONCLUSTERED INDEX idx_cid ON CHOICES(cid);

-- 重新运行查询（实验2B）
SELECT COUNT(*) FROM CHOICES WHERE cid = '101';

-- 3

-- 为 sid 字段添加非聚簇索引（实验3B）
CREATE INDEX idx_sid ON CHOICES(sid);

-- 为 sid 字段添加聚簇索引（实验3C）
CREATE CLUSTERED INDEX idx_sid ON CHOICES(sid);

-- 运行查询
SELECT * FROM CHOICES WHERE sid = 'S01';