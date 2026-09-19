-- =========================================
-- 06_views.sql
-- Vistas utiles para reportes y consultas frecuentes
-- Proyecto: AVSA Cañete — Team 08
-- =========================================
USE avsa_db;
GO

-- ── Vista: pedidos activos con totales ───────────────────────
IF OBJECT_ID('dbo.vw_pedidos_activos', 'V') IS NOT NULL
    DROP VIEW dbo.vw_pedidos_activos;
GO

CREATE VIEW dbo.vw_pedidos_activos AS
SELECT
    co.id,
    co.numero_pedido,
    co.customer_id,
    co.customer_razon_social,
    co.fecha_pedido,
    co.estado,
    co.subtotal,
    co.igv,
    co.total,
    co.created_at,
    COUNT(cod.id) AS total_lineas
FROM dbo.customer_orders co
LEFT JOIN dbo.customer_order_details cod ON cod.order_id = co.id
WHERE co.active = 1
GROUP BY
    co.id, co.numero_pedido, co.customer_id, co.customer_razon_social,
    co.fecha_pedido, co.estado, co.subtotal, co.igv, co.total, co.created_at;
GO

-- ── Vista: alertas pendientes con datos del productor ────────
IF OBJECT_ID('dbo.vw_alertas_pendientes', 'V') IS NOT NULL
    DROP VIEW dbo.vw_alertas_pendientes;
GO

CREATE VIEW dbo.vw_alertas_pendientes AS
SELECT
    a.id,
    a.type        AS tipo,
    a.severity    AS severidad,
    a.title       AS titulo,
    a.status      AS estado,
    a.created_at,
    p.full_name   AS productor,
    p.district    AS distrito,
    ag.commercial_name AS agroquimico
FROM dbo.alerts a
LEFT JOIN dbo.producers p     ON p.id  = a.producer_id
LEFT JOIN dbo.agrochemical ag ON ag.id = a.agrochemical_id
WHERE a.status = 'PENDING' AND a.active = 1;
GO

-- ── Vista: aplicaciones de campo con detalle ─────────────────
IF OBJECT_ID('dbo.vw_aplicaciones_campo', 'V') IS NOT NULL
    DROP VIEW dbo.vw_aplicaciones_campo;
GO

CREATE VIEW dbo.vw_aplicaciones_campo AS
SELECT
    fa.id,
    fa.application_date,
    fa.dose,
    fa.dose_unit,
    fa.senasa_valid,
    fa.dose_exceeded,
    p.full_name      AS productor,
    f.name           AS campo,
    pl.code          AS lote,
    ag.commercial_name AS agroquimico,
    u.full_name      AS tecnico
FROM dbo.field_applications fa
JOIN dbo.producers    p  ON p.id  = fa.producer_id
JOIN dbo.fields       f  ON f.id  = fa.field_id
JOIN dbo.production_lots pl ON pl.id = fa.lot_id
JOIN dbo.agrochemical ag ON ag.id = fa.agrochemical_id
JOIN dbo.app_users    u  ON u.id  = fa.technician_id
WHERE fa.active = 1;
GO

PRINT '[SUCCESS] Vistas creadas correctamente.';
GO
