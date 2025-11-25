SELECT 
    name AS FileName,
    size/128.0 AS SizeMB,
    max_size
FROM sys.database_files;

SELECT * FROM sys.dm_exec_sessions;
SELECT * FROM sys.dm_tran_locks;

SELECT TOP 20
    qs.total_elapsed_time,
    qs.total_logical_reads,
    SUBSTRING(qt.text, 1, 2000) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY total_elapsed_time DESC;
