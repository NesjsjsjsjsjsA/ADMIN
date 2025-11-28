    USE msdb
    GO
    --Creacion de los JOBS
    EXEC msdb.dbo.sp_CreateBackupFullJob
    EXEC msdb.dbo.sp_CreateBackupDIFFJob
    EXEC msdb.dbo.sp_CreateBackupLOGJob
    EXEC msdb.dbo.sp_CreateCleanupJob
    EXEC msdb.dbo.sp_SeeData

    GO

    --Borrado de los JOBS
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'BackupFull_GimnasioDB';
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'BackupDiff_GimnasioDB';
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'BackupLog_GimnasioDB';
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'Cleanup_Backups_GimnasioDB';
    EXEC msdb.dbo.sp_drop_job_if_exists @job_name = 'Registro_Tamanio_DB';

    GO