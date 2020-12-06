/*
    Path: api/mensajes
*/

const { Router } = require('express');
const { validarJWT } = require('../middlewares/validar-jwt');

const { getChat } = require('../controllers/mensajes');

const router = Router();

router.get('/:from',validarJWT, getChat);

module.exports = router;