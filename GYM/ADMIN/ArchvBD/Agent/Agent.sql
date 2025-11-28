USE msdb;
GO

IF OBJECT_ID('dbo.sp_drop_job_if_exists') IS NOT NULL
    DROP PROCEDURE dbo.sp_drop_job_if_exists;
GO

CREATE OR ALTER PROCEDURE dbo.sp_drop_job_if_exists
    @job_name SYSNAME
AS
BEGIN
    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @job_name)
        EXEC msdb.dbo.sp_delete_job @job_name = @job_name;
END
GO

IF OBJECT_ID('dbo.sp_deleteAllUserJobs') IS NOT NULL
    DROP PROCEDURE dbo.sp_deleteAllUserJobs;
GO

CREATE OR ALTER PROCEDURE dbo.sp_deleteAllUserJobs
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @job_id UNIQUEIDENTIFIER;

    DECLARE cursor_jobs CURSOR FOR
        SELECT job_id
        FROM msdb.dbo.sysjobs
        WHERE enabled = 1
          AND category_id <> 101         -- evita System Jobs
          AND name NOT LIKE 'syspolicy%' -- evita syspolicy
          AND name NOT LIKE 'SQLAgent%'  -- evita SQLAgent
          AND name NOT LIKE 'MS%'        -- evita Microsoft jobs
          AND name NOT LIKE 'SSIS%';     -- evita SSIS

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
GO

IF OBJECT_ID('dbo.sp_deleteAllSchedules') IS NOT NULL
    DROP PROCEDURE dbo.sp_deleteAllSchedules;
GO

CREATE OR ALTER PROCEDURE dbo.sp_deleteAllSchedules
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @schedule_id INT;

    DECLARE cursor_sched CURSOR FOR
        SELECT schedule_id
        FROM msdb.dbo.sysschedules
        WHERE name NOT LIKE 'Auto%'
          AND name NOT LIKE 'MS%'
          AND name NOT LIKE 'syspolicy%'
          AND name NOT LIKE 'SQL%'
          AND name NOT LIKE 'SSIS%';

    OPEN cursor_sched;
    FETCH NEXT FROM cursor_sched INTO @schedule_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC msdb.dbo.sp_delete_schedule @schedule_id = @schedule_id;

        FETCH NEXT FROM cursor_sched INTO @schedule_id;
    END

    CLOSE cursor_sched;
    DEALLOCATE cursor_sched;
END
GO