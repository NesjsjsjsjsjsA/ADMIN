CREATE OR ALTER PROCEDURE sp_DataDictionary AS
BEGIN
    -- Columnas
    SELECT 
        'COLUMNAS' AS Seccion,
        TABLE_SCHEMA,
        TABLE_NAME,
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    ORDER BY TABLE_SCHEMA, TABLE_NAME;

    -- Llave primaria
    SELECT 
        'PRIMARY_KEY' AS Seccion,
        TC.TABLE_NAME,
        KU.COLUMN_NAME
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
    JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KU
        ON TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
    WHERE TC.CONSTRAINT_TYPE = 'PRIMARY KEY';

    -- Llaves foráneas
    SELECT 
        'FOREIGN_KEY' AS Seccion,
        FK.NAME AS FK,
        OBJECT_NAME(FKC.parent_object_id) AS TablaHija,
        C1.name AS ColumnaHija,
        OBJECT_NAME(FKC.referenced_object_id) AS TablaPadre,
        C2.name AS ColumnaPadre
    FROM sys.foreign_keys FK
    JOIN sys.foreign_key_columns FKC
        ON FK.object_id = FKC.constraint_object_id
    JOIN sys.columns C1
        ON FKC.parent_object_id = C1.object_id 
        AND FKC.parent_column_id = C1.column_id
    JOIN sys.columns C2
        ON FKC.referenced_object_id = C2.object_id 
        AND FKC.referenced_column_id = C2.column_id;

    -- Check constraints
    SELECT 
        'CHECK' AS Seccion,
        OBJECT_NAME(parent_object_id) AS Tabla,
        name AS Restriccion,
        definition AS Regla
    FROM sys.check_constraints;
END;
