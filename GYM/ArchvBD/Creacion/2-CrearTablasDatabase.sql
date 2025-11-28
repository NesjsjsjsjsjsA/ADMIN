USE GimnasioDB;
GO

IF OBJECT_ID('core.Membresia', 'U') IS NULL
BEGIN
    CREATE TABLE Membresia (
        id_membresia INT IDENTITY(1,1) PRIMARY KEY,
        tipo NVARCHAR(50) NOT NULL,
        precio DECIMAL(10,2) NOT NULL,
        duracion_dias INT NOT NULL
    );
END
GO

IF OBJECT_ID('core.Socio', 'U') IS NULL
BEGIN
    CREATE TABLE Socio (
        id_socio INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(50) NOT NULL,
        apellido NVARCHAR(50) NOT NULL,
        fecha_nacimiento DATE,
        telefono NVARCHAR(20),
        email NVARCHAR(100),
        direccion NVARCHAR(150),
        fecha_registro DATE DEFAULT GETDATE(),
        estado BIT DEFAULT 1
    );
END
GO

IF OBJECT_ID('core.SocioMembresia', 'U') IS NULL
BEGIN
    CREATE TABLE SocioMembresia (
        id_socio INT PRIMARY KEY,
        id_membresia INT NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NOT NULL,
        estado BIT DEFAULT 1,
        CONSTRAINT FK_SocioMembresia_Socio FOREIGN KEY (id_socio)
            REFERENCES Socio(id_socio),
        CONSTRAINT FK_SocioMembresia_Membresia FOREIGN KEY (id_membresia)
            REFERENCES Membresia(id_membresia)
    );
END
GO

IF OBJECT_ID('core.Pago','U') IS NULL
BEGIN
    CREATE TABLE Pago (
        id_pago INT IDENTITY(1,1) PRIMARY KEY,
        id_socio INT NOT NULL,
        id_membresia INT NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        fecha_pago DATETIME DEFAULT GETDATE(),
        metodo_pago NVARCHAR(50),
        CONSTRAINT FK_Pago_Socio FOREIGN KEY (id_socio)
            REFERENCES Socio(id_socio),
        CONSTRAINT FK_Pago_Membresia FOREIGN KEY (id_membresia)
            REFERENCES Membresia(id_membresia)
    );
END
GO

IF OBJECT_ID('clases.Entrenador', 'U') IS NULL
BEGIN
    CREATE TABLE Entrenador (
        id_entrenador INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(50) NOT NULL,
        apellido NVARCHAR(50) NOT NULL,
        especialidad NVARCHAR(100),
        telefono NVARCHAR(20),
        email NVARCHAR(100),
        fecha_contratacion DATE DEFAULT GETDATE()
    );
END
GO

IF OBJECT_ID('clases.Clase', 'U') IS NULL
BEGIN
    CREATE TABLE Clase (
        id_clase INT IDENTITY(1,1) PRIMARY KEY,
        nombre_clase NVARCHAR(100) NOT NULL,
        descripcion NVARCHAR(255),
        cupo_maximo INT NOT NULL,
        id_entrenador INT NOT NULL,
        CONSTRAINT FK_Clase_Entrenador FOREIGN KEY (id_entrenador)
            REFERENCES Entrenador(id_entrenador)
    );
END
GO

IF OBJECT_ID('clases.HorarioClase','U') IS NULL
BEGIN
    CREATE TABLE HorarioClase (
        id_horario INT IDENTITY(1,1) PRIMARY KEY,
        id_clase INT NOT NULL,
        dia_semana NVARCHAR(15) NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_fin TIME NOT NULL,
        sala NVARCHAR(50),
        CONSTRAINT FK_HorarioClase_Clase FOREIGN KEY (id_clase)
            REFERENCES Clase(id_clase)
    );
END
GO

IF OBJECT_ID('clases.Reserva', 'U') IS NULL
BEGIN
    CREATE TABLE Reserva (
        id_reserva INT IDENTITY(1,1) PRIMARY KEY,
        id_socio INT NOT NULL,
        id_horario INT NOT NULL,
        fecha_reserva DATE DEFAULT GETDATE(),
        estado BIT DEFAULT 1,
        CONSTRAINT FK_Reserva_Socio FOREIGN KEY (id_socio)
            REFERENCES Socio(id_socio),
        CONSTRAINT FK_Reserva_Horario FOREIGN KEY (id_horario)
            REFERENCES HorarioClase(id_horario)
    );
END
GO

PRINT 'Base de datos GimnasioDB y tablas creadas correctamente.';


-- Para las auditorias
IF OBJECT_ID('admin.AuditoriaPagos', 'U') IS NULL
BEGIN
    CREATE TABLE AuditoriaPagos (
        id_auditoria INT IDENTITY PRIMARY KEY,
        id_pago INT,
        accion NVARCHAR(50),
        fecha DATETIME DEFAULT GETDATE(),
        usuario NVARCHAR(50)
    );
END
GO

IF OBJECT_ID('msdb.dbo.BackupAudit', 'U') IS NULL
BEGIN
    CREATE TABLE msdb.dbo.BackupAudit (
        audit_id INT IDENTITY(1,1) PRIMARY KEY,
        job_name SYSNAME NOT NULL,
        backup_type NVARCHAR(20) NOT NULL,
        backup_file NVARCHAR(260),
        backup_date DATETIME DEFAULT GETDATE(),
        backup_size_mb DECIMAL(12,2) NULL,
        status NVARCHAR(20) NULL,
        message NVARCHAR(4000) NULL
    );
END
GO
IF OBJECT_ID('msdb.dbo.MonitorDbSize', 'U') IS NULL
BEGIN
    CREATE TABLE msdb.dbo.MonitorDbSize (
        id INT IDENTITY(1,1) PRIMARY KEY,
        db_name SYSNAME,
        report_date DATETIME DEFAULT GETDATE(),
        size_mb DECIMAL(12,2)
    );
END
GO
