-- =========================================
-- 05_indexes.sql
-- Indices para optimizacion de consultas frecuentes
-- Proyecto: AVSA Cañete — Team 08
-- =========================================
USE avsa_db;
GO

-- fields
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_fields_producer_id')
    CREATE INDEX IX_fields_producer_id ON dbo.fields(producer_id);
GO

-- production_lots
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_production_lots_field_id')
    CREATE INDEX IX_production_lots_field_id ON dbo.production_lots(field_id);
GO

-- field_applications
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_field_app_producer_id')
    CREATE INDEX IX_field_app_producer_id ON dbo.field_applications(producer_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_field_app_field_id')
    CREATE INDEX IX_field_app_field_id ON dbo.field_applications(field_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_field_app_lot_id')
    CREATE INDEX IX_field_app_lot_id ON dbo.field_applications(lot_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_field_app_agrochemical_id')
    CREATE INDEX IX_field_app_agrochemical_id ON dbo.field_applications(agrochemical_id);
GO

-- inventory_deliveries
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_inv_del_producer_id')
    CREATE INDEX IX_inv_del_producer_id ON dbo.inventory_deliveries(producer_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_inv_del_agrochemical_id')
    CREATE INDEX IX_inv_del_agrochemical_id ON dbo.inventory_deliveries(agrochemical_id);
GO

-- alerts
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_alerts_producer_id')
    CREATE INDEX IX_alerts_producer_id ON dbo.alerts(producer_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_alerts_status')
    CREATE INDEX IX_alerts_status ON dbo.alerts(status);
GO

-- customer_orders
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_co_customer_id')
    CREATE INDEX IX_co_customer_id ON dbo.customer_orders(customer_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_co_fecha_pedido')
    CREATE INDEX IX_co_fecha_pedido ON dbo.customer_orders(fecha_pedido);
GO

-- customer_order_details
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cod_order_id')
    CREATE INDEX IX_cod_order_id ON dbo.customer_order_details(order_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cod_producto_id')
    CREATE INDEX IX_cod_producto_id ON dbo.customer_order_details(producto_id);
GO

PRINT '[SUCCESS] Indices creados correctamente.';
GO
