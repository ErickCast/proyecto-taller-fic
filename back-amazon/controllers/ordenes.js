const { response } = require('express');

const Orden = require('../models/orden');

const getOrdenes = async( req, res = response ) => {
    const ordenes = await Orden.find(); 

    res.status(200).json({
        ordenes
    });
}

const getOrdenById = async( req, res = response ) => {
    const { id } = req.params;

    const orden = await Orden.findById(id);

    res.status(200).json({
        orden
    });
}

const getOrdenesByUsuario = async(req, res = response) => {
    const { id } = req.params;

    const ordenes = await Orden.find({ usuario:id });

    if( !ordenes ) {
        return res.status(200).json({
            msg:'Este usuario no ha hecho ninguna orden'
        });
    }else {
        res.status(200).json({
            ordenes
        });
    }
}

const ordenesPost = async(req, res = response ) => {
    const { usuario, ...body } = req.body;
    
    const data = {
        ...body,
        usuario: req.usuario._id
    }

    const orden = new Orden(data);


    await orden.save();

    res.json({
        msg: 'Orden guardada!',
        resultado: 1,
        orden
    });
    

    

}

const ordenesPut = async( req, res = response ) => {
    const { id } = req.params;
    const { usuario, ...data } = req.body;

    data.usuario = req.usuario._id;
    const orden = await Orden.findByIdAndUpdate(id, data, { new: true });


    res.status(200).json({
        msg: 'Orden actualizada!',
        resultado: 1,
        orden
    })
}

const ordenesDelete = async(req, res = response) => {
    const { id } = req.params;

    const orden = await Orden.findByIdAndRemove(id, {new:true});

    res.status(200).json({
        msg: 'Orden eliminada!',
        getOrdenes
    })
}


module.exports = {
    getOrdenes,
    getOrdenById,
    getOrdenesByUsuario,
    ordenesPost,
    ordenesPut,
    ordenesDelete
}