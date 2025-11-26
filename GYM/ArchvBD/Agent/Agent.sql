USE msdb;

--Revisando servicios
SELECT 
    servicename, 
    startup_type_desc, 
    status_desc 
FROM sys.dm_server_services;

--Revisando tamaño
SELECT * FROM dbo.MonitorDbSize;

--Revisar los registros Audits 
SELECT * FROM dbo.BackupAudit

-- Revisar los objetos
SELECT name, enabled, description 
FROM dbo.sysjobs 
    WHERE name LIKE 'Backup%GimnasioDB' OR name LIKE '%Cleanup%' OR name = 'Registro_Tamanio_DB';

--Formato para revisar los jobs
SELECT 
    j.name AS job_name,
    s.name AS schedule_name,
    s.enabled,
    s.freq_type,
    s.freq_interval,
    s.freq_subday_type,
    s.freq_subday_interval,
    s.active_start_time
FROM dbo.sysjobschedules js
JOIN dbo.sysjobs j ON js.job_id = j.job_id
JOIN dbo.sysschedules s ON js.schedule_id = s.schedule_id
WHERE j.name LIKE '%GimnasioDB%' OR j.name LIKE '%Cleanup%';


-- Rrgistrar los 'schedule'
SELECT schedule_id, name 
FROM msdb.dbo.sysschedules
WHERE name LIKE 'Schedule_Backup%';

--Desvinculamiento de tareas

--Creación de los procesos para 'Eliminación de los JOBS'
CREATE OR ALTER PROCEDURE dbo.sp_drop_job_if_exists
        @job_name SYSNAME
AS
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.sysjobs WHERE name = @job_name)
    BEGIN
        EXEC dbo.sp_delete_job @job_name = @job_name;
    END
END

--Borrando todos los objetos 'jobs'
CREATE OR ALTER PROCEDURE dbo.sp_deleteAllUserJobs
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @job_id UNIQUEIDENTIFIER;

    DECLARE cursor_jobs CURSOR FOR
        SELECT job_id
        FROM msdb.dbo.sysjobs
        WHERE name NOT LIKE 'syspolicy%'   -- evita borrar jobs del sistema
          AND name NOT LIKE 'sys%'         -- evita borrar jobs internos
          AND name NOT LIKE 'MS%'          -- evita MSX/TSX
          AND name NOT LIKE 'SQL%'         -- evita jobs de mantenimiento internos
          AND name NOT LIKE 'SSIS%';       -- evita ssis

    OPEN cursor_jobs;
    FETCH NEXT FROM cursor_jobs INTO @job_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC msdb.dbo.sp_delete_job @job_id = @job_id;
        FETCH NEXT FROM cursor_jobs INTO @job_id;
    END

    CLOSE cursor_jobs;
    DEALLOCATE cursor_jobs;

END

--Borrando los 'schedules'
CREATE OR ALTER PROCEDURE dbo.sp_deleteAllschedules
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @schedule_id INT;

    DECLARE cursor_sched CURSOR FOR
        SELECT schedule_id FROM msdb.dbo.sysschedules
        WHERE name NOT LIKE 'Auto%'
        AND name NOT LIKE 'MS%'
        AND name NOT LIKE 'syspolicy%'
        AND name NOT LIKE 'SQL%'
        AND name NOT LIKE 'SSIS%'

OPEN cursor_sched;
FETCH NEXT FROM cursor_sched INTO @schedule_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC msdb.dbo.sp_detach_schedule @schedule_id = @schedule_id;

    EXEC msdb.dbo.sp_delete_schedule @schedule_id = @schedule_id;

    FETCH NEXT FROM cursor_sched INTO @schedule_id;
END

CLOSE cursor_sched;

DEALLOCATE cursor_sched;

END

--Considerando que ya se usa msdb

EXEC dbo.sp_deleteAllUserJobs;
EXEC dbo.sp_deleteAllschedules;

