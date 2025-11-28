USE msdb
GO

--Revisando tamaño 
SELECT * FROM msdb.dbo.MonitorDbSize; 
GO

-- Revisando los registros Audits
SELECT * FROM msdb.dbo.BackupAudit
GO

-- Revisando los objetos
SELECT name, enabled, description 
FROM msdb.dbo.sysjobs 
WHERE name LIKE 'Backup%GimnasioDB' OR name LIKE '%Cleanup%' OR name = 'Registro_Tamanio_DB'; 
GO
--Formato para revisar los jobs 
SELECT j.name AS job_name, s.name AS schedule_name, s.enabled, s.freq_type, s.freq_interval, s.freq_subday_type, s.freq_subday_interval, s.active_start_time 
FROM dbo.sysjobschedules js JOIN dbo.sysjobs j ON js.job_id = j.job_id JOIN dbo.sysschedules s ON js.schedule_id = s.schedule_id WHERE j.name LIKE '%GimnasioDB%' OR j.name LIKE '%Cleanup%'; 
GO

--Revisando los 'schedules'
SELECT schedule_id, name 
FROM msdb.dbo.sysschedules WHERE name LIKE 'Schedule_Backup%'; 
GO

USE GimnasioDB
GO
SELECT * FROM admin.AuditoriaPagos
GO