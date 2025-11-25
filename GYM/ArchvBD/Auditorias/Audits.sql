
USE MASTER

-- Creación de la auditoria

CREATE SERVER AUDIT Audit_Socio_GYM
TO FILE (
    FILEPATH = '/var/opt/mssql/data/Auditoria',
    MAXSIZE = 100 MB,
    MAX_ROLLOVER_FILES = 10
)
WITH (
    QUEUE_DELAY = 1000,
    ON_FAILURE = CONTINUE
);

-- por si ocurren problemas

        ALTER SERVER AUDIT Audit_Socio
        WITH (STATE = ON);

                ALTER SERVER AUDIT Audit_Socio WITH (STATE = OFF);

                DROP SERVER AUDIT Audit_Socio;

                SELECT * 
                FROM sys.dm_os_ring_buffers 
                WHERE ring_buffer_type='RING_BUFFER_XE_LOG';

CREATE DATABASE AUDIT SPECIFICATION Audit_Socio_GYM
FOR SERVER AUDIT Audit_Socio_GYM
ADD (INSERT ON GimnasioDB.core.Socio BY public)
WITH (STATE = ON);
GO