const Role = require('../models/rol');
const Usuario = require('../models/usuario');
const Categoria = require('../models/categoria');
const Producto = require('../models/producto');

const esRoleValido = async(rol = '') => {
    const existeRol = await Role.findOne({rol});
    if( !existeRol ) {
        throw new Error(`El rol ${ rol } no esta registrado  en la base de datos`)
    }
}

const emailExiste = async(correo = '',) => {
    //Verificar si el correo existe
    const existeEmail = await Usuario.findOne({ correo, estado: true });
    if( existeEmail ) {
        throw new Error(`El correo ${correo} ya existe!`);
    }
};

const existeUsuarioPorId = async( id ) => {
    const existeUsuario = await Usuario.findOne({ _id: id, estado: true });
    if( !existeUsuario ) {
        throw new Error(`El id no existe ${ id }`);
    }
};

const existeCategoria = async( id ) => {
    const categoria = await Categoria.findOne({ _id: id, estado: true });
    if( !categoria ){
        throw new Error(`El id no existe ${ id }`);
    }
}

const existeProducto = async( id ) => {
    const producto = await Producto.findOne({ _id: id });
    if( !producto ){
        throw new Error(`El id no existe ${ id }`);
    }

}

const existeNombreProducto = async ( nombre='' ) => {
    const producto = await Producto.findOne({nombre});
    if(producto){
        throw new Error('Ya existe un producto con ese nombre');
    }
}

// Validar colecciones permitidas
const coleccionesPermitidas = (coleccion='', colecciones = []) =>{

    const incluida = colecciones.includes( coleccion );
    if(!incluida){
        throw new Error(`La coleccion ${ coleccion } no es permitida, colecciones permitidas : ${ colecciones }`);
    }

    return true;
}

module.exports = {
    esRoleValido,
    emailExiste,
    existeUsuarioPorId,
    existeCategoria,
    existeProducto,
    coleccionesPermitidas,
    existeNombreProducto
}