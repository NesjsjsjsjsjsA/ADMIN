--SQL Audit para el proyecto

-- Un trigger para las auditorias

CREATE OR ALTER TRIGGER TR_AuditarPagos
ON core.Pago
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    INSERT INTO admin.AuditoriaPagos (id_pago, accion, usuario)
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

