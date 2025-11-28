--Power BI 
USE GimnasioDB
GO

-- Examinando consultas
SELECT * FROM GimnasioDB.core.Membresia
SELECT * FROM GimnasioDB.clases.Entrenador
SELECT * FROM clases.Clase
SELECT * FROM GimnasioDB.core.Pago ORDER BY id_socio DESC
SELECT * FROM GimnasioDB.clases.Reserva
SELECT * FROM GimnasioDB.core.Socio ORDER BY id_socio DESC
SELECT * FROM GimnasioDB.core.SocioMembresia ORDER BY id_socio DESC
GO

DELETE FROM core.Socio WHERE id_socio = 5001

INSERT INTO core.SocioMembresia (id_socio, id_membresia, fecha_inicio, fecha_fin) Values(1,1, '2024-02-12', '2025-12-28')

INSERT INTO core.Socio (nombre, apellido, fecha_nacimiento, telefono, email, direccion) VALUES ('Julian', 'Casablanca', '1990-09-25', '71971030', 'Xx_juls_xX@mail.com', 'Av Lomas carpincho');

INSERT INTO clases.Reserva (id_socio, id_horario, fecha_reserva) 
   VALUES (60, 1, '2025-12-06' )

-- Las 3 CTE (Solo admin_gym)

EXEC GimnasioDB.core.sp_MesesLlenos

EXEC GimnasioDB.core.sp_PagosAcumuladosUltimoAnio

EXEC GimnasioDB.core.sp_PagosMensuales

GO

--Ediciones hacia las tablas
   EXEC core.sp_registroPago 5001, 3 --Admin_gym y admin_recepcion
   
   EXEC core.sp_AgregarUnSocio 'John', 'Milton', '1880-05-23', '51679030', 'is_john_marston@mail.com', 'Beacher hop', 3, 2 --Por Admin_gym y Admin_recepcion
   
   EXEC clases.sp_modificar_clase 53, 2, 70, 11 --Admin_gym y admin_recepcion
   
   DELETE FROM clases.Entrenador WHERE id_entrenador = 5 --No es posible eliminarlo por el Trigger

