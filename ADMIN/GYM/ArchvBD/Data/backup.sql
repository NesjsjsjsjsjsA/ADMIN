BACKUP DATABASE [GimnasioDB]
TO DISK = '/var/opt/mssql/data/backups/GimansioDB_full.bak'
WITH INIT, COMPRESSION, STATS = 5;
GO

BACKUP DATABASE [GimnasioDB]
TO DISK = '/var/opt/mssql/data/backups/GimansioDB_diff.bak'
WITH DIFFERENTIAL, INIT, COMPRESSION, STATS = 5;
GO

BACKUP LOG [GimnasioDB]
TO DISK = '/var/opt/mssql/data/backups/GimansioDB_log.trn'
WITH INIT,COMPRESSION, STATS = 5; 
GO