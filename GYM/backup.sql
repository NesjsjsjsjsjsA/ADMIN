BACKUP DATABASE [GimnasioDB]
TO DISK = '/var/opt/mssql/data/backups/GimansioDB_full.bak'
WITH INIT, COMPRESSION, STATS = 5;

BACKUP DATABASE [GimnasioDB]
TO DISK = '/var/opt/mssql/data/backups/GimansioDB_diff.bak'
WITH DIFFERENTIAL, INIT, COMPRESSION, STATS = 5;

BACKUP LOG [GimnasioDB]
TO DISK = '/var/opt/mssql/data/backups/GimansioDB_log.trn'
WITH INIT,COMPRESSION, STATS = 5; 

-- Restauraciones

RESTORE DATABASE [GimnasioDB]
FROM DISK = '/var/opt/mssql/data/backups/GimansioDB_full.bak'
WITH REPLACE, STATS = 5;

RESTORE DATABASE [GimnasioDB] 
FROM DISK = '/var/opt/mssql/data/backups/GimansioDB_diff.bak'
WITH RECOVERY,STATS = 5;

RESTORE LOG pubs
FROM DISK = '/var/opt/mssql/data/backups/GimansioDB_log.trn'
WITH STOPAT = '2025-24-14T21:20:00', RECOVERY, STATS = 5;