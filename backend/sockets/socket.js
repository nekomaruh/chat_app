const { io } = require('../index');
const { comprobarJWT } = require('../helpers/jwt')
const { usuarioConectado, usuarioDesconectado, saveMessage } = require('../controllers/socket');
const { emit } = require('../models/usuario');

// Mensajes de Sockets
io.on('connection', (client) => {
    console.log('Cliente conectado');

    const [valido, uid] = comprobarJWT(client.handshake.headers['x-token'])

    // Verificar autenticación
    if(!valido){
        return client.disconnect();
    }

    usuarioConectado(uid);

    // Ingresar al usuario a una sala
    // Sala global
    client.join(uid);

    // Escuchar del cliente el mensaje-personal
    client.on('personal-message', async (payload) => {
        // TODO: Grabar mensaje
        await saveMessage(payload);
        io.to(payload.to).emit('personal-message', payload);
    })
    //client.to(uid).emit('');


    client.on('disconnect', () => {
        usuarioDesconectado(uid);
    });

    client.on('mensaje', ( payload ) => {
        console.log('Mensaje', payload);

        io.emit( 'mensaje', { admin: 'Nuevo mensaje' } );

    });


});
