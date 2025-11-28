--Exclusivos para core
    ALTER SCHEMA core TRANSFER dbo.Socio
    ALTER SCHEMA core TRANSFER dbo.Membresia
    ALTER SCHEMA core TRANSFER dbo.SocioMembresia
    ALTER SCHEMA core TRANSFER dbo.Pago
GO

--Exclusivos para clases
    ALTER SCHEMA clases TRANSFER dbo.Entrenador
    ALTER SCHEMA clases TRANSFER dbo.Clase
    ALTER SCHEMA clases TRANSFER dbo.HorarioClase
    ALTER SCHEMA clases TRANSFER dbo.Reserva
GO

-- Exclusividades de admin
    ALTER SCHEMA admin TRANSFER dbo.AuditoriaPagos
GO

--Trasladando Exec
    ALTER SCHEMA core TRANSFER dbo.sp_PagosAcumuladosUltimoAnio
    ALTER SCHEMA core TRANSFER dbo.sp_PagosMensuales
    ALTER SCHEMA core TRANSFER dbo.sp_MesesLlenos
GO

ALTER SCHEMA admin TRANSFER dbo.sp_DataDictionary



