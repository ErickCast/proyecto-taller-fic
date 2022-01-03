const { Schema, model } = require('mongoose');

const UsuarioSchema = Schema({
    nombre: {
        type: String,
        required: [true, 'El nombre es obligatorio']
    },
    telefono: {
        type: String
    },
    correo: {
        type: String,
        required: [true, 'El correo es obligatorio']
    },
    password: {
        type: String,
        required: [true, 'La contraseña es obligatoria']
    },
    tarjeta: {
        type: Boolean,
        default: false
    },
    pais: {
        type: String
    },
    estado: {
        type: String
    },
    ciudad: {
        type: String
    },
    domicilio: {
        type: String
    },
    rol: {
        type: String,
        default: "USER_ROLE"
    },
    foto: {
        type: String
    }
    
});

UsuarioSchema.methods.toJSON = function() {
    const { __v, password, _id, ...usuario } = this.toObject();
    usuario.uid = _id;
    return usuario;
}

module.exports = model('Usuario', UsuarioSchema);