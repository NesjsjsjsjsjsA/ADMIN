USE master;
GO

--- Creación de Logins!

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'admin_gym')
BEGIN
    CREATE LOGIN admin_gym 
    WITH PASSWORD = 'Admin123*',
    CHECK_POLICY = ON
END
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'recepcion_gym')
BEGIN
    CREATE LOGIN recepcion_gym 
    WITH PASSWORD = 'Recep123*',
    CHECK_POLICY = ON;
END
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'entrenador_gym')
BEGIN
    CREATE LOGIN entrenador_gym 
    WITH PASSWORD = 'Entre123*',
    CHECK_POLICY = ON;
END
GO

---Creación de Usuarios!
USE GimnasioDB;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usuario_admin')
BEGIN
    CREATE USER usuario_admin FOR LOGIN admin_gym;
END
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usuario_recepcion')
BEGIN
    CREATE USER usuario_recepcion FOR LOGIN recepcion_gym;
END
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usuario_entrenador')
BEGIN
    CREATE USER usuario_entrenador FOR LOGIN entrenador_gym;
END
GO

---Creación de Roles!
IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE name ='RolAdministrador')
BEGIN
    CREATE ROLE RolAdministrador;
END
GO

IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE name ='RolRecepcion')
BEGIN
    CREATE ROLE RolRecepcion;
END
GO

IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE name ='RolEntrenador')
BEGIN
    CREATE ROLE RolEntrenador;
END
GO

--Asignación de Roles!
EXEC sp_addrolemember 'RolAdministrador' , 'usuario_admin';
EXEC sp_addrolemember 'RolRecepcion' , 'usuario_recepcion';
EXEC sp_addrolemember 'RolEntrenador' , 'usuario_entrenador';
GO
