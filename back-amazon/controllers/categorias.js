const { response } = require('express');
const Categoria = require('../models/categoria');

const getCategorias = async(req, res = response) => {
    const categorias = await Categoria.find();

    res.json({
        categorias
    });
}

const getCategoria = async(req, res = response) => {
    const { id } = req.params;

    const categoria = await Categoria.findOne({_id: id});

    res.json({
        categoria
    });
}

const categoriasPost = async(req, res = response) => {
    const { nombre } = req.body;

    const categoriaDB = await Categoria.findOne({ nombre });

    if( categoriaDB ){
        return res.status(400).json({
            msg: `La categoria ${categoriaDB.nombre} ya existe!`
        });
    }
    
    const categoria = {
        nombre,
        usuario: req.usuario._id
    };
    const categoriaGuardada = new Categoria(categoria);

    await categoriaGuardada.save();

    res.status(201).json({
        msg: 'Categoria guardada!',
        resultado: 1,
        categoriaGuardada
    });
    
}

const putCategoria = async(req, res = response) => {
    const { id } = req.params;
    const { usuario, ...data } = req.body;

    data.usuario = req.usuario._id;

    const categoria = await Categoria.findByIdAndUpdate(id, data, { new: true });

    res.status(200).json({
        msg: 'Categoria actualizada!',
        resultado: 1,
        categoria
    });
}

const deleteCategoria = async(req, res = response) => {
    const { id } = req.params;

    const categoria = await Categoria.findByIdAndRemove(id);

    res.status(200).json({
        msg: 'Categoria eliminada',
        resultado: 1,
        categoria
    });
}

module.exports = {
    getCategorias,
    getCategoria,
    categoriasPost,
    putCategoria,
    deleteCategoria
    
}