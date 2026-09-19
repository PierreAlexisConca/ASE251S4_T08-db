-- =========================================
-- 01_database.sql
-- Creacion de la base de datos avsa_db
-- Proyecto: AVSA Cañete — Team 08
-- =========================================
IF DB_ID(N'avsa_db') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE [avsa_db]');
    PRINT '[INFO] Base de datos avsa_db creada.';
END
ELSE
BEGIN
    PRINT '[INFO] Base de datos avsa_db ya existe.';
END
GO

USE avsa_db;
GO

SET NOCOUNT ON;
GO
