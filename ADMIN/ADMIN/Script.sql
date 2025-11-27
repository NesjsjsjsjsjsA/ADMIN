
-- Trabajo SQL ADMIN 
-- Diccionario de Datos:
-- Politicas de seguirdad (esquemas, roles, Privilegios, usuarios) 
-- 3 consultas con func ventana optimiazarlas 
-- Plan de backup y restauracion
-- Calendario 
-- TAREa SQL con jobs

--Power BI 

-- Examinando consultas
SELECT * FROM GimnasioDB.core.Membresia
SELECT * FROM GimnasioDB.clases.Entrenador
SELECT * FROM GimnasioDB.core.Pago
SELECT * FROM GimnasioDB.clases.Reserva
SELECT * FROM GimnasioDB.core.Socio
SELECT * FROM GimnasioDB.core.SocioMembresia
GO


--Diccionario de datos
EXEC GimnasioDB.admin.sp_DataDictionary

--Roles sistema

-- Las 3 CTE
EXEC GimnasioDB.core.sp_PagosAcumuladosUltimoAnio
EXEC GimnasioDB.core.sp_PagosMensuales
EXEC GimnasioDB.core.sp_MesesLlenos

--Trabajos con los JOBS

EXEC clases.sp_registroPago 3, 1
EXEC clases.sp_registroPago 15, 2
EXEC clases.sp_registroPago 16, 3
EXEC clases.sp_registroPago 32, 2
EXEC clases.sp_registroPago 18, 1

EXEC clases.sp_modificar_clase 33, 7, 12, 2
SELECT * FROM GimnasioDB.clases.Clase

INSERT INTO clases.clase (nombre_clase, descripcion, cupo_maximo, id_entrenador) 
    VALUES ('Pechadas Intensas', 'Hora de ver tu potencial completo', 70, 80)


