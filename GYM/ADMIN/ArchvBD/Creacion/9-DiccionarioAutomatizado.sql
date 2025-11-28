
    IF OBJECT_ID('admin.admin.sp_DataDictionary') IS NOT NULL
        DROP PROCEDURE admin.sp_DataDictionary
    GO

-- Creacion de Diccionario
CREATE OR ALTER PROCEDURE admin.sp_DataDictionary 
AS
BEGIN
    SELECT 
        'COLUMNAS' AS Seccion,
        TABLE_SCHEMA,
        TABLE_NAME,
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        CHARACTER_MAXIMUM_LENGTH,
        COLUMN_DEFAULT,
        CASE 
            WHEN COLUMN_DEFAULT IS NOT NULL 
                THEN 'Tiene valor por defecto.'
            WHEN IS_NULLABLE = 'NO'
                THEN 'Dato obligatorio.'
            ELSE 'Dato opcional.'
        END AS Notas
    FROM INFORMATION_SCHEMA.COLUMNS
    ORDER BY TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME;

    SELECT 
        'PRIMARY_KEY' AS Seccion,
        TC.TABLE_NAME,
        KU.COLUMN_NAME,
        'Columna única que identifica a cada registro.' AS Notas
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
    JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KU
        ON TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
    WHERE TC.CONSTRAINT_TYPE = 'PRIMARY KEY';

    SELECT 
        'FOREIGN_KEY' AS Seccion,
        FK.NAME AS FK,
        OBJECT_NAME(FKC.parent_object_id) AS TablaHija,
        C1.name AS ColumnaHija,
        OBJECT_NAME(FKC.referenced_object_id) AS TablaPadre,
        C2.name AS ColumnaPadre,
        'Relaciona la tabla hija con la tabla padre.' AS Notas
    FROM sys.foreign_keys FK
    JOIN sys.foreign_key_columns FKC
        ON FK.object_id = FKC.constraint_object_id
    JOIN sys.columns C1
        ON FKC.parent_object_id = C1.object_id 
        AND FKC.parent_column_id = C1.column_id
    JOIN sys.columns C2
        ON FKC.referenced_object_id = C2.object_id 
        AND FKC.referenced_column_id = C2.column_id;

    SELECT
        'INDEX' AS Seccion,
        t.name AS Tabla,
        ind.name AS Indice,
        ind.type_desc AS Tipo,
        'Optimiza la búsqueda y ordenamiento.' AS Notas
    FROM sys.indexes ind
    INNER JOIN sys.tables t ON ind.object_id = t.object_id
    WHERE ind.is_primary_key = 0 AND ind.is_unique_constraint = 0;

    SELECT 
        'TRIGGER' AS Seccion,
        tr.name AS TriggerName,
        t.name AS Tabla,
        m.definition AS Definicion,
        'Ejecuta acciones automáticas cuando ocurre INSERT, UPDATE o DELETE.' AS Notas
    FROM sys.triggers tr
    INNER JOIN sys.tables t ON tr.parent_id = t.object_id
    INNER JOIN sys.sql_modules m ON tr.object_id = m.object_id;

    SELECT
        'FUNCIONES' AS Seccion,
        o.name AS NombreFuncion,
        m.definition AS Codigo,
        'Función definida por el usuario.' AS Notas
    FROM sys.objects o
    INNER JOIN sys.sql_modules m ON o.object_id = m.object_id
    WHERE o.type IN ('FN', 'IF', 'TF'); 

    SELECT 
        'JOB' AS Seccion,
        j.name AS NombreJob,
        'Job programado en SQL Server Agent.' AS Notas
    FROM msdb.dbo.sysjobs j;

    SELECT
    'LOG' AS Seccion,
    DB_NAME(database_id) AS BaseDeDatos,
    total_log_size_mb AS LogSizeMB,
    active_log_size_mb AS LogActivoMB,
    log_truncation_holdup_reason AS MotivoNoTruncado,
    'Uso y estado del archivo de log.' AS Notas
FROM sys.dm_db_log_stats(DB_ID());

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

SELECT
    'USER_PERMISSIONS' AS Seccion,
    dp.name AS Usuario,
    perm.permission_name AS Permiso,
    perm.state_desc AS Estado,
    obj.name AS Objeto,
    'Permisos asignados directamente al usuario.' AS Notas
FROM sys.database_permissions perm
JOIN sys.database_principals dp
    ON perm.grantee_principal_id = dp.principal_id
LEFT JOIN sys.objects obj
    ON perm.major_id = obj.object_id
WHERE dp.type IN ('S','U','G')
ORDER BY dp.name, perm.permission_name;


    SELECT
    'SCHEMA' AS Seccion, name
    FROM GimnasioDB.sys.schemas 
        WHERE schema_id >= 5 AND schema_id <= 100


END;
GO

EXEC admin.sp_DataDictionary
