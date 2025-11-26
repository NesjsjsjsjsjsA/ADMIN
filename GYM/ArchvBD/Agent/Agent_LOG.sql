
CREATE OR ALTER PROCEDURE dbo.sp_CreateBackupLOGJob
AS
BEGIN
    SET NOCOUNT ON;

DECLARE @job_id UNIQUEIDENTIFIER;

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'BackupLog_GimnasioDB')
    BEGIN
        EXEC msdb.dbo.sp_delete_job @job_name = 'BackupLog_GimnasioDB';
    END

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = 'Schedule_BackupLog_15min')
    BEGIN
        EXEC msdb.dbo.sp_delete_schedule @schedule_name = 'Schedule_BackupLog_15min';
    END

EXEC msdb.dbo.sp_add_job 
    @job_name = 'BackupLog_GimnasioDB', 
    @enabled = 1, 
    @description = 'Backup LOG cada 15 minutos', 
    @job_id = @job_id OUTPUT;

EXEC msdb.dbo.sp_add_jobstep
    @job_id = @job_id,
    @step_name = 'Backup LOG',
    @subsystem = 'TSQL',
    @command = N'
DECLARE @file NVARCHAR(260) = N''/var/opt/mssql/data/backups/GimnasioDB_LOG_'' 
    + CONVERT(VARCHAR(8), GETDATE(), 112) + ''_'' + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), '':'', '''') + ''.trn'';
BACKUP LOG GimnasioDB TO DISK = @file WITH COMPRESSION;
INSERT INTO msdb.dbo.BackupAudit(job_name, backup_type, backup_file, status)
VALUES (''BackupLog_GimnasioDB'', ''LOG'', @file, ''SUCCESS'');',
    @on_success_action = 1,
    @on_fail_action = 2,
    @retry_attempts = 1,
    @retry_interval = 5;

        IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = 'Schedule_BackupLog_15min')
    BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = 'Schedule_BackupLog_15min',
        @enabled = 1,
        @freq_type = 4,
        @freq_interval = 1,
        @freq_subday_type = 4,
        @freq_subday_interval = 15,
        @active_start_time = 000000;
    END

    EXEC msdb.dbo.sp_attach_schedule 
        @job_name = 'BackupLog_GimnasioDB', 
        @schedule_name = 'Schedule_BackupLog_15min';
    EXEC msdb.dbo.sp_add_jobserver 
        @job_name = 'BackupLog_GimnasioDB', 
        @server_name = '(LOCAL)';

END

EXEC dbo.sp_CreateBackupLOGJob

EXEC dbo.sp_start_job 'BackupLog_GimnasioDB';
EXEC dbo.sp_drop_job_if_exists @job_name = 'BackupLog_GimnasioDB';
EXEC dbo.sp_purge_jobhistory @job_name = 'BackupLog_GimnasioDB';
EXEC dbo.sp_delete_schedule @schedule_name = 'Schedule_BackupLog_15min'

EXEC dbo.sp_delete_schedule @schedule_id = 1


