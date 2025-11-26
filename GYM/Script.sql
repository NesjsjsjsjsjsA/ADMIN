
-- Trabajo SQL ADMIN 
-- Diccionario de Datos:
-- Politicas de seguirdad (esquemas, roles, Privilegios, usuarios) 
-- 3 consultas con func ventana optimiazarlas 
-- Plan de backup y restauracion
-- Calendario 
-- TAREa SQL con jobs

--Power BI 


-- Examinando consultas

SELECT * FROM GimnasioDB.clases.Clase
SELECT * FROM GimnasioDB.clases.Entrenador
SELECT * FROM GimnasioDB.clases.HorarioClase
SELECT * FROM GimnasioDB.core.Membresia
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
SELECT * FROM msdb.dbo.BackupAudit

    --Creacion de los JOBS
    EXEC msdb.dbo.sp_CreateBackupFullJob
    EXEC msdb.dbo.sp_CreateBackupDIFFJob
    EXEC msdb.dbo.sp_CreateBackupLOGJob
    EXEC msdb.dbo.sp_CreateCleanupJob
    EXEC msdb.dbo.sp_SeeData

    --Borrado de los JOBS
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'BackupFull_GimnasioDB';
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'BackupDiff_GimnasioDB';
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'BackupLog_GimnasioDB';
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'Cleanup_Backups_GimnasioDB';
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'Registro_Tamanio_DB';

