USE GimnasioDB;
GO

---Creando los esquemas

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'admin')
    EXEC('CREATE SCHEMA admin')
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'core')
    EXEC('CREATE SCHEMA core');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clases')
    EXEC('CREATE SCHEMA clases')
GO

