-- =========================================
-- 04_constraints.sql
-- FK, CHECK y UNIQUE constraints
-- Proyecto: AVSA Cañete — Team 08
-- =========================================
USE avsa_db;
GO

-- ── app_users ────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_app_users_role')
    ALTER TABLE dbo.app_users ADD CONSTRAINT CK_app_users_role
        CHECK (role IN ('ROLE_ADMIN','ROLE_SUPERVISOR','ROLE_TECHNICIAN','ROLE_LOGISTICS','ROLE_CERTIFICACIONES'));
GO

-- ── agrochemical ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_agrochemical_category')
    ALTER TABLE dbo.agrochemical ADD CONSTRAINT CK_agrochemical_category
        CHECK (category IN ('INSECTICIDE','FUNGICIDE','HERBICIDE','FERTILIZER','BIOSTIMULANT','OTHER'));
GO

-- ── fields → producers ───────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_fields_producer')
    ALTER TABLE dbo.fields ADD CONSTRAINT FK_fields_producer
        FOREIGN KEY (producer_id) REFERENCES dbo.producers(id);
GO

-- ── production_lots → fields ─────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_production_lots_field')
    ALTER TABLE dbo.production_lots ADD CONSTRAINT FK_production_lots_field
        FOREIGN KEY (field_id) REFERENCES dbo.fields(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_production_lots_status')
    ALTER TABLE dbo.production_lots ADD CONSTRAINT CK_production_lots_status
        CHECK (status IN ('ACTIVE','CLOSED','CANCELLED'));
GO

-- ── field_applications → producers, fields, lots, agrochemical, technician ──
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_field_app_producer')
    ALTER TABLE dbo.field_applications ADD CONSTRAINT FK_field_app_producer
        FOREIGN KEY (producer_id) REFERENCES dbo.producers(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_field_app_field')
    ALTER TABLE dbo.field_applications ADD CONSTRAINT FK_field_app_field
        FOREIGN KEY (field_id) REFERENCES dbo.fields(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_field_app_lot')
    ALTER TABLE dbo.field_applications ADD CONSTRAINT FK_field_app_lot
        FOREIGN KEY (lot_id) REFERENCES dbo.production_lots(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_field_app_agrochemical')
    ALTER TABLE dbo.field_applications ADD CONSTRAINT FK_field_app_agrochemical
        FOREIGN KEY (agrochemical_id) REFERENCES dbo.agrochemical(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_field_app_technician')
    ALTER TABLE dbo.field_applications ADD CONSTRAINT FK_field_app_technician
        FOREIGN KEY (technician_id) REFERENCES dbo.app_users(id);
GO

-- ── inventory_deliveries → producers, agrochemical, responsible ──
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_inv_del_producer')
    ALTER TABLE dbo.inventory_deliveries ADD CONSTRAINT FK_inv_del_producer
        FOREIGN KEY (producer_id) REFERENCES dbo.producers(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_inv_del_agrochemical')
    ALTER TABLE dbo.inventory_deliveries ADD CONSTRAINT FK_inv_del_agrochemical
        FOREIGN KEY (agrochemical_id) REFERENCES dbo.agrochemical(id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_inv_del_responsible')
    ALTER TABLE dbo.inventory_deliveries ADD CONSTRAINT FK_inv_del_responsible
        FOREIGN KEY (responsible_id) REFERENCES dbo.app_users(id);
GO

-- ── alerts CHECK ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_alerts_type')
    ALTER TABLE dbo.alerts ADD CONSTRAINT CK_alerts_type
        CHECK (type IN ('NO_APPLICATION_REGISTERED','DOSE_EXCEEDED','LOW_STOCK','SENASA_EXPIRING','SENASA_EXPIRED'));
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_alerts_severity')
    ALTER TABLE dbo.alerts ADD CONSTRAINT CK_alerts_severity
        CHECK (severity IN ('HIGH','MEDIUM','LOW'));
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_alerts_status')
    ALTER TABLE dbo.alerts ADD CONSTRAINT CK_alerts_status
        CHECK (status IN ('PENDING','REVIEWED','DISMISSED'));
GO

-- ── customer_orders CHECK ────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_co_estado')
    ALTER TABLE dbo.customer_orders ADD CONSTRAINT CK_co_estado
        CHECK (estado IN ('PENDIENTE','CONFIRMADO','EN_PROCESO','ENTREGADO','CANCELADO'));
GO

-- ── customer_order_details → customer_orders ─────────────────
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_cod_order')
    ALTER TABLE dbo.customer_order_details ADD CONSTRAINT FK_cod_order
        FOREIGN KEY (order_id) REFERENCES dbo.customer_orders(id);
GO

PRINT '[SUCCESS] Constraints aplicados correctamente.';
GO
