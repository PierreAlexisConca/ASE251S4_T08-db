-- =========================================
-- 03_tables.sql
-- Creacion de tablas de avsa_db
-- Proyecto: AVSA Cañete — Team 08
-- Motor: SQL Server 2022
-- =========================================
USE avsa_db;
GO

-- ------------------------------------------------------------
-- app_users: usuarios del sistema con roles
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.app_users', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.app_users (
        id            BIGINT IDENTITY(1,1) PRIMARY KEY,
        username      NVARCHAR(50)  NOT NULL UNIQUE,
        password_hash NVARCHAR(255) NOT NULL,
        full_name     NVARCHAR(200) NOT NULL,
        email         NVARCHAR(100) NOT NULL UNIQUE,
        role          NVARCHAR(30)  NOT NULL,
        active        BIT           NOT NULL DEFAULT 1,
        last_login    DATETIME2     NULL,
        created_at    DATETIME2     NULL,
        updated_at    DATETIME2     NULL,
        deleted_at    DATETIME2     NULL,
        restored_at   DATETIME2     NULL
    );
    PRINT '[INFO] Tabla app_users creada.';
END
GO

-- ------------------------------------------------------------
-- agrochemical: agroquimicos registrados en SENASA
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.agrochemical', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.agrochemical (
        id                         BIGINT IDENTITY(1,1) PRIMARY KEY,
        commercial_name            NVARCHAR(200) NOT NULL,
        active_ingredient          NVARCHAR(200) NOT NULL,
        category                   NVARCHAR(50)  NOT NULL,
        senasa_registration_number NVARCHAR(50)  NULL,
        registration_expiry        DATE          NOT NULL,
        max_dose                   DECIMAL(10,4) NOT NULL,
        waiting_period_days        INT           NOT NULL,
        manufacturer               NVARCHAR(200) NULL,
        active                     BIT           NOT NULL DEFAULT 1,
        created_at                 DATETIME2     NULL,
        updated_at                 DATETIME2     NULL,
        deleted_at                 DATETIME2     NULL,
        restored_at                DATETIME2     NULL
    );
    PRINT '[INFO] Tabla agrochemical creada.';
END
GO

-- ------------------------------------------------------------
-- producers: productores agricolas de Canete
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.producers', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.producers (
        id          BIGINT IDENTITY(1,1) PRIMARY KEY,
        full_name   NVARCHAR(200) NOT NULL,
        dni         NVARCHAR(20)  NOT NULL UNIQUE,
        phone       NVARCHAR(20)  NULL,
        email       NVARCHAR(100) NULL,
        location    NVARCHAR(200) NOT NULL,
        district    NVARCHAR(100) NULL,
        province    NVARCHAR(100) NULL,
        region      NVARCHAR(100) NULL,
        active      BIT           NOT NULL DEFAULT 1,
        qr_token    NVARCHAR(100) NULL UNIQUE,
        created_at  DATETIME2     NULL,
        updated_at  DATETIME2     NULL,
        deleted_at  DATETIME2     NULL,
        restored_at DATETIME2     NULL
    );
    PRINT '[INFO] Tabla producers creada.';
END
GO

-- ------------------------------------------------------------
-- fields: parcelas / campos de los productores
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.fields', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.fields (
        id             BIGINT IDENTITY(1,1) PRIMARY KEY,
        producer_id    BIGINT        NOT NULL,
        name           NVARCHAR(150) NOT NULL,
        area_hectares  FLOAT         NOT NULL,
        active_crop    NVARCHAR(100) NOT NULL,
        location       NVARCHAR(200) NULL,
        active         BIT           NOT NULL DEFAULT 1,
        qr_token       NVARCHAR(100) NULL UNIQUE,
        created_at     DATETIME2     NULL,
        updated_at     DATETIME2     NULL,
        deleted_at     DATETIME2     NULL,
        restored_at    DATETIME2     NULL
    );
    PRINT '[INFO] Tabla fields creada.';
END
GO

-- ------------------------------------------------------------
-- production_lots: lotes de produccion por campo
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.production_lots', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.production_lots (
        id           BIGINT IDENTITY(1,1) PRIMARY KEY,
        field_id     BIGINT        NOT NULL,
        code         NVARCHAR(50)  NOT NULL UNIQUE,
        start_date   DATE          NOT NULL,
        end_date     DATE          NULL,
        crop         NVARCHAR(100) NOT NULL,
        status       NVARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
        observations NVARCHAR(500) NULL,
        active       BIT           NOT NULL DEFAULT 1,
        created_at   DATETIME2     NULL,
        updated_at   DATETIME2     NULL,
        deleted_at   DATETIME2     NULL,
        restored_at  DATETIME2     NULL
    );
    PRINT '[INFO] Tabla production_lots creada.';
