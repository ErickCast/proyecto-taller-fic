const path = require('path');
const { v4: uuidv4 } = require('uuid');

const subirArchivo = ( files, extensionesValidas = ['png', 'jpg', 'jpeg', 'gif'], carpeta = '' ) =>{

    return new Promise( (resolve, reject)=>{
        console.log("archivos: " + files)
        const { img } = files;
        console.log(img);
        const nombreCortado = img.name.split('.');
        const extension = nombreCortado[ nombreCortado.length - 1 ];

        // Validar la extension
        if( !extensionesValidas.includes(extension)) {
            return reject(`La extension ${ extension } no es permitida - extensiones permitidas: ${ extensionesValidas }`);
        }

        //Archivo con nombre unico
        const nombreTemp = uuidv4() + '.' + extension;

        //Ruta de subida - donde se guardara el archivo
        const uploadPath = path.join(__dirname, '../uploads/', carpeta, nombreTemp);

        img.mv(uploadPath, (err) => {
            if (err) {
                reject(err);
            }

            resolve( nombreTemp );
        }); 
    });

    

}

module.exports = {
    subirArchivo
}