
// Paquetes de node
const { Router } = require("express");
const { check } = require("express-validator");

// Controladores
const { getCategorias, 
        categoriasPost, 
        getCategoria, 
        putCategoria, 
        deleteCategoria } = require("../controllers/categorias");

// Middlewares
const { existeCategoria } = require("../middlewares/db-validators");
const validarCampos = require("../middlewares/validar-campos");
const { validarJWT } = require("../middlewares/validar-jwt");
const { esAdminRole } = require("../middlewares/validar-roles");

const router = Router();

router.get('/', getCategorias);

router.get('/:id', [
    check('id', 'No es un ID valido').isMongoId(),
    check('id').custom( existeCategoria ),
    validarCampos
], getCategoria);

router.post('/', [ 
    validarJWT,
    check('nombre', 'El nombre es obligatorio').not().isEmpty(),
    validarCampos
], categoriasPost);

router.put('/:id', [
    validarJWT,
    esAdminRole,
    check('nombre', 'El nombre es obligatorio').not().isEmpty(),
    validarCampos
], putCategoria);

router.delete('/:id', [
    validarJWT,
    esAdminRole,
    check('id', 'No es un ID valido').isMongoId(),
    check('id').custom( existeCategoria ),
    validarCampos
], deleteCategoria);

module.exports = router;