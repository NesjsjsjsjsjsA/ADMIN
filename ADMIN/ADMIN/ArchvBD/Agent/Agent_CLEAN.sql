-- Creación del Job CLEAN
USE msdb;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CreateCleanupJob
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @job_id UNIQUEIDENTIFIER;

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'Cleanup_Backups_GimnasioDB')
    BEGIN
        EXEC msdb.dbo.sp_delete_job @job_name = 'Cleanup_Backups_GimnasioDB';
    END

    EXEC msdb.dbo.sp_add_job 
         @job_name = 'Cleanup_Backups_GimnasioDB',
         @enabled = 1,
         @description = 'Eliminar backups antiguos segun retencion',
         @job_id = @job_id OUTPUT;

    EXEC msdb.dbo.sp_add_jobstep
        @job_id = @job_id,
        @step_name = 'Cleanup backups files',
        @subsystem = 'CmdExec',
        @command = N'bash -lc "find /var/opt/mssql/data/backups -type f -name ''GimnasioDB_FULL_*.bak'' -mtime +7 -print -delete; find /var/opt/mssql/data/backups -type f -name ''GimnasioDB_DIFF_*.bak'' -mtime +3 -print -delete; find /var/opt/mssql/data/backups -type f -name ''GimnasioDB_LOG_*.trn'' -mtime +2 -print -delete"',
        @on_success_action = 1,
        @on_fail_action = 2,

        @retry_attempts = 1,
        @retry_interval = 5

    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = 'Schedule_Cleanup_Diario_04')
    BEGIN
        EXEC msdb.dbo.sp_add_schedule
            @schedule_name = 'Schedule_Cleanup_Diario_04',
            @enabled = 1,
            @freq_type = 4,       -- Daily
            @freq_interval = 1,
            @active_start_time = 040000;
    END

    EXEC msdb.dbo.sp_attach_schedule 
        @job_name = 'Cleanup_Backups_GimnasioDB', 
        @schedule_name = 'Schedule_Cleanup_Diario_04';

    EXEC msdb.dbo.sp_add_jobserver 
        @job_name = 'Cleanup_Backups_GimnasioDB', 
        @server_name = '(LOCAL)';

END
GO

EXEC dbo.sp_CreateCleanupJob

EXEC dbo.sp_start_job 'Cleanup_Backups_GimnasioDB';

-- Verificaciones 
SELECT * FROM msdb.dbo.sysjobs WHERE name = 'Cleanup_Backups_GimnasioDB';

SELECT * FROM msdb.dbo.sysschedules WHERE name = 'Schedule_Cleanup_Diario_04';

SELECT * FROM msdb.dbo.sysjobschedules WHERE job_id IN 
    (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = 'Cleanup_Backups_GimnasioDB');
