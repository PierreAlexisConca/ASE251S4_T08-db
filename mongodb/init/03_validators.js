// =========================================
// 03_validators.js
// Validadores de esquema por coleccion
// Proyecto: AVSA Cañete — Team 08
// =========================================
db = db.getSiblingDB("db_avsa");

// ── customer ─────────────────────────────────────────────────
db.runCommand({
    collMod: "customer",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["codigo", "razonSocial", "pais", "tipoCliente"],
            properties: {
                codigo:       { bsonType: "string", description: "Codigo unico del cliente" },
                razonSocial:  { bsonType: "string", description: "Razon social o nombre" },
                pais:         { bsonType: "string", description: "Pais del cliente" },
                tipoCliente:  { bsonType: "string", enum: ["NACIONAL", "INTERNACIONAL"] },
                active:       { bsonType: "bool" }
            }
        }
    },
    validationLevel: "moderate"
});
print("[INFO] Validador customer aplicado.");

// ── productos ────────────────────────────────────────────────
db.runCommand({
    collMod: "productos",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["codigo", "nombre", "categoria", "precioUnitario"],
            properties: {
                codigo:         { bsonType: "string" },
                nombre:         { bsonType: "string" },
                categoria:      { bsonType: "string" },
                precioUnitario: { bsonType: ["decimal", "double", "int"] },
                stockActual:    { bsonType: "int", minimum: 0 },
                estado:         { bsonType: "bool" }
            }
        }
    },
    validationLevel: "moderate"
});
print("[INFO] Validador productos aplicado.");

// ── agrochemicals ────────────────────────────────────────────
db.runCommand({
    collMod: "agrochemicals",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["commercialName", "activeIngredient", "category"],
            properties: {
                commercialName:  { bsonType: "string" },
                activeIngredient:{ bsonType: "string" },
                category: {
                    bsonType: "string",
                    enum: ["INSECTICIDE","FUNGICIDE","HERBICIDE","FERTILIZER","BIOSTIMULANT","OTHER"]
                },
                active: { bsonType: "bool" }
            }
        }
    },
    validationLevel: "moderate"
});
print("[INFO] Validador agrochemicals aplicado.");

print("[SUCCESS] Validadores aplicados correctamente.");
