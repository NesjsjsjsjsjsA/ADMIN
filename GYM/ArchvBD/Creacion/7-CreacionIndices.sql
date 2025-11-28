USE GimnasioDB;
GO

---Borrando los índices por si acaso

-- Índice de Pago: IX_Pago_Socio_Fecha_IdPago_Cover
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

-- Índice de Pago: IX_pago_Membresia_Fecha
IF EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_pago_Membresia_Fecha'
      AND object_id = OBJECT_ID('core.Pago')
)
BEGIN
    DROP INDEX IX_pago_Membresia_Fecha ON core.Pago;
END
GO

-- Índice de Reserva: IX_Reserva_Fecha_Horario
IF EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_Reserva_Fecha_Horario'
      AND object_id = OBJECT_ID('clases.Reserva')
)
BEGIN
    DROP INDEX IX_Reserva_Fecha_Horario ON clases.Reserva;
END
GO

---Creando los índices


-- Índice para búsquedas por socio/fecha/pago + columnas útiles
CREATE NONCLUSTERED INDEX IX_Pago_Socio_Fecha_IdPago_Cover
ON core.Pago (id_socio, fecha_pago, id_pago)
INCLUDE (monto, id_membresia, metodo_pago);
GO

-- Índice para búsquedas por membresía/fecha
CREATE NONCLUSTERED INDEX IX_pago_Membresia_Fecha
ON core.Pago (id_membresia, fecha_pago)
INCLUDE (monto);
GO

-- Índice para reservas por fecha/horario
CREATE NONCLUSTERED INDEX IX_Reserva_Fecha_Horario
ON clases.Reserva (fecha_reserva, id_horario)
INCLUDE (id_socio);
GO
