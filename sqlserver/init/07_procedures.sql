-- =========================================
-- 07_procedures.sql
-- Stored procedures de utilidad
-- Proyecto: AVSA Cañete — Team 08
-- =========================================
USE avsa_db;
GO

-- ── sp_soft_delete: eliminacion logica generica ──────────────
IF OBJECT_ID('dbo.sp_soft_delete', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_soft_delete;
GO

CREATE PROCEDURE dbo.sp_soft_delete
    @table NVARCHAR(128),
    @id    BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'UPDATE ' + QUOTENAME(@table) +
               N' SET active = 0, deleted_at = SYSUTCDATETIME(), restored_at = NULL' +
               N' WHERE id = @id;';
    EXEC sp_executesql @sql, N'@id BIGINT', @id;
END
GO

-- ── sp_restore: restauracion logica generica ─────────────────
IF OBJECT_ID('dbo.sp_restore', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_restore;
GO

CREATE PROCEDURE dbo.sp_restore
    @table NVARCHAR(128),
    @id    BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'UPDATE ' + QUOTENAME(@table) +
               N' SET active = 1, restored_at = SYSUTCDATETIME(), deleted_at = NULL' +
               N' WHERE id = @id;';
    EXEC sp_executesql @sql, N'@id BIGINT', @id;
END
GO

-- ── sp_resumen_pedidos_cliente: resumen de pedidos por cliente ──
IF OBJECT_ID('dbo.sp_resumen_pedidos_cliente', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_resumen_pedidos_cliente;
GO

CREATE PROCEDURE dbo.sp_resumen_pedidos_cliente
    @customer_id NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        estado,
        COUNT(*)        AS total_pedidos,
        SUM(total)      AS monto_total,
        MIN(fecha_pedido) AS primer_pedido,
        MAX(fecha_pedido) AS ultimo_pedido
    FROM dbo.customer_orders
    WHERE customer_id = @customer_id AND active = 1
    GROUP BY estado
    ORDER BY total_pedidos DESC;
END
GO

PRINT '[SUCCESS] Stored procedures creados correctamente.';
GO
