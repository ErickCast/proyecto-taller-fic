// Paquetes de node
const { Router } = require("express");
const { check } = require("express-validator");

// Controladores
const { usuariosGet, 
        usuariosPost, 
        usuariosPut, 
        usuariosDelete } = require("../controllers/usuarios");

// Middlewares
const { emailExiste, 
        esRoleValido, 
        existeUsuarioPorId } = require("../middlewares/db-validators");
const validarCampos = require("../middlewares/validar-campos");
const { validarJWT } = require("../middlewares/validar-jwt");
const { tieneRole, esAdminRole } = require("../middlewares/validar-roles");

const router = Router();

router.get('/', usuariosGet);

router.post('/', [
    check('nombre', 'El nombre es obligatorio').not().isEmail(),
    check('password', 'La contrasena es obligatoria y debe tener mas de 6 letras').isLength({ min: 6 }),
    check('correo', 'El correo no es valido').isEmail(),
    check('correo').custom( emailExiste ),
    validarCampos
], usuariosPost);

router.put('/:id', [
    validarJWT,
    check('id', 'No es un ID valido').isMongoId(),
    check('id').custom( existeUsuarioPorId ),
    check('rol').custom( esRoleValido ),
    validarCampos
], usuariosPut);

router.delete('/:id', [
    validarJWT,
    tieneRole('ADMIN_ROLE', 'VENTAS_ROLE', 'USER_ROLE'),
    check('id', 'No es un ID valido').isMongoId(),
    check('id').custom( existeUsuarioPorId ),
    validarCampos
], usuariosDelete);

module.exports = router;