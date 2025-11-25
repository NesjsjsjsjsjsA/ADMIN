CREATE DATABASE GimnasioDB;
GO

USE GimnasioDB;
GO

-- ========================================
-- TABLA: Membresia
-- ========================================
CREATE TABLE Membresia (
    id_membresia INT IDENTITY(1,1) PRIMARY KEY,
    tipo NVARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    duracion_dias INT NOT NULL
);
GO

-- ========================================
-- TABLA: Socio
-- ========================================
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
GO

-- ========================================
-- TABLA: SocioMembresia
-- ========================================
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
GO

-- ========================================
-- TABLA: Pago
-- ========================================
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
GO

-- ========================================
-- TABLA: Entrenador
-- ========================================
CREATE TABLE Entrenador (
    id_entrenador INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    apellido NVARCHAR(50) NOT NULL,
    especialidad NVARCHAR(100),
    telefono NVARCHAR(20),
    email NVARCHAR(100),
    fecha_contratacion DATE DEFAULT GETDATE()
);
GO

-- ========================================
-- TABLA: Clase
-- ========================================
CREATE TABLE Clase (
    id_clase INT IDENTITY(1,1) PRIMARY KEY,
    nombre_clase NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255),
    cupo_maximo INT NOT NULL,
    id_entrenador INT NOT NULL,
    CONSTRAINT FK_Clase_Entrenador FOREIGN KEY (id_entrenador)
        REFERENCES Entrenador(id_entrenador)
);
GO

-- ========================================
-- TABLA: HorarioClase
-- ========================================
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
GO

-- ========================================
-- TABLA: Reserva
-- ========================================
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
GO

PRINT 'Base de datos GimnasioDB y tablas creadas correctamente.';


-- Para las auditorias

CREATE TABLE AuditoriaPagos (
    id_auditoria INT IDENTITY PRIMARY KEY,
    id_pago INT,
    accion NVARCHAR(50),
    fecha DATETIME DEFAULT GETDATE(),
    usuario NVARCHAR(50)
);


-- Diccionario de Datos:
-- Politicas de seguirdad (esquemas, roles, oreivilegios, usuarios) 
-- 3 consultas con func ventana optiimiazarlas 
-- Plan de backup y restauracion
-- Calendario 
-- TAREa SQL con jobs

--Power BI 