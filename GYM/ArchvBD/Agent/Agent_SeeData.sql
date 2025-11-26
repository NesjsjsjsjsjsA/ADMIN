-- Creación del Job SeeData

CREATE OR ALTER PROCEDURE dbo.sp_SeeData
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @job_id UNIQUEIDENTIFIER;

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'Registro_Tamanio_DB')
    BEGIN
        EXEC msdb.dbo.sp_delete_job @job_name = 'Registro_Tamanio_DB';
    END

EXEC msdb.dbo.sp_add_job 
    @job_name = 'Registro_Tamanio_DB', 
    @enabled = 1, 
    @description='Registra tamano de GimnasioDB cada 6 horas', 
    @job_id = @job_id OUTPUT;

EXEC msdb.dbo.sp_add_jobstep
    @job_id = @job_id,
    @step_name = 'Registrar Tamaño',
    @subsystem = 'TSQL',
    @command = N'
INSERT INTO msdb.dbo.MonitorDbSize (db_name, report_date, size_mb)
SELECT DB_NAME(database_id),
       GETDATE(),
       SUM(size)*8.0/1024
FROM sys.master_files
WHERE DB_NAME(database_id) = ''GimnasioDB''
GROUP BY database_id;
',
    @on_success_action = 1,
    @on_fail_action = 2,
    @retry_attempts = 1,
    @retry_interval = 5;

-- schedule every 6 hours
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = 'Schedule_Monitor_6Horas')
BEGIN 
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name='Schedule_Monitor_6Horas',
        @enabled = 1,
        @freq_type=4,
        @freq_interval=1,
        @freq_subday_type=8,        -- hours
        @freq_subday_interval=6,    -- cada 6 horas
        @active_start_time=000000;
END
    EXEC msdb.dbo.sp_attach_schedule 
        @job_name='Registro_Tamanio_DB', 
        @schedule_name='Schedule_Monitor_6Horas';

    EXEC sp_add_jobserver 
        @job_name='Registro_Tamanio_DB', 
        @server_name='(LOCAL)';

END

EXEC dbo.sp_SeeData

EXEC dbo.sp_start_job 'Registro_Tamanio_DB';

EXEC dbo.sp_drop_job_if_exists @job_name = 'Registro_Tamanio_DB';

EXEC dbo.sp_delete_schedule @schedule_id = 1

