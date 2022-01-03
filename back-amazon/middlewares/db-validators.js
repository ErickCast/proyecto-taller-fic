const Usuario = require('../models/usuario');
const Role = require('../models/rol');
const Categoria = require('../models/categoria');
const Producto = require('../models/producto');
const Orden = require('../models/orden');


const emailExiste = async(correo) => {
    const usuario = await Usuario.findOne({ correo });
    if( usuario ) {
        throw new Error(`Ya existe un usuario con el correo ${ correo }`)
    }
}

const esRoleValido = async(rol = '') => {
    const existeRol = await Role.findOne({rol});
    if( !existeRol ) {
        throw new Error(`El rol ${ rol } no esta registrado  en la base de datos`)
    }
}

const existeUsuarioPorId = async( id ) => {
    const existeUsuario = await Usuario.findOne({ _id: id});
    if( !existeUsuario ) {
        throw new Error(`El id no existe ${ id }`);
    }
};

const existeCategoria = async( nombre ) => {
    const existeCategoria = await Categoria.findOne({nombre});
    if( existeCategoria ){
        throw new Error(`La categoria ${ nombre } ya existe!`);
    }
}

const existeProducto = async( id ) => {
    const producto = await Producto.findOne({ _id: id });

    if( !producto ){
        throw new Error('El producto no existe!');
    }
}

const existeOrden = async( id ) => {
    const orden = await Orden.findOne({ _id: id });

    if( !orden ){
        throw new Error('La orden no existe!');
    }
}

module.exports  = {
    emailExiste,
    esRoleValido,
    existeUsuarioPorId,
    existeCategoria,
    existeProducto,
    existeOrden
}