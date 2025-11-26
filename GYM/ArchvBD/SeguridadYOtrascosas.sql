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


SELECT 
    name AS LoginName,
    type_desc AS LoginType,
    create_date,
    modify_date,
    is_disabled
FROM sys.server_principals
WHERE type IN ('S', 'U', 'G'); 

SELECT 
    name AS LoginName,
    type_desc AS LoginType,
    create_date
FROM sys.server_principals
WHERE type IN ('S','U','G')       -- SQL, Windows, Groups
  AND name NOT LIKE '##%'         -- excluye logins internos
  AND name NOT IN ('sa')          -- excluye el login sa
  AND principal_id > 100          -- ID > 100 = creados por usuario
ORDER BY create_date;


USE GimnasioDB

SELECT 
    name AS LoginName,
    type_desc AS LoginType,
    create_date
FROM sys.server_principals
WHERE type IN ('S','U','G')       -- SQL, Windows, Groups
  AND name NOT LIKE '##%'         -- excluye logins internos
  AND name NOT IN ('sa')          -- excluye el login sa
  AND principal_id > 100          -- ID > 100 = creados por usuario
ORDER BY create_date;
 

-- SQL, Windows, Group

USE GimnasioDB;
GO

SELECT 
    name AS RoleName,
    create_date
FROM sys.database_principals
WHERE type = 'R'       -- roles
  AND is_fixed_role = 0  -- excluye roles fijos como db_owner, db_datareader
  AND principal_id > 100
ORDER BY create_date;

SELECT 
    sp.name AS LoginName,
    slr.role_principal_id,
    sr.name AS ServerRole
FROM sys.server_role_members slr
JOIN sys.server_principals sr
    ON slr.role_principal_id = sr.principal_id
JOIN sys.server_principals sp
    ON slr.member_principal_id = sp.principal_id
ORDER BY LoginName;

SELECT 
    dp.name AS PrincipalName,
    dp.type_desc AS PrincipalType,
    perm.permission_name,
    perm.state_desc,
    perm.class_desc,
    OBJECT_NAME(perm.major_id) AS ObjectName
FROM sys.database_permissions perm
JOIN sys.database_principals dp 
    ON perm.grantee_principal_id = dp.principal_id
ORDER BY dp.name;


SELECT 
    sp.name AS LoginName,
    perm.permission_name,
    perm.state_desc
FROM sys.server_permissions perm
JOIN sys.server_principals sp
    ON perm.grantee_principal_id = sp.principal_id
ORDER BY sp.name;


USE GimnasioDB;
GO

SELECT 
    name AS UserName,
    type_desc AS UserType,
    create_date
FROM sys.database_principals
WHERE type IN ('S','U','G')
  AND name NOT IN ('dbo','guest','INFORMATION_SCHEMA','sys')
  AND principal_id > 100
ORDER BY create_date;


SELECT
    'USUARIOS' AS Seccion,
    dp.name AS Usuario,
    dp.type_desc AS TipoUsuario,
    dp.default_schema_name AS EsquemaPorDefecto,
    sp.name AS LoginAsociado,
    dp.create_date AS FechaCreacion,
    'Usuarios existentes en la base de datos.' AS Notas
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp
    ON dp.sid = sp.sid
WHERE dp.type IN ('S','U','G')   -- SQL_USER, WINDOWS_USER, WINDOWS_GROUP
  AND dp.principal_id > 4        -- Excluir dbo, guest, INFORMATION_SCHEMA, sys
ORDER BY dp.name;

SELECT
    'USER_ROLE' AS Seccion,
    m.name AS Usuario,
    r.name AS Rol,
    'Relación entre usuario y rol en la base de datos.' AS Notas
FROM sys.database_role_members drm
JOIN sys.database_principals r
    ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m
    ON drm.member_principal_id = m.principal_id
ORDER BY m.name, r.name;
