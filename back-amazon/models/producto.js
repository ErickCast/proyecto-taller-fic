const { Schema, model } = require('mongoose');

const ProductoSchema = Schema({
    nombre: {
        type: String,
        required: [true, 'El nombre es obligatorio'],
        unique: true
    },
    usuario: {
        type: Schema.Types.ObjectId,
        ref: 'Usuarios'
    },
    precio: {
        type: Number,
        required: true
    },
    categoria: {
        type: Schema.Types.ObjectId,
        ref: 'Categoria',
        required: true
    },
    promocion: {
        type: Number
    },
    descripcion: {
        type: String,
        required: [true, "La descripcion es obligatoria"]
    },
    stock: {
        type:Number,
        required: true
    },
    fecha: {
        type: Date
    },
    imagen: {
        type: String
    }
});

ProductoSchema.methods.toJSON = function() {
    const { __v, ...data } = this.toObject();
    return data;
}

module.exports = model('Producto', ProductoSchema);