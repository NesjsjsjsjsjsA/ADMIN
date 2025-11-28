USE msdb
GO

CREATE OR ALTER PROCEDURE dbo.sp_CreateBackupFullJob
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @job_id UNIQUEIDENTIFIER;

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'BackupFull_GimnasioDB')
    BEGIN
        EXEC msdb.dbo.sp_delete_job @job_name = 'BackupFull_GimnasioDB';
    END

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = 'Schedule_BackupFull_Domingo_00')
    BEGIN
        EXEC msdb.dbo.sp_delete_schedule @schedule_name = 'Schedule_BackupFull_Domingo_00';
    END

EXEC msdb.dbo.sp_add_job 
    @job_name = 'BackupFull_GimnasioDB', 
    @enabled = 1, 
    @description='Backup FULL semanal Domingo', 
    @job_id = @job_id OUTPUT;

EXEC msdb.dbo.sp_add_jobstep
    @job_id = @job_id,
    @step_name = 'Backup FULL',
    @subsystem = 'TSQL',
    @command = N'
DECLARE @file NVARCHAR(260) = N''/var/opt/mssql/data/backups/GimnasioDB_FULL_'' + CONVERT(VARCHAR(8), GETDATE(), 112) + ''.bak'';
BACKUP DATABASE GimnasioDB TO DISK = @file WITH INIT, COMPRESSION;
-- Insert record of success
INSERT INTO msdb.dbo.BackupAudit(job_name, backup_type, backup_file, status)
VALUES (''BackupFull_GimnasioDB'', ''FULL'', @file, ''SUCCESS'');',
    
    @on_success_action = 1,
    @on_fail_action = 2,
    @retry_attempts = 1,
    @retry_interval = 5;

    -- Schedule: weekly Sunday at 00:00
        IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = 'Schedule_BackupFull_Domingo_00')
    BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = 'Schedule_BackupFull_Domingo_00',
        @enabled = 1,
        @freq_type = 8,        -- weekly
        @freq_interval = 1,    -- every week
        @freq_recurrence_factor = 1,
        @active_start_time = 000000,
        @freq_subday_type = 0;

    END

    EXEC msdb.dbo.sp_attach_schedule 
        @job_name = 'BackupFull_GimnasioDB', 
        @schedule_name = 'Schedule_BackupFull_Domingo_00';

    EXEC sp_add_jobserver 
        @job_name = 'BackupFull_GimnasioDB', 
        @server_name = '(LOCAL)';
END

EXEC dbo.sp_CreateBackupFullJob

EXEC dbo.sp_start_job 'BackupFull_GimnasioDB';



