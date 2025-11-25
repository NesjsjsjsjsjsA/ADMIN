USE GimnasioDB;
GO

CREATE SCHEMA core;
CREATE SCHEMA clases;
CREATE SCHEMA admin;
GO

-- Socio, Membresia, SocioMembresia, Pago --

ALTER SCHEMA core TRANSFER dbo.Socio
ALTER SCHEMA core TRANSFER dbo.Membresia
ALTER SCHEMA core TRANSFER dbo.SocioMembresia
ALTER SCHEMA core TRANSFER dbo.Pago

-- Entrenador, Clase, HorarioClase, Reserva --

ALTER SCHEMA clases TRANSFER dbo.Entrenador
ALTER SCHEMA clases TRANSFER dbo.Clase
ALTER SCHEMA clases TRANSFER dbo.HorarioClase
ALTER SCHEMA clases TRANSFER dbo.Reserva

ALTER SCHEMA admin TRANSFER dbo.AuditoriaPagos

SELECT * FROM core.Socio


