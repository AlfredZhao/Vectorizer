--AIBS_DB.PKG
CREATE OR REPLACE PACKAGE AIBS_DB IS

  --获得查询Vector内容的SQL
  FUNCTION get_vector_sql (
    p_owner     IN VARCHAR2,
    p_table     IN VARCHAR2,
    p_column    IN VARCHAR2
  ) RETURN VARCHAR2;

  --创建hnsw索引
  PROCEDURE create_hnsw_index (
    p_index_name      IN VARCHAR2,
    p_owner           IN VARCHAR2,  -- 新增 owner 参数
    p_table_name      IN VARCHAR2,
    p_column_name     IN VARCHAR2,
    p_distance_type   IN VARCHAR2,
    p_target_accuracy IN NUMBER,
    p_neighbors       IN NUMBER DEFAULT NULL,
    p_efconstruction  IN NUMBER DEFAULT NULL
  );

END AIBS_DB;
/
