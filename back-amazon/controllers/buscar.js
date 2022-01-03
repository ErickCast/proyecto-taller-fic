const { response } = require("express");
const { ObjectId } = require('mongoose').Types;
const Usuario  = require('../models/usuario');
const Categoria  = require('../models/categoria');
const Producto  = require('../models/producto');

const coleccionesPermitidas = [
    'usuarios',
    'categoria',
    'productos',
    'roles'
];

const buscarUsuarios = async( termino = '', res = response ) => {
    const isMongoId = ObjectId.isValid( termino );

    if( isMongoId ) {
        const usuario = await Usuario.findById(termino);
        return res.json({
            results: ( usuario ) ? [ usuario ] : []
        })
    }

    const regex = new RegExp( termino, 'i' );

    const usuarios = await Usuario.find({
        $or: [{nombre: regex }, { correo: regex }],
        $and: [{estado: true}]
    });

    res.json({
        results: usuarios
    })
}

const buscarCategorias = async( termino = '', res = response ) => {
    const isMongoId = ObjectId.isValid(termino);

    if( isMongoId ) {
        const categoria = await Categoria.findById(termino);
        return res.json({
            results: (categoria) ? [ categoria ] : []
        });
    }

    const regex = new RegExp( termino, 'i' );

    const categorias = await Categoria.find({ nombre: termino });

    res.json({
        results: categorias
    });


}

const buscarProductos = async( termino = '', res = response ) => {
    const isMongoId = ObjectId.isValid( termino );

    if( isMongoId ) {
        const producto = await Producto.findById(termino);
        return res.json({
            results: (producto) ? [ producto ] : []
        });
    }

    const regex = new RegExp(termino, 'i');

    const productos = await Producto.find({ nombre: regex });

    res.json({
        results: productos
    });

}

const buscar = (req, res = response) => {


    const { coleccion, termino } = req.params;

    if( !coleccionesPermitidas.includes(coleccion) ) {
        return res.status(400).json({
            msg: `La coleccion ingresada no esta entre las colecciones permitidas, las cuales son: ${ coleccionesPermitidas }`
        });
    }

    switch ( coleccion ) {
        case 'usuarios':
            buscarUsuarios(termino, res);
            break;
        case 'categoria':
            buscarCategorias(termino, res);
            break;
        case 'productos':
            buscarProductos(termino, res);
            break;
        default:
            res.status(500).json({
                msg: 'Se le olvido hacer esta busqueda'
            })
    }

}

module.exports = {
    buscar
}

