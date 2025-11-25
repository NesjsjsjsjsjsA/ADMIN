--- CREACION DE LOGINS  ---
USE master;
GO

CREATE LOGIN admin_gym 
WITH PASSWORD = 'Admin123*',
CHECK_POLICY = ON

CREATE LOGIN recepcion_gym 
WITH PASSWORD = 'Recep123*',
CHECK_POLICY = ON;

CREATE LOGIN entrenador_gym 
WITH PASSWORD = 'Entre123*',
CHECK_POLICY = ON;
GO

--- CREACION DE USUARIOS EN LA BASE DE DATOS ---
USE GimnasioDB;
GO

CREATE USER usuario_admin FOR LOGIN admin_gym;
CREATE USER usuario_recepcion FOR LOGIN recepcion_gym;
CREATE USER usuario_entrenador FOR LOGIN entrenador_gym;
GO

--- CREACION DE ROLES ---
CREATE ROLE RolAdministrador;
CREATE ROLE RolRecepcion;
CREATE ROLE RolEntrenador;
GO

--- ASIGNACION DE USUARIOS A ROLES ---
EXEC sp_addrolemember 'RolAdministrador' , 'usuario_admin';
EXEC sp_addrolemember 'RolRecepcion' , 'usuario_recepcion';
EXEC sp_addrolemember 'RolEntrenador' , 'usuario_entrenador';
GO

-------- POLITICAS DE SEGURIDAD (PERMISOS) --------

--- Administrador acceso total ---
GRANT CONTROL ON SCHEMA::dbo TO RolAdministrador;
GRANT CONTROL ON SCHEMA::core TO RolAdministrador
GRANT CONTROL ON SCHEMA::clases TO RolAdministrador
GRANT CONTROL ON SCHEMA::admin TO RolAdministrador
GO

--- Recepcion solo gestiona socios pagos y reservas ---
GRANT SELECT, INSERT, UPDATE ON Socio TO RolRecepcion;
GRANT SELECT, INSERT, UPDATE ON Pago TO RolRecepcion;
GRANT SELECT, INSERT, UPDATE ON Reserva TO RolRecepcion;
GRANT SELECT ON Membresia TO RolRecepcion;
DENY DELETE ON Socio TO RolRecepcion;
GO

--- Entrenador solo ve clases y horarios ---
GRANT SELECT ON Clase TO RolEntrenador;
GRANT SELECT ON HorarioClase TO RolEntrenador;
DENY INSERT, UPDATE, DELETE ON Socio TO RolEntrenador;
GO

-- Recepción: puede leer y escribir datos en core
GRANT SELECT, INSERT, UPDATE ON SCHEMA::core TO RolRecepcion;

-- Puede ver clases y horarios (consultar únicamente)
GRANT SELECT ON SCHEMA::clases TO RolRecepcion;

-- No permitir borrar pagos, socios, etc:
DENY DELETE ON SCHEMA::core TO RolRecepcion;
GO

-- Entrenador: solo lectura sobre clases
GRANT SELECT ON SCHEMA::clases TO RolEntrenador;

-- No ver socios, pagos, membresías
DENY SELECT ON SCHEMA::core TO RolEntrenador;
GO



