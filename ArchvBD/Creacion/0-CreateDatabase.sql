USE master
GO

IF DB_ID('GimnasioDB') IS NULL
    BEGIN 
        CREATE DATABASE GimnasioDB;
    END

    ELSE 
    BEGIN
        PRINT 'Ya existe la base de datos'
    END
GO
