const jwt = require('jsonwebtoken');

const generarJWT = (uid) => {
    return new Promise((resolve, reject) => {
        const payload = {uid};
        jwt.sign(payload, process.env.JWT_KEY, {
            expiresIn: '48h'
        }, (error, token) => {
            if(error){
                // No se pudo crear el token
                reject('No se pudo generar el JWT');
            }else{
                resolve(token);
            }
        })
    });
}


module.exports = {
    generarJWT
}