-- Restauraciones
RESTORE DATABASE [GimnasioDB]
FROM DISK = '/var/opt/mssql/data/backups/GimansioDB_full.bak'
WITH REPLACE, STATS = 5;
GO

RESTORE DATABASE [GimnasioDB] 
FROM DISK = '/var/opt/mssql/data/backups/GimansioDB_diff.bak'
WITH RECOVERY,STATS = 5;
GO

RESTORE LOG [GimnasioDB]
FROM DISK = '/var/opt/mssql/data/backups/GimansioDB_log.trn'
WITH STOPAT = '2025-24-14T21:20:00', RECOVERY, STATS = 5;
GO