-- =========================================
-- 08_seed.sql
-- Datos iniciales de prueba
-- Proyecto: AVSA Cañete — Team 08
-- =========================================
USE avsa_db;
GO

-- ── app_users ────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM dbo.app_users)
BEGIN
    INSERT INTO dbo.app_users (username, password_hash, full_name, email, role, active, created_at) VALUES
    ('admin',        'admin123',        'Carlos Mendoza Ríos',   'admin@avsa.pe',       'ROLE_ADMIN',           1, SYSUTCDATETIME()),
    ('supervisor1',  'supervisor1123',  'María Elena Torres',    'mtorres@avsa.pe',     'ROLE_SUPERVISOR',      1, SYSUTCDATETIME()),
    ('tech_juan',    'tech_juan123',    'Juan Pérez Castro',     'jperez@avsa.pe',      'ROLE_TECHNICIAN',      1, SYSUTCDATETIME()),
    ('tech_rosa',    'tech_rosa123',    'Rosa Huamán Valdez',    'rhuaman@avsa.pe',     'ROLE_TECHNICIAN',      1, SYSUTCDATETIME()),
    ('logistica1',   'logistica1123',   'Pedro García Flores',   'pgarcia@avsa.pe',     'ROLE_LOGISTICS',       1, SYSUTCDATETIME()),
    ('cert_ana',     'cert_ana123',     'Ana Quispe Rojas',      'aquispe@avsa.pe',     'ROLE_CERTIFICACIONES', 1, SYSUTCDATETIME());
    PRINT '[INFO] app_users: 6 registros insertados.';
END
ELSE PRINT '[INFO] app_users ya tiene datos — seed omitido.';
GO

-- ── agrochemical ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM dbo.agrochemical)
BEGIN
    INSERT INTO dbo.agrochemical (commercial_name, active_ingredient, category, senasa_registration_number, registration_expiry, max_dose, waiting_period_days, manufacturer, active, created_at) VALUES
    ('Confidor 350 SC',  'Imidacloprid',              'INSECTICIDE',  'PQUA-01-2021', '2027-06-15', 0.5000, 14, 'Bayer CropScience', 1, SYSUTCDATETIME()),
    ('Amistar Top',      'Azoxystrobin+Difenoconazole','FUNGICIDE',   'PQUA-02-2021', '2027-08-20', 1.0000, 21, 'Syngenta',          1, SYSUTCDATETIME()),
    ('Roundup Max',      'Glifosato',                 'HERBICIDE',    'PQUA-03-2020', '2026-12-31', 3.0000, 30, 'Monsanto',          1, SYSUTCDATETIME()),
    ('Karate Zeon',      'Lambda-Cihalotrina',        'INSECTICIDE',  'PQUA-04-2022', '2028-03-10', 0.4000,  7, 'Syngenta',          1, SYSUTCDATETIME()),
    ('Bayfolan Forte',   'NPK + Microelementos',      'FERTILIZER',   'PQUA-05-2021', '2027-05-01', 5.0000,  0, 'Bayer CropScience', 1, SYSUTCDATETIME());
    PRINT '[INFO] agrochemical: 5 registros insertados.';
END
ELSE PRINT '[INFO] agrochemical ya tiene datos — seed omitido.';
GO

-- ── producers ────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM dbo.producers)
BEGIN
    INSERT INTO dbo.producers (full_name, dni, phone, email, location, district, province, region, active, qr_token, created_at) VALUES
    ('Roberto Sánchez Luján',   '45678901', '956123456', 'rsanchez@gmail.com', 'Fundo Santa Rosa Km 5',   'San Vicente', 'Cañete', 'Lima', 1, 'QR-PROD-001', SYSUTCDATETIME()),
    ('María Flores Huamán',     '45678902', '956123457', 'mflores@gmail.com',  'Parcela 12 Valle Cañete', 'Imperial',    'Cañete', 'Lima', 1, 'QR-PROD-002', SYSUTCDATETIME()),
    ('José Luis Quispe Mamani', '45678903', '956123458', 'jquispe@gmail.com',  'Fundo La Esperanza',      'Lunahuaná',   'Cañete', 'Lima', 1, 'QR-PROD-003', SYSUTCDATETIME());
    PRINT '[INFO] producers: 3 registros insertados.';
END
ELSE PRINT '[INFO] producers ya tiene datos — seed omitido.';
GO

