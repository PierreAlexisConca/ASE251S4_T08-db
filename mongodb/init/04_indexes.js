// =========================================
// 04_indexes.js
// Indices para optimizacion de consultas
// Proyecto: AVSA Cañete — Team 08
// =========================================
db = db.getSiblingDB("db_avsa");

// ── customer ─────────────────────────────────────────────────
// Busqueda por codigo unico (CRUD)
db.customer.createIndex({ codigo: 1 }, { unique: true, name: "idx_customer_codigo" });
// Busqueda por estado activo/inactivo (filtros frecuentes)
db.customer.createIndex({ state: 1 }, { name: "idx_customer_state" });
// Busqueda por tipo de cliente (NACIONAL / INTERNACIONAL)
db.customer.createIndex({ tipoCliente: 1 }, { name: "idx_customer_tipo" });
print("[INFO] Indices customer creados.");

// ── productos ────────────────────────────────────────────────
// Busqueda por codigo unico
db.productos.createIndex({ codigo: 1 }, { unique: true, name: "idx_productos_codigo" });
// Busqueda por estado (activo/inactivo)
db.productos.createIndex({ estado: 1 }, { name: "idx_productos_estado" });
// Busqueda por categoria para agrupaciones y reportes
db.productos.createIndex({ categoria: 1 }, { name: "idx_productos_categoria" });
// Consultas de stock bajo (alertas de inventario)
db.productos.createIndex({ stockActual: 1 }, { name: "idx_productos_stock" });
print("[INFO] Indices productos creados.");

// ── agrochemicals ────────────────────────────────────────────
// Busqueda por producto activo
db.agrochemicals.createIndex({ active: 1 }, { name: "idx_agro_active" });
// Busqueda por categoria (INSECTICIDE, FUNGICIDE, etc.)
db.agrochemicals.createIndex({ category: 1 }, { name: "idx_agro_category" });
// Busqueda por fabricante para agrupaciones
db.agrochemicals.createIndex({ manufacturer: 1 }, { name: "idx_agro_manufacturer" });
// Vencimiento de registro SENASA (alertas criticas)
db.agrochemicals.createIndex({ registrationExpiry: 1 }, { name: "idx_agro_expiry" });
print("[INFO] Indices agrochemicals creados.");

// ── notificaciones ───────────────────────────────────────────
// Notificaciones por usuario y estado (NO_LEIDA / LEIDA)
db.notificaciones.createIndex({ usuario: 1, estado: 1 }, { name: "idx_notif_usuario_estado" });
// Orden cronologico para mostrar las mas recientes primero
db.notificaciones.createIndex({ fechaHora: -1 }, { name: "idx_notif_fecha" });
print("[INFO] Indices notificaciones creados.");

// ── audit_logs ───────────────────────────────────────────────
// Busqueda por usuario y timestamp para historial de acciones
db.audit_logs.createIndex({ userName: 1, timestamp: -1 }, { name: "idx_audit_user_ts" });
// Busqueda por modulo afectado
db.audit_logs.createIndex({ modulo: 1 }, { name: "idx_audit_modulo" });
print("[INFO] Indices audit_logs creados.");

// ── dashboard_metrics ────────────────────────────────────────
// Orden por fecha de generacion para obtener el snapshot mas reciente
db.dashboard_metrics.createIndex({ generadoEn: -1 }, { name: "idx_dashboard_fecha" });
print("[INFO] Indices dashboard_metrics creados.");

print("[SUCCESS] Todos los indices creados correctamente.");
