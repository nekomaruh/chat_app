const Mensaje = require("../models/mensaje");

const getChat = async (req, res) => {

    const myId = req.uid;
    const messagesFrom = req.params.from;
    
    const last30 = await Mensaje.find({
        $or: [{from: myId, to: messagesFrom}, {from: messagesFrom, to: myId}]
    })
    .sort({createdAt: 'desc'})
    .limit(30);

    try {
        res.json({
            ok: true,
            msg: 'Hola mensajes',
            mensajes: last30
        })
    } catch (e) {
        console.log(e.message);
    }
}

module.exports = {
    getChat
}