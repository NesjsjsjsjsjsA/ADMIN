
CREATE OR ALTER PROCEDURE dbo.sp_CreateBackupDIFFJob
AS
BEGIN
    SET NOCOUNT ON;

DECLARE @job_id UNIQUEIDENTIFIER;

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'BackupDiff_GimnasioDB')
    BEGIN
        EXEC msdb.dbo.sp_delete_job @job_name = 'BackupDiff_GimnasioDB';
    END

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = 'Schedule_BackupDiff_Miercoles_00')
    BEGIN
        EXEC msdb.dbo.sp_delete_schedule @schedule_name = 'Schedule_BackupDiff_Miercoles_00';
    END

EXEC msdb.dbo.sp_add_job 
    @job_name = 'BackupDiff_GimnasioDB', 
    @enabled = 1, 
    @description='Backup DIFFERENTIAL Miércoles 00:00', 
    @job_id = @job_id OUTPUT;

EXEC msdb.dbo.sp_add_jobstep
    @job_id = @job_id,
    @step_name = 'Backup DIFF',
    @subsystem = 'TSQL',
    @command = N'
DECLARE @file NVARCHAR(260) = N''/var/opt/mssql/data/backups/GimnasioDB_DIFF_'' + CONVERT(VARCHAR(8), GETDATE(), 112) + ''.bak'';
BACKUP DATABASE GimnasioDB TO DISK = @file WITH DIFFERENTIAL, COMPRESSION;
INSERT INTO msdb.dbo.BackupAudit(job_name, backup_type, backup_file, status)
VALUES (''BackupDiff_GimnasioDB'', ''DIFFERENTIAL'', @file, ''SUCCESS'');',
    @on_success_action = 1,
    @on_fail_action = 2,
    @retry_attempts = 1,
    @retry_interval = 5;

    -- Schedule: weekly Sunday at 00:00
        IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = 'Schedule_BackupDiff_Miercoles_00')
    BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = 'Schedule_BackupDiff_Miercoles_00',
        @enabled = 1,
        @freq_type = 8,           -- weekly
        @freq_interval = 1,
        @active_start_time = 000000,
        @freq_recurrence_factor = 1,
        @active_start_date = NULL;
    END

    -- attach schedule and register jobserver
    EXEC msdb.dbo.sp_attach_schedule 
        @job_name = 'BackupDiff_GimnasioDB', 
        @schedule_name = 'Schedule_BackupDiff_Miercoles_00';

    EXEC msdb.dbo.sp_add_jobserver 
        @job_name = 'BackupDiff_GimnasioDB', 
        @server_name = '(LOCAL)';
END

EXEC dbo.sp_CreateBackupDIFFJob

EXEC dbo.sp_start_job 'BackupDiff_GimnasioDB';

EXEC dbo.sp_drop_job_if_exists @job_name = 'BackupDiff_GimnasioDB';

EXEC dbo.sp_delete_schedule @schedule_name = 'Schedule_BackupDiff_Miercoles_00'

EXEC msdb.dbo.sp_purge_jobhistory @job_name = 'BackupDiff_GimnasioDB';

EXEC dbo.sp_delete_schedule @schedule_id = 1
