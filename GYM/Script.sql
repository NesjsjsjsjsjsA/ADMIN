USE GimnasioDB;

-- Examinando consultas

SELECT * FROM GimnasioDB.dbo.Clase
SELECT * FROM GimnasioDB.dbo.Entrenador
SELECT * FROM GimnasioDB.dbo.HorarioClase
SELECT * FROM GimnasioDB.dbo.Membresia
SELECT * FROM GimnasioDB.dbo.Pago
SELECT * FROM GimnasioDB.dbo.Reserva
SELECT * FROM GimnasioDB.dbo.Socio
SELECT * FROM GimnasioDB.dbo.SocioMembresia
GO

--Diccionario de datos
EXEC GimnasioDB.dbo.sp_DataDictionary

-- Las 3 CTE
EXEC GimnasioDB.dbo.sp_PagosAcumuladosUltimoAnio
EXEC GimnasioDB.dbo.sp_PagosMensuales
EXEC GimnasioDB.dbo.sp_MesesLlenos


--