-- ── fields ───────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM dbo.fields)
BEGIN
    INSERT INTO dbo.fields (producer_id, name, area_hectares, active_crop, location, active, qr_token, created_at) VALUES
    (1, 'Parcela Norte Santa Rosa', 5.5, 'Mandarina', 'Fundo Santa Rosa - Norte', 1, 'QR-FLD-001', SYSUTCDATETIME()),
    (2, 'Campo Principal Valle',    8.0, 'Uva',       'Parcela 12 - Central',     1, 'QR-FLD-002', SYSUTCDATETIME()),
    (3, 'Terreno La Esperanza',     4.5, 'Espárrago', 'Fundo La Esperanza L1',    1, 'QR-FLD-003', SYSUTCDATETIME());
    PRINT '[INFO] fields: 3 registros insertados.';
END
ELSE PRINT '[INFO] fields ya tiene datos — seed omitido.';
GO

-- ── production_lots ──────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM dbo.production_lots)
BEGIN
    INSERT INTO dbo.production_lots (field_id, code, start_date, crop, status, observations, active, created_at) VALUES
    (1, 'LOT-2026-001', '2026-01-15', 'Mandarina', 'ACTIVE',  'Temporada principal mandarina Satsuma', 1, SYSUTCDATETIME()),
    (2, 'LOT-2026-002', '2026-02-01', 'Uva',       'ACTIVE',  'Temporada uva Red Globe exportación',   1, SYSUTCDATETIME()),
    (3, 'LOT-2026-003', '2026-02-10', 'Espárrago', 'CLOSED',  'Campaña espárrago finalizada',          1, SYSUTCDATETIME());
    PRINT '[INFO] production_lots: 3 registros insertados.';
END
ELSE PRINT '[INFO] production_lots ya tiene datos — seed omitido.';
GO

-- ── field_applications ───────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM dbo.field_applications)
BEGIN
    INSERT INTO dbo.field_applications (producer_id, field_id, lot_id, agrochemical_id, dose, dose_unit, application_date, technician_id, observations, senasa_valid, dose_exceeded, active, created_at) VALUES
    (1, 1, 1, 1, 0.40, 'L/ha', '2026-02-10', 3, 'Aplicación preventiva contra pulgones en mandarina', 1, 0, 1, SYSUTCDATETIME()),
    (2, 2, 2, 2, 0.80, 'L/ha', '2026-03-01', 4, 'Tratamiento fungicida preventivo en uva',            1, 0, 1, SYSUTCDATETIME()),
    (3, 3, 3, 4, 0.30, 'L/ha', '2026-03-05', 3, 'Control de gusano cogollero en espárrago',           1, 0, 1, SYSUTCDATETIME());
    PRINT '[INFO] field_applications: 3 registros insertados.';
END
ELSE PRINT '[INFO] field_applications ya tiene datos — seed omitido.';
GO

-- ── alerts ───────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM dbo.alerts)
BEGIN
    INSERT INTO dbo.alerts (type, severity, title, description, producer_id, agrochemical_id, status, active, created_at) VALUES
    ('SENASA_EXPIRING', 'MEDIUM', 'Registro SENASA próximo a vencer - Roundup', 'El registro PQUA-03-2020 de Roundup Max vence el 2026-12-31', NULL, 3, 'PENDING',  1, SYSUTCDATETIME()),
    ('LOW_STOCK',       'HIGH',   'Stock crítico - Karate Zeon',                'Solo quedan 2 L de Karate Zeon en almacén',                   NULL, 4, 'PENDING',  1, SYSUTCDATETIME()),
    ('DOSE_EXCEEDED',   'HIGH',   'Dosis excedida - Confidor en campo',         'Aplicación de Confidor excede la dosis máxima permitida',      1,    1, 'REVIEWED', 1, SYSUTCDATETIME());
    PRINT '[INFO] alerts: 3 registros insertados.';
END
ELSE PRINT '[INFO] alerts ya tiene datos — seed omitido.';
GO

-- ── audit_logs ───────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM dbo.audit_logs)
BEGIN
    INSERT INTO dbo.audit_logs (user_id, user_name, action, module, entity_id, details, ip_address, [timestamp], active) VALUES
    (1, 'admin',      'CREATE', 'AGROCHEMICAL', 1, 'Creación de Confidor 350 SC',           '192.168.1.10', SYSUTCDATETIME(), 1),
    (2, 'supervisor1','CREATE', 'PRODUCER',     1, 'Registro de productor Roberto Sánchez', '192.168.1.20', SYSUTCDATETIME(), 1),
    (3, 'tech_juan',  'CREATE', 'FIELD_APP',    1, 'Aplicación Confidor en mandarina',      '192.168.1.30', SYSUTCDATETIME(), 1);
    PRINT '[INFO] audit_logs: 3 registros insertados.';
END
ELSE PRINT '[INFO] audit_logs ya tiene datos — seed omitido.';
GO

PRINT '[SUCCESS] Seed de SQL Server ejecutado correctamente.';
GO
