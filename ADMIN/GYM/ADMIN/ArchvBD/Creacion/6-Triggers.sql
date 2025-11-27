
USE GimnasioDB
GO

-- Trigger para evitar socio con mas de una membresia Activa
CREATE OR ALTER TRIGGER core.trg_SocioMembresia_UnicaActiva
ON core.SocioMembresia
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT sm.id_socio
        FROM core.SocioMembresia sm
        INNER JOIN inserted i ON sm.id_socio = i.id_socio
        WHERE sm.estado = 1
        GROUP BY sm.id_socio
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR ('El socio ya tiene una membresía activa.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO


--Crear una membresia luego de un pago
CREATE OR ALTER TRIGGER core.trg_Pago_GeneraMembresia
ON core.Pago
AFTER INSERT
AS
BEGIN
    INSERT INTO core.SocioMembresia 
    (id_socio, id_membresia, fecha_inicio, fecha_fin, estado)
    SELECT 
        i.id_socio,
        i.id_membresia,
        GETDATE(),
        DATEADD(MONTH, 1, GETDATE()),  -- duración 1 mes
        1
    FROM inserted i 
    WHERE NOT EXISTS (
        SELECT 1
        FROM core.SocioMembresia sm
        WHERE sm.id_socio = i.id_socio
            AND sm.estado = 1
    );
END;
GO

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

-- Creación de trigger
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
GO  -- o el nombre del tuyo

