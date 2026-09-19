// =========================================
// 02_collections.js
// Creacion explicita de colecciones maestras
// Proyecto: AVSA Cañete — Team 08
// =========================================
db = db.getSiblingDB("db_avsa");

// Maestros: datos de catalogo con esquema flexible
db.createCollection("customer");
db.createCollection("productos");
db.createCollection("agrochemicals");

// Logs y eventos: notificaciones, auditoria y metricas
db.createCollection("notificaciones");
db.createCollection("audit_logs");
db.createCollection("dashboard_metrics");

print("[SUCCESS] Colecciones de db_avsa creadas correctamente.");
