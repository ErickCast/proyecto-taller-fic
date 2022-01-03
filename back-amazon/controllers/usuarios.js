const { response,request } = require('express');
const bcryptjs = require('bcryptjs');

const Usuario = require('../models/usuario');

const usuariosGet = async(req = request, res = response) => {
    const usuarios = await Usuario.find({});

    res.json({
        usuarios

    });
}

const usuariosPost = async(req, res = response) => {

    const { nombre, telefono, correo, password, pais, estado, ciudad, domicilio } = req.body;
    const usuario = new Usuario({ nombre, telefono, correo, password, pais, estado, ciudad, domicilio });

    //Encriptar la contrasena
    const salt = bcryptjs.genSaltSync();
    usuario.password = bcryptjs.hashSync( password, salt );

    

    // Guardar en DB
    await usuario.save();

    

    res.json({
        msg: 'Usuario registrado!',
        resultado: 1,
        usuario
    })



}

const usuariosPut = async(req, res = response) => {
    const { id } = req.params;
    const { _id, password, ...resto } = req.body;

    if ( password ) {
        //Encriptar la contrasena
        const salt = bcryptjs.genSaltSync();
        resto.password = bcryptjs.hashSync( password, salt );
    }

    const usuario = await Usuario.findByIdAndUpdate( id, resto, {new:true});

    res.json({
        msg: 'Usuario actualizado!',
        usuario

    })
}

const usuariosDelete = async(req, res = response) => {
    const { id } = req.params;

    const usuario = await Usuario.findByIdAndDelete(id);

    res.json({
        msg: 'Usuario eliminado!',
        usuario
    })
}

module.exports = {
    usuariosGet,
    usuariosPost,
    usuariosPut,
    usuariosDelete
}