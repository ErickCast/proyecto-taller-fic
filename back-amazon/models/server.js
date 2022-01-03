const express = require('express')
const cors = require('cors');
const fileUpload = require('express-fileupload');

const { dbConnection } = require('../database/config');

class Server {
    constructor() {
        this.app = express();
        this.port = process.env.PORT;

        this.paths = {
            auth: '/api/auth',
            categorias: '/api/categorias',
            usuarios: '/api/usuarios',
            productos: '/api/productos',
            busqueda: '/api/buscar',
            ordenes: '/api/ordenes'
        }

        
        // Conectar a la base de datos
        this.conectarDB();

        // Middlewares
        this.middlewares();

        // Rutas de mi aplicacion
        this.routes();

    }

    async conectarDB() {
        await dbConnection();
    }

    middlewares() {
        this.app.use(cors());


        //Directorio publico
        this.app.use( express.static('public') );

        // Lectura y parseo del body
        this.app.use(express.json());

        // Carga de archivos
        this.app.use(fileUpload({
            useTempFiles : true,
            tempFileDir : '/tmp/',
            createParentPath: true
        }));
    }

    routes() {

        this.app.use(this.paths.auth, require('../routes/auth'));
        this.app.use(this.paths.categorias, require('../routes/categorias'));
        this.app.use(this.paths.usuarios, require('../routes/usuarios'));
        this.app.use(this.paths.productos, require('../routes/productos'));
        this.app.use(this.paths.busqueda, require('../routes/buscar'));
        this.app.use(this.paths.ordenes, require('../routes/ordenes'));
        
        
    } 

    listen() {
        this.app.listen(this.port, () =>{
            console.log("servidor corriendo en puerto ", this.port);
        });
    }
}

module.exports = Server;