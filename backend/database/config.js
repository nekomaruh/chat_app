const mongoose = require('mongoose');

const dbConnection = async() => {
    try{
        console.log('init db config');
        mongoose.connect(process.env.DB_CNN, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
            useCreateIndex: true
        });

        console.log('DB online');

        /*
        const mongoose = require('mongoose');
        mongoose.connect('mongodb://localhost:27017/test', {useNewUrlParser: true, useUnifiedTopology: true});

        const Cat = mongoose.model('Cat', { name: String });

        const kitty = new Cat({ name: 'Zildjian' });
        kitty.save().then(() => console.log('meow'));
        */
    }catch(e){
        console.log(e);
        throw new Error('Error en la base de datos - Hbale con el admin');
    }
}

module.exports = {
    dbConnection
}