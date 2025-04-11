--AIBS_DB.PKG_BODY
CREATE OR REPLACE PACKAGE BODY AIBS_DB IS

  --获得查询Vector内容的SQL
  FUNCTION get_vector_sql (
    p_owner     IN VARCHAR2,
    p_table     IN VARCHAR2,
    p_column    IN VARCHAR2
  ) RETURN VARCHAR2 IS
    v_sql VARCHAR2(32767);
  BEGIN
    v_sql := 'SELECT ' || p_column || ' FROM ' || p_owner || '.' || p_table;

    RETURN v_sql;
  END get_vector_sql;
  
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
	) AS
	  v_sql VARCHAR2(4000);
	BEGIN
	  -- 检查 owner 是否为空
	  IF p_owner IS NULL OR p_owner = '' THEN
	    APEX_UTIL.SET_SESSION_STATE('P5_MESSAGE', 'Error: Owner must be specified');
	    RETURN;
	  END IF;
	
	  -- 基本 SQL，移除 DBMS_ASSERT.ENQUOTE_NAME，直接拼接参数
	  v_sql := 'CREATE VECTOR INDEX ' || p_index_name || 
	           ' ON ' || p_owner || '.' || p_table_name || 
	           '(' || p_column_name || ') ' ||
	           'ORGANIZATION INMEMORY NEIGHBOR GRAPH ' ||
	           'DISTANCE ' || UPPER(p_distance_type) || ' ' ||
	           'WITH TARGET ACCURACY ' || TO_CHAR(p_target_accuracy);
	
	  -- 如果提供了参数，则添加 PARAMETERS 子句
	  IF p_neighbors IS NOT NULL OR p_efconstruction IS NOT NULL THEN
	    v_sql := v_sql || ' PARAMETERS (type HNSW';
	    IF p_neighbors IS NOT NULL THEN
	      v_sql := v_sql || ', neighbors ' || TO_CHAR(p_neighbors);
	    END IF;
	    IF p_efconstruction IS NOT NULL THEN
	      v_sql := v_sql || ', efconstruction ' || TO_CHAR(p_efconstruction);
	    END IF;
	    v_sql := v_sql || ')';
	  END IF;
	
	  -- 调试输出（可选）
	  APEX_DEBUG.MESSAGE('Generated SQL: ' || v_sql);
	
	  -- 执行动态 SQL
	  EXECUTE IMMEDIATE v_sql;
	
	  -- 成功消息
	  APEX_UTIL.SET_SESSION_STATE('P5_MESSAGE', 'Index created successfully');
	EXCEPTION
	  WHEN OTHERS THEN
	    -- 错误消息
	    APEX_UTIL.SET_SESSION_STATE('P5_MESSAGE', 'Error: ' || SQLERRM || ' - SQL: ' || v_sql);
	    RAISE;
	END create_hnsw_index;

END AIBS_DB;
/
