
USE GimnasioDB
GO

-- Eliminar los trigger si ya existe

IF OBJECT_ID('clases.trg_Entrenador_NoEliminarConClases', 'TR') IS NOT NULL
    DROP TRIGGER clases.trg_Entrenador_NoEliminarConClases;
GO

IF OBJECT_ID('clases.trg_Reserva_ValidarMembresia', 'TR') IS NOT NULL
    DROP TRIGGER clases.trg_Reserva_ValidarMembresia;
GO

IF OBJECT_ID('core.TR_AuditarPagos', 'TR') IS NOT NULL
    DROP TRIGGER core.TR_AuditarPagos;
GO

-- Creación de los Triggers

-- Evitar la eliminacion de entrenadores con clases asignadas
CREATE OR ALTER TRIGGER clases.trg_Entrenador_NoEliminarConClases
ON clases.Entrenador
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM clases.Clase c
        INNER JOIN deleted d ON c.id_entrenador = d.id_entrenador
    )
    BEGIN
        RAISERROR('No se puede eliminar el entrenador porque tiene clases asignadas.', 16, 1);
        RETURN;
    END

    DELETE FROM clases.Entrenador
    WHERE id_entrenador IN (SELECT id_entrenador FROM deleted);
END;
GO

-- Evitar reserva si No es socio
CREATE OR ALTER TRIGGER clases.trg_Reserva_ValidarMembresia
ON clases.Reserva
AFTER INSERT
AS
BEGIN
    IF EXISTS(
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1
            FROM core.SocioMembresia sm
            WHERE sm.id_socio = i.id_socio
              AND sm.estado = 1
        )
    )
    BEGIN
        RAISERROR ('El socio no tiene una membresía activa.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END
END;
GO

-- Creación de trigger para auditorias
CREATE OR ALTER TRIGGER core.TR_AuditarPagos
ON core.Pago
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    INSERT INTO admin.AuditoriaPagos 
    (id_pago, accion, usuario)
    SELECT 
        COALESCE(i.id_pago, d.id_pago),
        CASE 
            WHEN i.id_pago IS NOT NULL AND d.id_pago IS NULL THEN 'INSERT'
            WHEN i.id_pago IS NOT NULL AND d.id_pago IS NOT NULL THEN 'UPDATE'
            WHEN i.id_pago IS NULL AND d.id_pago IS NOT NULL THEN 'DELETE'
        END,
        SYSTEM_USER
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.id_pago = d.id_pago;
END;
GO 

