// Paquetes de node
const { Router } = require("express");
const { check } = require("express-validator");
const { getProductos, 
        productosPost, 
        productosPut, 
        productosDelete, 
        getProductosByCategoria, 
        mostrarImagen,
        getProductoById,
        getProductosByUsuario
    } = require("../controllers/productos");

const { validarJWT } = require("../middlewares/validar-jwt");
const { esAdminRole, esAdminVentasRole } = require("../middlewares/validar-roles");
const validarCampos = require("../middlewares/validar-campos");
const { existeCategoria, existeProducto, existeUsuarioPorId } = require("../helpers/db-validators");

const router = Router();

router.get('/', getProductos);

router.get('/:id',[
    check('id', 'El id debe de ser de mongo').isMongoId(),
    validarCampos
] ,getProductoById);

router.get('/getProductosByCategoria/:id', [
    check('id').custom( existeCategoria )
], getProductosByCategoria);

router.get('/getProductosByUsuario/:id', [
    check('id').custom( existeUsuarioPorId )
], getProductosByUsuario);

router.get('/imagen/:id', [
    check('id', 'El id debe de ser de mongo').isMongoId(),
    validarCampos
], mostrarImagen);

router.post('/', [
    validarJWT,
    esAdminVentasRole,
    check('nombre', 'El nombre es requerido').not().isEmpty(),
    check('categoria', 'No es un id de Mongo').isMongoId(),
    check('categoria').custom( existeCategoria ),
    validarCampos
], productosPost);


router.put('/:id', [
    validarJWT,
    esAdminRole,
    check('id', 'No es un id de Mongo').isMongoId(),
    check('id').custom( existeProducto ),
    validarCampos
], productosPut);

router.delete('/:id', [
    validarJWT,
    esAdminRole,
    check('id', 'No es un ID valido').isMongoId(),
    check('id').custom( existeProducto ),
    validarCampos
], productosDelete);

module.exports = router;