const mongoose = require('mongoose');

const dbConnection = async() =>{

    try {

        //await mongoose.connect("mongodb://127.0.0.1:27017/tienda")
        await mongoose.connect("mongodb://localhost:27017/tienda-amazon")
            .then(() => {
                console.log("Se conecto a la bd");
            })
            .catch((err) => {
                console.log(err);
            })



    } catch (error) {
        console.log(error);
        throw new Error('Error a la hora de iniciar la base de datos');
    }

}


module.exports = {
    dbConnection
}