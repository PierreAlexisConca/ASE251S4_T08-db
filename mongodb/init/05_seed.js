// =========================================
// 05_seed.js
// Datos iniciales de prueba
// Proyecto: AVSA Cañete — Team 08
// =========================================
db = db.getSiblingDB("db_avsa");

// ── customer ─────────────────────────────────────────────────
if (db.customer.countDocuments() === 0) {
    db.customer.insertMany([
        {
            codigo: "CLI-001",
            razonSocial: "Agroindustrias del Sur S.A.C.",
            ruc: "20512345678",
            tipoDocumento: "RUC",
            numeroDocumento: "20512345678",
            pais: "Perú",
            ciudad: "Lima",
            direccion: "Av. La Marina 1234",
            telefono: "01-4567890",
            email: "ventas@agroindsur.pe",
            contactoPrincipal: "Luis Paredes",
            tipoCliente: "NACIONAL",
            state: "A",
            active: true,
            createdAt: new Date()
        },
        {
            codigo: "CLI-002",
            razonSocial: "Fresh Fruits Export Ltd.",
            tipoDocumento: "TAX_ID",
            numeroDocumento: "US-987654321",
            pais: "Estados Unidos",
            ciudad: "Miami",
            direccion: "1200 Brickell Ave",
            telefono: "+1-305-1234567",
            email: "imports@freshfruits.com",
            contactoPrincipal: "John Smith",
            tipoCliente: "INTERNACIONAL",
            state: "A",
            active: true,
            createdAt: new Date()
        },
        {
            codigo: "CLI-003",
            razonSocial: "Supermercados Peruanos S.A.",
            ruc: "20101234567",
            tipoDocumento: "RUC",
            numeroDocumento: "20101234567",
            pais: "Perú",
            ciudad: "Lima",
            direccion: "Calle Morelli 181 San Borja",
            telefono: "01-6180000",
            email: "compras@spsa.pe",
            contactoPrincipal: "Martha Gutiérrez",
            tipoCliente: "NACIONAL",
            state: "A",
            active: true,
            createdAt: new Date()
        },
        {
            codigo: "CLI-004",
            razonSocial: "European Organic Traders GmbH",
            tipoDocumento: "TAX_ID",
            numeroDocumento: "DE-123456789",
            pais: "Alemania",
            ciudad: "Hamburgo",
            direccion: "Hafenstraße 45",
            telefono: "+49-40-12345",
            email: "procurement@eot.de",
            contactoPrincipal: "Hans Mueller",
            tipoCliente: "INTERNACIONAL",
            state: "A",
            active: true,
            createdAt: new Date()
        },
        {
            codigo: "CLI-005",
            razonSocial: "Mercado Mayorista Cañete E.I.R.L.",
            ruc: "20567890123",
            tipoDocumento: "RUC",
            numeroDocumento: "20567890123",
            pais: "Perú",
            ciudad: "Cañete",
            direccion: "Jr. Bolognesi 456",
            telefono: "01-5812345",
            email: "info@mercadocanete.pe",
            contactoPrincipal: "Rosa Mendoza",
            tipoCliente: "NACIONAL",
            state: "A",
            active: true,
            createdAt: new Date()
        }
    ]);
    print("[INFO] customer: 5 documentos insertados.");
} else {
    print("[INFO] customer ya tiene datos — seed omitido.");
}

// ── productos ────────────────────────────────────────────────
if (db.productos.countDocuments() === 0) {
    db.productos.insertMany([
        {
            codigo: "PROD-001",
            nombre: "Mandarina Satsuma",
            descripcion: "Mandarina variedad Satsuma de primera calidad",
            categoria: "Cítricos",
            unidadMedida: "Caja",
            precioUnitario: NumberDecimal("85.00"),
            stockActual: 500,
            stockMinimo: 50,
            origen: "Cañete - San Vicente",
            estado: true,
            createdAt: new Date()
        },
        {
            codigo: "PROD-002",
            nombre: "Palta Hass",
            descripcion: "Palta Hass calibre 16-20",
            categoria: "Frutas",
            unidadMedida: "Caja",
            precioUnitario: NumberDecimal("120.00"),
            stockActual: 350,
            stockMinimo: 40,
            origen: "Cañete - Lunahuaná",
            estado: true,
            createdAt: new Date()
        },
        {
            codigo: "PROD-003",
            nombre: "Uva Red Globe",
            descripcion: "Uva de mesa variedad Red Globe",
            categoria: "Frutas",
            unidadMedida: "Caja",
            precioUnitario: NumberDecimal("95.00"),
            stockActual: 280,
            stockMinimo: 30,
            origen: "Cañete - Imperial",
            estado: true,
            createdAt: new Date()
        },
        {
            codigo: "PROD-004",
            nombre: "Espárrago Verde",
            descripcion: "Espárrago verde fresco para exportación",
            categoria: "Hortalizas",
            unidadMedida: "Kg",
            precioUnitario: NumberDecimal("18.50"),
            stockActual: 1200,
            stockMinimo: 100,
            origen: "Cañete - Quilmaná",
            estado: true,
            createdAt: new Date()
        },
        {
            codigo: "PROD-005",
            nombre: "Mango Kent",
            descripcion: "Mango variedad Kent calibre 8-10",
            categoria: "Frutas",
            unidadMedida: "Caja",
            precioUnitario: NumberDecimal("110.00"),
            stockActual: 420,
            stockMinimo: 50,
            origen: "Cañete - San Vicente",
            estado: true,
            createdAt: new Date()
        }
    ]);
    print("[INFO] productos: 5 documentos insertados.");
} else {
    print("[INFO] productos ya tiene datos — seed omitido.");
}