END
GO

-- ------------------------------------------------------------
-- field_applications: aplicaciones de agroquimicos en campo
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.field_applications', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.field_applications (
        id               BIGINT IDENTITY(1,1) PRIMARY KEY,
        producer_id      BIGINT        NOT NULL,
        field_id         BIGINT        NOT NULL,
        lot_id           BIGINT        NOT NULL,
        agrochemical_id  BIGINT        NOT NULL,
        dose             FLOAT         NOT NULL,
        dose_unit        NVARCHAR(30)  NOT NULL,
        application_date DATE          NOT NULL,
        technician_id    BIGINT        NOT NULL,
        observations     NVARCHAR(500) NULL,
        senasa_valid     BIT           NULL,
        dose_exceeded    BIT           NULL,
        active           BIT           NOT NULL DEFAULT 1,
        created_at       DATETIME2     NULL,
        updated_at       DATETIME2     NULL,
        deleted_at       DATETIME2     NULL,
        restored_at      DATETIME2     NULL
    );
    PRINT '[INFO] Tabla field_applications creada.';
END
GO

-- ------------------------------------------------------------
-- inventory_deliveries: entregas de agroquimicos a productores
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.inventory_deliveries', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.inventory_deliveries (
        id                 BIGINT IDENTITY(1,1) PRIMARY KEY,
        producer_id        BIGINT        NOT NULL,
        agrochemical_id    BIGINT        NOT NULL,
        quantity_delivered FLOAT         NOT NULL,
        unit               NVARCHAR(30)  NOT NULL,
        delivery_date      DATE          NOT NULL,
        responsible_id     BIGINT        NOT NULL,
        observations       NVARCHAR(500) NULL,
        active             BIT           NOT NULL DEFAULT 1,
        created_at         DATETIME2     NULL,
        deleted_at         DATETIME2     NULL,
        restored_at        DATETIME2     NULL
    );
    PRINT '[INFO] Tabla inventory_deliveries creada.';
END
GO

-- ------------------------------------------------------------
-- alerts: alertas de cumplimiento SENASA
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.alerts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.alerts (
        id                 BIGINT IDENTITY(1,1) PRIMARY KEY,
        type               NVARCHAR(50)  NOT NULL,
        severity           NVARCHAR(10)  NOT NULL,
        title              NVARCHAR(200) NOT NULL,
        description        NVARCHAR(500) NOT NULL,
        producer_id        BIGINT        NULL,
        field_id           BIGINT        NULL,
        agrochemical_id    BIGINT        NULL,
        status             NVARCHAR(20)  NOT NULL DEFAULT 'PENDING',
        reviewed_by        NVARCHAR(100) NULL,
        review_observation NVARCHAR(500) NULL,
        reviewed_at        DATETIME2     NULL,
        active             BIT           NOT NULL DEFAULT 1,
        created_at         DATETIME2     NULL,
        deleted_at         DATETIME2     NULL,
        restored_at        DATETIME2     NULL
    );
    PRINT '[INFO] Tabla alerts creada.';
END
GO

-- ------------------------------------------------------------
-- audit_logs: auditoria de todas las acciones del sistema
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.audit_logs', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.audit_logs (
        id          BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id     BIGINT         NOT NULL,
        user_name   NVARCHAR(100)  NOT NULL,
        action      NVARCHAR(100)  NOT NULL,
        module      NVARCHAR(50)   NOT NULL,
        entity_id   BIGINT         NULL,
        details     NVARCHAR(1000) NULL,
        ip_address  NVARCHAR(50)   NULL,
        [timestamp] DATETIME2      NOT NULL,
        active      BIT            NOT NULL DEFAULT 1,
        deleted_at  DATETIME2      NULL,
        restored_at DATETIME2      NULL
    );
    PRINT '[INFO] Tabla audit_logs creada.';
END
GO

