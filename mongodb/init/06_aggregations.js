// =========================================
// 06_aggregations.js
// Verificacion de pipelines de agregacion
// Proyecto: AVSA Cañete — Team 08
// Autor: Pierre Conca
// =========================================
db = db.getSiblingDB("db_avsa");

// ── Pipeline 1: Resumen de productos por categoria ───────────
// Agrupa todos los productos por categoria y calcula:
// - totalProductos: cuantos hay en esa categoria
// - precioPromedio: precio unitario promedio (convierte Decimal128 a Double)
// - stockTotal: suma de stock disponible
// Ordenado por stockTotal descendente
print("[INFO] Ejecutando Pipeline 1: productos por categoria...");

var resultPipeline1 = db.productos.aggregate([
    {
        $group: {
            _id: "$categoria",
            totalProductos:  { $sum: 1 },
            precioPromedio:  { $avg: { $toDouble: "$precioUnitario" } },
            stockTotal:      { $sum: "$stockActual" }
        }
    },
    {
        $project: {
            _id: 0,
            categoria:      "$_id",
            totalProductos:  1,
            precioPromedio: { $round: ["$precioPromedio", 2] },
            stockTotal:      1
        }
    },
    { $sort: { stockTotal: -1 } }
]).toArray();

print("[RESULTADO Pipeline 1] Productos por categoria:");
resultPipeline1.forEach(function(doc) {
    print("  - " + doc.categoria + " | productos: " + doc.totalProductos +
          " | precioPromedio: " + doc.precioPromedio +
          " | stockTotal: " + doc.stockTotal);
});

// ── Pipeline 2: Ranking de fabricantes de agroquimicos activos ──
// Filtra solo agroquimicos con active = true
// Agrupa por fabricante y calcula:
// - totalProductos: cantidad de agroquimicos del fabricante
// - categorias: lista de categorias sin duplicados ($addToSet)
// - diasEsperaPromedio: promedio del periodo de carencia SENASA
// Ordenado por totalProductos descendente (ranking)
print("[INFO] Ejecutando Pipeline 2: ranking de fabricantes de agroquimicos...");

var resultPipeline2 = db.agrochemicals.aggregate([
    { $match: { active: true } },
    {
        $group: {
            _id:                "$manufacturer",
            totalProductos:     { $sum: 1 },
            categorias:         { $addToSet: "$category" },
            diasEsperaPromedio: { $avg: "$waitingPeriodDays" }
        }
    },
    {
        $project: {
            _id: 0,
            fabricante:         "$_id",
            totalProductos:      1,
            categorias:          1,
            diasEsperaPromedio: { $round: ["$diasEsperaPromedio", 1] }
        }
    },
    { $sort: { totalProductos: -1 } }
]).toArray();

print("[RESULTADO Pipeline 2] Ranking de fabricantes:");
resultPipeline2.forEach(function(doc) {
    print("  - " + doc.fabricante +
          " | productos: " + doc.totalProductos +
          " | categorias: " + doc.categorias.join(", ") +
          " | diasEsperaPromedio: " + doc.diasEsperaPromedio);
});

print("[SUCCESS] Pipelines de agregacion verificados correctamente.");