// ── agrochemicals ────────────────────────────────────────────
if (db.agrochemicals.countDocuments() === 0) {
    db.agrochemicals.insertMany([
        {
            commercialName: "Roundup Max",
            activeIngredient: "Glifosato 74.7%",
            category: "HERBICIDE",
            senasaRegistrationNumber: "SEN-2024-001",
            registrationExpiry: new Date("2026-12-31"),
            maxDose: NumberDecimal("2.5"),
            waitingPeriodDays: 15,
            manufacturer: "Bayer CropScience",
            active: true,
            createdAt: new Date()
        },
        {
            commercialName: "Karate Zeon",
            activeIngredient: "Lambda-Cialotrina 5%",
            category: "INSECTICIDE",
            senasaRegistrationNumber: "SEN-2024-002",
            registrationExpiry: new Date("2027-06-30"),
            maxDose: NumberDecimal("1.5"),
            waitingPeriodDays: 21,
            manufacturer: "Syngenta",
            active: true,
            createdAt: new Date()
        },
        {
            commercialName: "Score 250 EC",
            activeIngredient: "Difenoconazol 25%",
            category: "FUNGICIDE",
            senasaRegistrationNumber: "SEN-2024-003",
            registrationExpiry: new Date("2026-09-15"),
            maxDose: NumberDecimal("0.5"),
            waitingPeriodDays: 14,
            manufacturer: "Syngenta",
            active: true,
            createdAt: new Date()
        },
        {
            commercialName: "Bayfolan Forte",
            activeIngredient: "NPK + Microelementos",
            category: "FERTILIZER",
            senasaRegistrationNumber: "SEN-2024-004",
            registrationExpiry: new Date("2027-05-01"),
            maxDose: NumberDecimal("5.0"),
            waitingPeriodDays: 0,
            manufacturer: "Bayer CropScience",
            active: true,
            createdAt: new Date()
        },
        {
            commercialName: "Trichoderma Harzianum",
            activeIngredient: "Trichoderma harzianum",
            category: "BIOSTIMULANT",
            senasaRegistrationNumber: "SEN-2024-005",
            registrationExpiry: new Date("2029-01-15"),
            maxDose: NumberDecimal("2.0"),
            waitingPeriodDays: 0,
            manufacturer: "BioAgro Peru",
            active: true,
            createdAt: new Date()
        }
    ]);
    print("[INFO] agrochemicals: 5 documentos insertados.");
} else {
    print("[INFO] agrochemicals ya tiene datos — seed omitido.");
}

// ── notificaciones ───────────────────────────────────────────
if (db.notificaciones.countDocuments() === 0) {
    db.notificaciones.insertMany([
        {
            tipo: "CREATE",
            modulo: "CLIENTE",
            mensaje: "Nuevo cliente registrado: Agroindustrias del Sur S.A.C.",
            usuario: "admin",
            entidadId: 1,
            detalle: "Cliente CLI-001 creado exitosamente",
            fechaHora: new Date(),
            estado: "NO_LEIDA"
        },
        {
            tipo: "CREATE",
            modulo: "AGROQUIMICO",
            mensaje: "Agroquímico Roundup Max registrado en el sistema",
            usuario: "admin",
            entidadId: 1,
            detalle: "Agroquímico con registro SENASA SEN-2024-001",
            fechaHora: new Date(),
            estado: "NO_LEIDA"
        },
        {
            tipo: "UPDATE",
            modulo: "PRODUCTO",
            mensaje: "Stock actualizado: Mandarina Satsuma",
            usuario: "logistica1",
            entidadId: 1,
            detalle: "Stock actualizado a 500 unidades",
            fechaHora: new Date(),
            estado: "LEIDA"
        }
    ]);
    print("[INFO] notificaciones: 3 documentos insertados.");
} else {
    print("[INFO] notificaciones ya tiene datos — seed omitido.");
}

print("[SUCCESS] Seed de MongoDB ejecutado correctamente.");