-- ------------------------------------------------------------
-- customer: clientes/distribuidores (referencia logica a MongoDB)
-- customer_id en las transacciones apunta al _id de MongoDB
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.customer', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.customer (
        id                 BIGINT IDENTITY(1,1) PRIMARY KEY,
        codigo             NVARCHAR(50)  NOT NULL UNIQUE,
        razon_social       NVARCHAR(200) NOT NULL,
        ruc                NVARCHAR(20)  NULL,
        tipo_documento     NVARCHAR(30)  NOT NULL,
        numero_documento   NVARCHAR(50)  NOT NULL,
        pais               NVARCHAR(100) NOT NULL,
        ciudad             NVARCHAR(100) NULL,
        direccion          NVARCHAR(200) NULL,
        telefono           NVARCHAR(30)  NULL,
        email              NVARCHAR(100) NULL,
        contacto_principal NVARCHAR(150) NULL,
        tipo_cliente       NVARCHAR(30)  NOT NULL,
        active             BIT           NOT NULL DEFAULT 1,
        created_at         DATETIME2     NULL,
        updated_at         DATETIME2     NULL,
        deleted_at         DATETIME2     NULL,
        restored_at        DATETIME2     NULL
    );
    PRINT '[INFO] Tabla customer creada.';
END
GO

-- ------------------------------------------------------------
-- productos: inventario de productos agricolas
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.productos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.productos (
        id              BIGINT IDENTITY(1,1) PRIMARY KEY,
        codigo          NVARCHAR(50)  NOT NULL UNIQUE,
        nombre          NVARCHAR(200) NOT NULL,
        descripcion     NVARCHAR(500) NULL,
        categoria       NVARCHAR(50)  NOT NULL,
        unidad_medida   NVARCHAR(30)  NOT NULL,
        precio_unitario DECIMAL(10,2) NOT NULL,
        stock_actual    INT           NOT NULL DEFAULT 0,
        stock_minimo    INT           NOT NULL DEFAULT 0,
        origen          NVARCHAR(200) NOT NULL,
        estado          BIT           NOT NULL DEFAULT 1,
        created_at      DATETIME2     NULL,
        updated_at      DATETIME2     NULL,
        deleted_at      DATETIME2     NULL,
        restored_at     DATETIME2     NULL
    );
    PRINT '[INFO] Tabla productos creada.';
END
GO

-- ------------------------------------------------------------
-- customer_orders: pedidos de clientes (cabecera)
-- customer_id es NVARCHAR porque referencia el ObjectId de MongoDB
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.customer_orders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.customer_orders (
        id                     BIGINT IDENTITY(1,1) PRIMARY KEY,
        numero_pedido          NVARCHAR(50)   NOT NULL UNIQUE,
        customer_id            NVARCHAR(50)   NOT NULL,
        customer_razon_social  NVARCHAR(200)  NOT NULL DEFAULT '',
        fecha_pedido           DATE           NOT NULL,
        fecha_entrega_estimada DATE           NULL,
        estado                 NVARCHAR(30)   NOT NULL DEFAULT 'CONFIRMADO',
        observaciones          NVARCHAR(500)  NULL,
        subtotal               DECIMAL(12,2)  NOT NULL DEFAULT 0,
        igv                    DECIMAL(12,2)  NOT NULL DEFAULT 0,
        total                  DECIMAL(12,2)  NOT NULL DEFAULT 0,
        active                 BIT            NOT NULL DEFAULT 1,
        created_at             DATETIME2      NULL,
        updated_at             DATETIME2      NULL
    );
    PRINT '[INFO] Tabla customer_orders creada.';
END
GO

-- ------------------------------------------------------------
-- customer_order_details: detalle de pedidos
-- producto_id es NVARCHAR porque referencia el ObjectId de MongoDB
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.customer_order_details', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.customer_order_details (
        id                     BIGINT IDENTITY(1,1) PRIMARY KEY,
        order_id               BIGINT         NOT NULL,
        producto_id            NVARCHAR(50)   NOT NULL,
        producto_nombre        NVARCHAR(200)  NOT NULL DEFAULT '',
        producto_unidad_medida NVARCHAR(30)   NOT NULL DEFAULT '',
        cantidad               INT            NOT NULL,
        precio_unitario        DECIMAL(10,2)  NOT NULL,
        subtotal               DECIMAL(12,2)  NOT NULL,
        observacion            NVARCHAR(300)  NULL,
        created_at             DATETIME2      NULL
    );
    PRINT '[INFO] Tabla customer_order_details creada.';
END
GO

PRINT '[SUCCESS] Todas las tablas creadas correctamente.';
GO
