--- 1
SELECT no, sid, tid, cid,
  CASE 
    WHEN score IS NULL THEN NULL
    WHEN score >= 60 THEN (score-60)/10+2
    ELSE 0.0
  END AS five_scale_score
FROM CHOICES;

--- 2 缺考？特殊情况？
SELECT 
  COUNT(*) AS total_students,
  SUM(CASE WHEN score IS NULL THEN 0 ELSE 1 END) AS scored_students,
  SUM(CASE WHEN score >= 60 THEN 1 ELSE 0 END) AS passed_students,
  SUM(CASE WHEN score >= 60 THEN 0 WHEN score IS NULL THEN 0 ELSE 1 END) AS failed_students
FROM CHOICES
WHERE cid = '10028';

--- 3 会，最前面
SELECT score FROM CHOICES ORDER BY score ASC;
--- 4 只出现一次
SELECT DISTINCT score FROM CHOICES ORDER BY  score ASC;

--- 5 单列一组
SELECT score, COUNT(*) FROM CHOICES GROUP BY score;
--- 6
SELECT sid, AVG(score) AS avg_score, COUNT(*) AS total_records, MAX(score) AS max_score, MIN(score) AS min_score, SUM(score) AS sum_score
FROM CHOICES
GROUP BY sid;

--- null改为0
SELECT sid, AVG(ISNULL(score, 0)) AS avg_score, COUNT(*) AS total_records, MAX(ISNULL(score, 0)) AS max_score, MIN(ISNULL(score, 0)) AS min_score, SUM(ISNULL(score, 0)) AS sum_score
FROM CHOICES
GROUP BY sid;


--- 7
SELECT COUNT(*) AS total_records, AVG(ISNULL(score, 0)) AS avg_score, MAX(ISNULL(score, 0)) AS max_score, MIN(ISNULL(score, 0)) AS min_score
FROM CHOICES
WHERE ISNULL(score, 0) < 60;

--- 8 可能为NULL？

SELECT MIN(hour) FROM COURSES WHERE hour <= ALL (SELECT hour FROM COURSES WHERE hour > 0);

--- 9

CREATE TABLE S (
    NO INT PRIMARY KEY,
    SID CHAR(10),
    SNAME VARCHAR(20)
);

CREATE TABLE T (
    NO INT PRIMARY KEY,
    TID CHAR(10),
    TNAME VARCHAR(20)
);

INSERT INTO S(NO, SID, SNAME) VALUES
(1, '0129871001', '王小明'),
(2, '0129871002', '李兰'),
(3, '0129871005', NULL),
(4, '0129871004', '关红');

INSERT INTO T(NO, TID, TNAME) VALUES
(1, '100189', '王小明'),
(2, '100180', '李小'),
(3, '100121', NULL),
(4, '100128', NULL);

SELECT * FROM S

SELECT * FROM T


SELECT S.SID, T.TID
FROM S JOIN T ON S.SNAME = T.TNAME
WHERE S.SNAME IS NOT NULL AND T.TNAME IS NOT NULL;