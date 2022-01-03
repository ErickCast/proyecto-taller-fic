const { Schema, model } = require('mongoose');

const OrdenSchema = Schema({
    pais:{
        type: String,
        required: [true, 'El pais es obligatorio']
    },
    estado:{
        type: String,
        required: [true, 'El estado es obligatorio']
    },
    municipio:{
        type: String,
        required: [true, 'El municipio es obligatorio']
    },
    domicilio:{
        type: String,
        required: [true, 'El domicilio es obligatorio']
    },
    costo: {
        type: Number,
        required: [true, 'El costo de la orden es obligatorio']
    },
    fecha: {
        type: Date
    },
    hora: {
        type: String
    },
    productos: {
        type: Array,
        required: [true, 'Se requiere tener productos para formar una orden']
    },
    usuario: {
        type: Schema.Types.ObjectId,
        ref: 'Usuarios'
    }
});

module.exports = model('Orden', OrdenSchema);