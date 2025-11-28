USE MASTER
GO

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

    ALTER SERVER AUDIT Audit_Socio_GYM
    WITH (STATE = ON);
GO


USE GimnasioDB
GO

CREATE DATABASE AUDIT SPECIFICATION Audit_Socio_GYM
    FOR SERVER AUDIT Audit_Socio_GYM
    ADD (INSERT ON GimnasioDB.core.Socio BY public)
    WITH (STATE = ON);
GO

--Para ir revisando!

SELECT name, is_state_enabled
FROM sys.database_audit_specifications;


SELECT *
FROM sys.fn_get_audit_file('/var/opt/mssql/data/Auditoria/*', DEFAULT, DEFAULT);


SELECT *
FROM sys.fn_get_audit_file('/var/opt/mssql/data/Auditoria/*', DEFAULT, DEFAULT);
