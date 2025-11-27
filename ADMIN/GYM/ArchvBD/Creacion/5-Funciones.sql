USE GimnasioDB
GO

    IF OBJECT_ID('clases.sp_modificar_clase') IS NOT NULL
        DROP PROCEDURE clases.sp_modificar_clase
    GO

-- Modificando una clase 
CREATE OR ALTER PROCEDURE clases.sp_modificar_clase
    @id_clase     INT,
    @tipo_clase  INT,
    @cupo_maximo   INT,
    @id_entrenador INT
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @nombre_clase NVARCHAR(100);

    DECLARE @descripcion NVARCHAR(255);

    SET @nombre_clase = CASE @tipo_clase 
                            WHEN 1 THEN 'Spinning'
                            WHEN 2 THEN 'Zumba'
                            WHEN 3 THEN 'HIIT'
                            WHEN 4 THEN 'Body Pump'
                            WHEN 5 THEN 'GAP'
                            WHEN 6 THEN 'Yoga'
                            WHEN 7 THEN 'Pilates'
                            WHEN 8 THEN 'Estiramientos'
                            WHEN 9 THEN 'Body Combat/KickBoxing'
                        END;

    SET @descripcion = CASE @tipo_clase
                            WHEN 1 THEN 'Pedaleo en bicicleta estática con música'
                            WHEN 2 THEN 'Clases de baile con música'
                            WHEN 3 THEN 'Combinación de periodos de ejercicio intenso con descanso breve'
                            WHEN 4 THEN 'Clases grupales con pesas y barras para tonificar el cuerpo'
                            WHEN 5 THEN 'Ejercicios específicos para trabajar glúteos, abdomen, piernas'
                            WHEN 6 THEN 'Combina posturas físicas, respiración y relajación'
                            WHEN 7 THEN 'Se enfoca en fortalecer el centro del cuerpo (core) y mejorar la postura'
                            WHEN 8 THEN 'Para mejorar la flexibilidad y relajar los músculos'
                            WHEN 9 THEN 'Clases que combinan movimientos de artes marciales con música'
                        END;

    IF NOT EXISTS (SELECT 1 FROM clases.Clase WHERE id_clase = @id_clase)
    BEGIN
        THROW 50001, 'id_clase No existe', 1
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM clases.Entrenador WHERE id_entrenador = @id_entrenador)
    BEGIN
        THROW 50002, 'No existe entrenador relacionado', 1
        RETURN;
    END
        IF NOT EXISTS (SELECT 1 FROM clases.Entrenador WHERE especialidad = @nombre_clase)
    BEGIN
        THROW 50003, 'No es posible establecer a un entrenador a esa clase', 1
        RETURN;
    END


    UPDATE clases.Clase
    SET 
        nombre_clase = @nombre_clase,
        descripcion = @descripcion,
        cupo_maximo = @cupo_maximo,
        id_entrenador = @id_entrenador

    WHERE id_clase = @id_clase;
END
GO

    IF OBJECT_ID('core.sp_registroPago') IS NOT NULL
        DROP PROCEDURE core.sp_registroPago
    GO

--Añadir un pago
CREATE OR ALTER PROCEDURE core.sp_registroPago 
    @id_socio INT,
    @formatoPago INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @metodoPago NVARCHAR(50);
    DECLARE @monto DECIMAL(10,2);
    DECLARE @id_membresia INT;

        IF NOT EXISTS (SELECT 1 FROM core.Socio WHERE id_socio = @id_socio)
    BEGIN
        THROW 50001, 'id_socio proporcionado erroneo', 1
        RETURN;
    END

    SET @id_membresia = core.fn_ObtenerMembresia(@id_socio)

    SET @monto = (SELECT precio FROM core.Membresia WHERE id_membresia = @id_membresia)


    SET @metodopago = CASE @formatoPago 
                        WHEN 1 THEN 'Efectivo'
                        WHEN 2 THEN 'Tarjeta'
                        WHEN 3 THEN 'Transaccion'
                        WHEN 4 THEN 'Fiado'
                    END;

INSERT INTO core.Pago (id_socio, id_membresia, monto, metodo_pago)
    VALUES (
        @id_socio, 
        @id_membresia,
        @monto, 
        @metodoPago
        );
END;
GO


    IF OBJECT_ID('core.sp_AgregarUnSocio') IS NOT NULL
        DROP PROCEDURE core.sp_AgregarUnSocio
    GO

-- Insertar Socio y Membresia
CREATE OR ALTER PROCEDURE core.sp_AgregarUnSocio 
    @nombre NVARCHAR(50),
    @apellido NVARCHAR(50),
    @fecha_nacimiento DATE,
    @telefono NVARCHAR(20),
    @email NVARCHAR(100),
    @direccion NVARCHAR(150),
    @membresia INT,
    @Pago INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_socio INT;
    DECLARE @fecha_inicio DATE;
    DECLARE @fecha_fin DATE;

    INSERT INTO core.Socio (nombre, apellido, fecha_nacimiento, telefono, email, direccion)
    VALUES (@nombre, @apellido, @fecha_nacimiento, @telefono, @email, @direccion);

    SET @id_socio = SCOPE_IDENTITY();

    SET @fecha_inicio = GETDATE();
    SET @fecha_fin = DATEADD(MONTH, 1, GETDATE());


    INSERT INTO core.SocioMembresia (id_socio, id_membresia, fecha_inicio, fecha_fin)
    VALUES (@id_socio, @membresia, @fecha_inicio, @fecha_fin);

    EXEC core.sp_registroPago @id_socio, @Pago

END;
GO


    IF OBJECT_ID('core.fn_ObtenerMembresia') IS NOT NULL
        DROP FUNCTION core.fn_ObtenerMembresia
    GO

--Funcion para encontrar una membresia
CREATE OR ALTER FUNCTION core.fn_ObtenerMembresia
(@id_socio INT)
RETURNS INT
AS
BEGIN

    RETURN (
        SELECT TOP 1 id_membresia FROM core.SocioMembresia
            WHERE id_socio = @id_socio ORDER BY id_membresia DESC
    )
END;
GO
