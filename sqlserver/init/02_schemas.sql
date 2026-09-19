-- =========================================
-- 02_schemas.sql
-- Schemas de la base de datos avsa_db
-- Proyecto: AVSA Cañete — Team 08
-- =========================================
USE avsa_db;
GO

-- El proyecto usa el schema dbo por defecto.
-- Se registra aqui como punto de documentacion formal.
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dbo')
BEGIN
    EXEC('CREATE SCHEMA dbo');
    PRINT '[INFO] Schema dbo creado.';
END
ELSE
BEGIN
    PRINT '[INFO] Schema dbo ya existe.';
END
GO
