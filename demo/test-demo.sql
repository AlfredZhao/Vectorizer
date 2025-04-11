-- 创建测试表
CREATE TABLE EMP_VEC_DEMO (
  EMP_ID NUMBER PRIMARY KEY,
  NAME VARCHAR2(50),
  ROLE VARCHAR2(50)
);


-- 插入 5 条员工数据
INSERT INTO EMP_VEC_DEMO VALUES (1, 'Alice',   'Data Scientist');
INSERT INTO EMP_VEC_DEMO VALUES (2, 'Bob',     'Backend Engineer');
INSERT INTO EMP_VEC_DEMO VALUES (3, 'Charlie', 'AI Researcher');
INSERT INTO EMP_VEC_DEMO VALUES (4, 'Diana',   'Frontend Dev');
INSERT INTO EMP_VEC_DEMO VALUES (5, 'Eve',     'Product Manager');

commit;


-- 1.添加向量字段

-- 2.选择字段进行向量化

-- 3.创建hnsw索引

-- 4.查询结果

