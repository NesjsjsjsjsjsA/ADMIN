USE GimnasioDB
GO

IF EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_Pago_Socio_Fecha_IdPago_Cover'
      AND object_id = OBJECT_ID('core.Pago')
)
BEGIN
    DROP INDEX IX_Pago_Socio_Fecha_IdPago_Cover ON core.Pago;
END
GO


  CREATE NONCLUSTERED INDEX IX_Pago_Socio_Fecha_IdPago_Cover
  ON core.Pago (id_socio, fecha_pago, id_pago)
  INCLUDE (monto, id_membresia, metodo_pago);
GO

IF EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_Reserva_Fecha_Horario'
      AND object_id = OBJECT_ID('clases.Reserva')
)
BEGIN
    DROP INDEX IX_Pago_Socio_Fecha_IdPago_Cover ON core.Pago;
END
GO

  CREATE NONCLUSTERED INDEX IX_Reserva_Fecha_Horario
  ON clases.Reserva (fecha_reserva, id_horario)
  INCLUDE (id_socio);
GO


