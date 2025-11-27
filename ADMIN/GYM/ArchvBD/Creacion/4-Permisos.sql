USE GimnasioDB
GO

--- Administrador acceso total ---
GRANT CONTROL ON SCHEMA::dbo TO RolAdministrador;
GRANT CONTROL ON SCHEMA::core TO RolAdministrador
GRANT CONTROL ON SCHEMA::clases TO RolAdministrador
GRANT CONTROL ON SCHEMA::admin TO RolAdministrador
GO

--Permisos adicionales
    GRANT CREATE FUNCTION TO RolAdministrador;
    GRANT CREATE VIEW TO RolAdministrador;
    GRANT CREATE TABLE TO RolAdministrador;
    GRANT CREATE PROCEDURE TO RolAdministrador;


-- Recepción acceso limitado
GRANT SELECT, INSERT, UPDATE ON SCHEMA::core TO RolRecepcion;
GRANT EXECUTE ON SCHEMA::core TO RolRecepcion
GRANT EXECUTE ON SCHEMA::clases TO RolRecepcion

DENY DELETE ON SCHEMA::core TO RolRecepcion;
GRANT SELECT ON SCHEMA::clases TO RolRecepcion;
GO


-- Entrenador acceso limitado
GRANT SELECT ON SCHEMA::clases TO RolEntrenador;
DENY SELECT ON SCHEMA::core TO RolEntrenador;
GO

