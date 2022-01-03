const { Router } = require("express");
const { check } = require("express-validator");

const { validarJWT } = require("../middlewares/validar-jwt");
const { esAdminRole } = require("../middlewares/validar-roles");
const validarCampos = require("../middlewares/validar-campos");
const { getOrdenes, getOrdenById, getOrdenesByUsuario, ordenesPost, ordenesPut, ordenesDelete } = require("../controllers/ordenes");
const { existeUsuarioPorId } = require("../helpers/db-validators");
const { existeOrden } = require("../middlewares/db-validators");

const router = Router();

router.get('/', getOrdenes);;

router.get('/:id',[
    check('id', 'El id debe de ser de mongo').isMongoId(),
    validarCampos
] ,getOrdenById);

router.get('/getOrdenesByUsuario/:id', [
    check('id').custom( existeUsuarioPorId )
], getOrdenesByUsuario);

router.post('/', [
    validarJWT,
    check('productos', 'Se requieren productos para guardar la orden').not().isEmpty(),
    //check('usuario', 'No es un id de Mongo').isMongoId(),
    //check('usuario').custom( existeUsuarioPorId ),
    validarCampos
], ordenesPost);

router.put('/:id', [
    validarJWT,
    check('id', 'No es un id de Mongo').isMongoId(),
    check('id').custom( existeOrden ),
    validarCampos
], ordenesPut);

router.delete('/:id', [
    validarJWT,
    check('id', 'No es un ID valido').isMongoId(),
    check('id').custom( existeOrden ),
    validarCampos
], ordenesDelete);

module.exports = router;