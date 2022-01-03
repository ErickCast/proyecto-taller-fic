const path = require('path');
const fs = require('fs');

const { response } = require('express');

const Producto = require('../models/producto');

const { subirArchivo } = require("../helpers/subir-archivo");

const getProductos = async( req, res = response ) => {
    const productos = await Producto.find(); 

    res.status(200).json({
        productos
    });
}

const getProductoById = async( req, res = response ) => {
    const { id } = req.params;

    const producto = await Producto.findById(id);

    res.status(200).json({
        producto
    });
}

const getProductosByCategoria = async(req, res = response) => {
    const { id } = req.params;

    const productos = await Producto.find({ categoria:id });

    if( !productos ) {
        return res.status(200).json({
            msg:'No hay productos en existencia en esta categoria'
        });
    }else {
        res.status(200).json({
            productos
        });
    }
}

const productosPost = async( req, res = response ) => {
    const { usuario, ...body } = req.body;

    const productoDB = await Producto.findOne({ nombre:body.nombre.toUpperCase() });

    if( productoDB ) {
        return res.status(400).json({
            msg: `El producto ${ productoDB.nombre } ya existe!`
        })
    }

    
    

    const imagen = await subirArchivo(req.files, undefined, 'productos');

    body.imagen = imagen;
    
    const data = {
        ...body,
        nombre: body.nombre.toUpperCase(),
        usuario: req.usuario._id
    }

    const producto = new Producto(data);


    await producto.save();
    


    



    res.status(201).json({
        msg: 'Producto creado!',
        producto,
        imagen
    });

    


}

const mostrarImagen = async( req, res = response ) => {

    const { id } = req.params;

    let modelo;

    modelo = await Producto.findById(id);
    if ( !modelo ) {
        return res.status(400).json({
            msg: `No existe un producto con el id ${ id }`
        });
    }


    

    // Limpiar imagenes previas
    if ( modelo.imagen ) {
        // Borrar la imagen del servidor
        const pathImagen = path.join( __dirname, '../uploads', 'productos', modelo.imagen );
        if( fs.existsSync( pathImagen ) ){
            return res.sendFile( pathImagen )
        }
    }
    const pathImage = path.join( __dirname, '../assets/img/no-image.jpg' );
    res.sendFile( pathImage );
    
    

    

}

// en put y delete se tiene que recibir el id y el body de la peticion
const productosPut = async( req, res = response ) => {
    const { id } = req.params;
    const { usuario, ...data } = req.body;

    const productoGet = await Producto.findById(id);

    if( data.nombre ) {
        data.nombre = data.nombre.toUpperCase();
    }

    if(req.usuario.rol == "ADMIN_ROLE"){
        data.usuario = productoGet.usuario;
    }else{
        data.usuario = req.usuario._id;
    }

    const imagen = await subirArchivo(req.files, undefined, 'productos');

    data.imagen = imagen;
    
    
    const producto = await Producto.findByIdAndUpdate(id, data, { new: true });


    res.status(200).json({
        msg: 'Producto actualizado!',
        resultado: 1,
        producto
    })
}

const productosDelete = async(req, res = response) => {
    const { id } = req.params;

    const producto = await Producto.findByIdAndRemove(id, {new:true});

    res.status(200).json({
        msg: 'Producto eliminado!',
        producto
    })
}

const getProductosByUsuario = async(req, res = response) => {
    const { id } = req.params;

    const productos = await Producto.find({ usuario:id });

    if( !productos ) {
        return res.status(200).json({
            msg:'Este usuario no tiene productos publicados'
        });
    }else {
        res.status(200).json({
            productos
        });
    }
}

module.exports = {
    getProductos,
    getProductoById,
    productosPost,
    productosPut,
    productosDelete,
    getProductosByCategoria,
    mostrarImagen,
    getProductosByUsuario
}