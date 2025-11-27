USE GimnasioDB
GO

  IF OBJECT_ID('core.sp_PagosAcumuladosUltimoAnio') IS NOT NULL
    DROP PROCEDURE core.sp_PagosAcumuladosUltimoAnio
  GO

-- 1- Que hace: muestra para cada pago el total acumulado de lo pagado por ese socio hasta ese momento
CREATE OR ALTER PROCEDURE core.sp_PagosAcumuladosUltimoAnio
AS 
BEGIN
  -- Consulta: total acumulado por socio ordenado por id_socio, fecha_pago, id_pago
  DECLARE @desde DATETIME = DATEADD(YEAR, -1, CAST(GETDATE() AS DATE));
  DECLARE @hasta DATETIME =
      DATEADD(MILLISECOND, -3, DATEADD(DAY, 1, CAST(GETDATE() AS DATETIME)));

  WITH pagos AS (
    SELECT id_pago, id_socio, fecha_pago, monto
    FROM core.Pago
    WHERE fecha_pago BETWEEN @desde AND @hasta
  )
  SELECT
    id_socio,
    id_pago,
    fecha_pago,
    monto,
    SUM(monto) OVER (
      PARTITION BY id_socio
      ORDER BY fecha_pago, id_pago
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS acumulado_hasta_fecha
  FROM pagos
  ORDER BY id_socio, fecha_pago, id_pago;
END
GO

  IF OBJECT_ID('core.sp_PagosMensuales') IS NOT NULL
    DROP PROCEDURE core.sp_PagosMensuales
  GO

-- Consulta: total mensual por membresia y media movil 3-meses(la media del total recaudado en los ultimos 3 meses)
CREATE OR ALTER PROCEDURE core.sp_PagosMensuales
AS 
BEGIN
  WITH pagos_mensuales AS (
    SELECT
      id_membresia,
      YEAR(fecha_pago) AS año,
      MONTH(fecha_pago) AS mes,
      SUM(monto) AS total_mes,
      --fecha representativa del mes para ordenar
      DATEFROMPARTS(YEAR(fecha_pago), MONTH(fecha_pago), 1) AS primera_del_mes
    FROM core.Pago
    GROUP BY id_membresia, YEAR(fecha_pago), MONTH(fecha_pago), DATEFROMPARTS(YEAR(fecha_pago), MONTH(fecha_pago), 1)
  )
  SELECT
    id_membresia,
    año,
    mes,
    total_mes,
    ROUND(
      AVG(total_mes) OVER (
        PARTITION BY id_membresia
        ORDER BY primera_del_mes
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
      ), 2) AS moving_avg_3m
  FROM pagos_mensuales
  ORDER BY id_membresia, año, mes;
END
GO


  IF OBJECT_ID('core.sp_MesesLlenos') IS NOT NULL
    DROP PROCEDURE core.sp_MesesLlenos
  GO

SELECT count(*) FROM clases.Reserva
GO

SELECT * FROM clases.Reserva
GO

--3- Consulta: meses más llenos usando PERCENT_RANK()
CREATE OR ALTER PROCEDURE core.sp_MesesLlenos
AS 
BEGIN
  --CONSLUTA	
  WITH por_mes AS (
      SELECT
          DATEFROMPARTS(YEAR(fecha_reserva), MONTH(fecha_reserva), 1) AS Mes,
          COUNT(*) AS total_reservas
      FROM clases.Reserva
      WHERE fecha_reserva >= DATEADD(YEAR, -1, CAST(GETDATE() AS DATE))  -- Ultimos 12 meses
      GROUP BY DATEFROMPARTS(YEAR(fecha_reserva), MONTH(fecha_reserva), 1)
  )
  SELECT 
      mes,
      total_reservas,
      PERCENT_RANK() OVER (ORDER BY total_reservas) AS pct_rank_mes
  FROM por_mes
  ORDER BY total_reservas DESC;
END
GO


--pct_rank_mes = que tan lleno esta ese mes comparado con los demas:
--1.= mes más lleno de todos
--0.50 = mes medio
--0 = mes con menos reservas









