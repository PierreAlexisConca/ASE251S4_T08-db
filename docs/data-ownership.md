# Matriz de propiedad de datos - AVSA Cañete

Esta matriz define, para cada entidad de negocio del proyecto, en qué
motor de persistencia vive y por qué.

| Entidad de negocio | Motor de persistencia | Justificación arquitectónica |
|---|---|---|
| Pedidos de cliente (customer_orders) | SQL Server | Transacciones comerciales críticas, requiere consistencia ACID y FK hacia detalle. |
| Detalle de pedido (customer_order_details) | SQL Server | Líneas de venta ligadas a la cabecera, integridad relacional estricta. |
| Ventas (ventas) | SQL Server | Transacciones financieras inmutables históricas ligadas al cliente. |
| Detalle de venta (venta_detalles) | SQL Server | Líneas de venta con referencia relacional al producto y a la cabecera. |
| Aplicaciones de campo (field_applications) | SQL Server | Trazabilidad agronómica SENASA, requiere FK a productor, campo, lote y agroquímico. |
| Entregas de inventario (inventory_deliveries) | SQL Server | Movimientos de stock con integridad referencial hacia agroquímico y responsable. |
| Lotes de producción (production_lots) | SQL Server | Ciclos productivos ligados a campos, con estados controlados. |
| Campos / Parcelas (fields) | SQL Server | Unidades productivas referenciadas por lotes y aplicaciones. |
| Productores (producers) | SQL Server | Entidad central de la trazabilidad agrícola, referenciada por campos y alertas. |
| Alertas (alerts) | SQL Server | Eventos de cumplimiento SENASA con referencias a productor, campo y agroquímico. |
| Auditoría (audit_logs) | SQL Server | Tabla de seguridad inmutable. Trazabilidad de todas las acciones del sistema. |
| Usuarios del sistema (app_users) | SQL Server | Autenticación y autorización con roles controlados. |
| Clientes (customer) | MongoDB | Datos maestros de contacto y comerciales. Esquema flexible, lectura frecuente. |
| Productos de inventario (productos) | MongoDB | Catálogo con atributos variables por categoría (fertilizantes, fungicidas, etc.). |
| Agroquímicos (agrochemicals) | MongoDB | Registro SENASA con esquema flexible por categoría y fabricante. |
| Notificaciones (notificaciones) | MongoDB | Eventos en tiempo real de baja latencia, sin necesidad de FK relacional. |
| Métricas de dashboard (dashboard_metrics) | MongoDB | Snapshots de KPIs generados periódicamente, de solo lectura analítica. |

## Resumen por motor

| Motor | Entidades | Criterio principal de selección |
|---|---|---|
| SQL Server | Pedidos, Ventas, Aplicaciones, Entregas, Lotes, Campos, Productores, Alertas, Auditoría, Usuarios | Integridad referencial y transacciones ACID |
| MongoDB | Clientes, Productos, Agroquímicos, Notificaciones, Métricas | Esquema flexible y lecturas frecuentes |

## Regla de arquitectura

La referencia entre motores es **lógica, no física**: las tablas
transaccionales de SQL Server (`customer_orders`, `customer_order_details`)
guardan un `customer_id` o `producto_id` que apunta al `_id` en MongoDB
como un campo `NVARCHAR(50)`, pero **no existe una llave foránea real entre
ambos motores** (SQL Server no puede validar la existencia de un documento
en MongoDB). Esta validación de integridad se resuelve a nivel de aplicación,
en el backend Spring WebFlux.

Si el precio o los atributos de un producto cambian en el catálogo vivo
(MongoDB), los registros históricos en SQL Server (por ejemplo, el
`precio_unitario` ya guardado en `customer_order_details`) no se alteran:
cada transacción conserva el precio que tenía en el momento en que ocurrió.
