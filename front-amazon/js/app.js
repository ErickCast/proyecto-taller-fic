/* COMPROBAR QUE EL USUARIO LOGUEADO ES ADMIN */
let usuario = JSON.parse(localStorage.getItem('usuario'));
if(usuario){
  if( usuario.rol == "USER_ROLE" || usuario == null ){
    location.href ="http://talleramzfic.ddns.net/";
  }
}else{
  location.href ="http://talleramzfic.ddns.net/";
}


/* CRUD CATEGORIAS */
const bodyCategorias = document.querySelector("#bodyCategorias");
let tokenUser = localStorage.getItem('tokenUser');
let categoriaActualizar= "";
let productoActualizar= "";
const inputNombre = document.querySelector("#inputNombre");
const cerrarModal = document.querySelector("#cerrarModal");
const inputNombreAct = document.querySelector("#inputNombreAct");
const cerrarModalAct = document.querySelector("#cerrarModalAct");
const selectCategorias = document.querySelector(".selectCategoria");
const selectCategoriasAct = document.querySelector("#selectCategoriaAct");




const obtenerCategorias = () => {
    /* OBTENER CATEGORIAS */
    var requestOptions = {
        method: 'GET',
        redirect: 'follow'
    };
    
fetch("http://143.244.157.68:8080/api/categorias", requestOptions)
  .then(response => response.text())
  .then(result => {
    resultJson = JSON.parse(result);

    let strCategorias = '';
    let optCategorias = '';
    let id = 1;
    resultJson.categorias.forEach((categoria) =>{
        strCategorias += `<tr>
            <td>${ id }</td>
            <td>${ categoria.nombre }</td>
            <td>
                <button class="btn-warning" data-toggle="modal" data-target="#exampleModalActualizar" onclick='guardarIdCategoria(\"${ categoria._id }\", \"${ categoria.nombre }\")'>Modificar</button><button class="btn-danger" onclick='eliminarCategoria(\"${ categoria._id }\")'>Eliminar</button>
            </td>
        </tr>`;
        optCategorias += `
        <option value="${categoria._id}">${ categoria.nombre }</option>
        `;

        id++;


        bodyCategorias.innerHTML = strCategorias;
    });


  })
  .catch(error => console.log('error', error));
}

var requestOptions = {
  method: 'GET',
  redirect: 'follow'
};

fetch("http://143.244.157.68:8080/api/categorias", requestOptions)
  .then(response => response.text())
  .then(result => {
    resultJson = JSON.parse(result);
    let optCategorias = '';
    let id = 1;
    resultJson.categorias.forEach((categoria) =>{
        
        optCategorias += `
        <option value="${categoria._id}">${ categoria.nombre }</option>
        `;

        id++;

        selectCategorias.innerHTML = optCategorias;
        selectCategoriasAct.innerHTML = optCategorias;
    });


  })
  .catch(error => console.log('error', error));

const guardarIdCategoria = (id, nombre) => {
    categoriaActualizar = id.toString();
    inputNombreAct.value = nombre;
}


obtenerCategorias();



  /* Guardar una categoria */
  
  
  const guardarCategoria = () =>{
    

    var myHeaders = new Headers();
    myHeaders.append("content-type", "application/json; charset=UTF-8");
    myHeaders.append("x-token", tokenUser);
    
    var raw = "{\r\n    \"nombre\": \"" + inputNombre.value + "\"\r\n}";
    


    var requestOptions = {
    method: 'POST',
    headers: myHeaders,
    body: raw,
    redirect: 'follow'
    };

    fetch("http://143.244.157.68:8080/api/categorias", requestOptions)
    .then(response => response.text())
    .then(result => {
        let resultJson = JSON.parse(result);
        if(resultJson.resultado == 1){
            alert("Categoria guardada!");
            inputNombre.value = "";
            cerrarModal.click();
            obtenerCategorias();
        }else{
            alert("El nombre no es valido, intentelo de nuevo");
        }
    })
    .catch(error => console.log('error', error)); 
    
  }
  

  const actualizarCategoria = (id) => {
    var myHeaders = new Headers();
    myHeaders.append("content-type", "application/json; charset=UTF-8");
    myHeaders.append("x-token", tokenUser);

    var raw = "{\r\n    \"nombre\":\"" + inputNombreAct.value + "\"\r\n}";

    var requestOptions = {
    method: 'PUT',
    headers: myHeaders,
    body: raw,
    redirect: 'follow'
    };

    fetch("http://143.244.157.68:8080/api/categorias/"+ id +"", requestOptions)
    .then(response => response.text())
    .then(result => {
        let resultJson = JSON.parse(result);

        if(resultJson.resultado == 1){
            alert("Categoria actualizada!");
            inputNombreAct.value = "";
            cerrarModalAct.click();
            obtenerCategorias();
        }else{
            alert("El nombre no es valido, intentelo de nuevo");
        }
    })
    .catch(error => console.log('error', error));
  }

  const eliminarCategoria = (id) => {
    var myHeaders = new Headers();
    myHeaders.append("x-token", tokenUser);
    
    var requestOptions = {
      method: 'DELETE',
      headers: myHeaders,
      redirect: 'follow'
    };
    
    fetch("http://143.244.157.68:8080/api/categorias/"+ id +"", requestOptions)
      .then(response => response.text())
      .then(result => {
        let resultJson = JSON.parse(result);

        if(resultJson.resultado == 1){
            alert("Categoria eliminada!");
            obtenerCategorias();
        }else{
            alert("No se pudo eliminar la categoria, intentalo de nuevo");
        }
      })
      .catch(error => console.log('error', error));
  }


  /* CRUD PRODUCTOS */
  const bodyProductos = document.querySelector("#bodyProductos");
  
  
  const obtenerProductos = () => {
    var requestOptions = {
      method: 'GET',
      redirect: 'follow'
    };
    
    fetch("http://143.244.157.68:8080/api/productos", requestOptions)
      .then(response => response.text())
      .then(result => {
        resultJson = JSON.parse(result);

        let strProductos = '';
        let id = 1;
        resultJson.productos.forEach((producto) =>{
            strProductos += `<tr>
                <td>${ id }</td>
                <td align="center"><img src=http://143.244.157.68:8080/api/productos/imagen/${producto._id} width="60" height="80"></td>
                <td>${ producto.nombre }</td>
                <td>${ producto.precio }</td>
                <td>
                    <button class="btn-warning" data-toggle="modal" data-target="#exampleModalActualizar" onclick='guardarIdProducto(\"${ producto._id }\", \"${ producto.nombre }\", \"${ producto.categoria}\", \"${ producto.precio }\", \"${ producto.stock }\", \"${ producto.descripcion }\")'>Modificar</button><button class="btn-danger" onclick='eliminarProducto(\"${ producto._id }\")'>Eliminar</button>
                </td>
            </tr>`;
    
            id++;
    
            bodyProductos.innerHTML = strProductos;
        });
    
    
      })
      .catch(error => console.log('error', error));
  }





obtenerProductos();

  /* GUARDAR UN PRODUCTO */
  const inputImagen = document.querySelector("#inputImagen");
  const inputNombreProducto = document.querySelector("#inputNombre");
  const inputPrecio = document.querySelector("#inputPrecio");
  const inputStock = document.querySelector("#inputStock");
  const inputDescripcion = document.querySelector("#inputDescripcion");

  const guardarProducto = () => {

    var myHeaders = new Headers();
    myHeaders.append("x-token", tokenUser);
    
    var formdata = new FormData();
    formdata.append("img", inputImagen.files[0]);
    formdata.append("nombre", inputNombreProducto.value);
    formdata.append("precio", inputPrecio.value);
    formdata.append("categoria", selectCategorias.value);
    formdata.append("promocion", "0");
    formdata.append("descripcion", inputDescripcion.value);
    formdata.append("stock", inputStock.value);
    




    var requestOptions = {
      method: 'POST',
      headers: myHeaders,
      body: formdata,
      redirect: 'follow'
    };

    fetch("http://143.244.157.68:8080/api/productos", requestOptions)
      .then(response => response.text())
      .then(result => {
        let resultJson = JSON.parse(result);
        if(resultJson.msg == "Producto creado!"){
            alert("Producto guardado!");
            inputNombreProducto.value = "";
            inputPrecio.value = "";
            inputImagen.value = null;
            selectCategorias.value = "";
            inputDescripcion.value = "";
            inputStock.value = "";
            cerrarModal.click();
            obtenerProductos();
        }else{
            alert("Los datos no son validos, intentelo de nuevo");
        }
      })
      .catch(error => console.log('error', error));  

     
    }


    /* ACTUALIZAR PRODUCTO */

    const guardarIdProducto = (id, nombre, categoriaId, precio, stock, descripcion) => {
      productoActualizar = id.toString();
      inputNombreProductoAct.value = nombre;
      selectCategoriasAct.value = categoriaId;
      inputPrecioAct.value = precio;
      inputStockAct.value = stock;
      inputDescripcionAct.value = descripcion;
    }
    
    const inputImagenAct = document.querySelector("#inputImagenAct");
    const inputNombreProductoAct = document.querySelector("#inputNombreAct");
    const inputPrecioAct = document.querySelector("#inputPrecioAct");
    const inputStockAct = document.querySelector("#inputStockAct");
    const inputDescripcionAct = document.querySelector("#inputDescripcionAct");

    const actualizarProducto = (id) => {
      var myHeaders = new Headers();
      myHeaders.append("x-token", tokenUser);

      var formdata = new FormData();
      formdata.append("img", inputImagenAct.files[0]);
      formdata.append("nombre", inputNombreProductoAct.value);
      formdata.append("precio", inputPrecioAct.value);
      formdata.append("categoria", selectCategoriasAct.value);
      formdata.append("promocion", "0");
      formdata.append("descripcion", inputDescripcionAct.value);
      formdata.append("stock", inputStockAct.value);

      var requestOptions = {
        method: 'PUT',
        headers: myHeaders,
        body: formdata,
        redirect: 'follow'
      };

      fetch("http://143.244.157.68:8080/api/productos/" + id + "", requestOptions)
        .then(response => response.text())
        .then(result => {
          let resultJson = JSON.parse(result);
        if(resultJson.msg == "Producto actualizado!"){
            alert("Producto actualizado!");
            
            cerrarModalAct.click();
            obtenerProductos();
        }else{
            alert("Los datos no son validos, intentelo de nuevo");
        }
        })
        .catch(error => console.log('error', error));
    }

    const eliminarProducto = (id) => {
      var myHeaders = new Headers();
      myHeaders.append("x-token", tokenUser);
      
      var requestOptions = {
        method: 'DELETE',
        headers: myHeaders,
        redirect: 'follow'
      };
      
      fetch("http://143.244.157.68:8080/api/productos/"+ id +"", requestOptions)
        .then(response => response.text())
        .then(result => {
          let resultJson = JSON.parse(result);
        if(resultJson.msg == "Producto eliminado!"){
            alert(resultJson.msg);
            
            obtenerProductos();
        }else{
            alert("No se pudo eliminar el producto, intentelo de nuevo");
        }
          
        })
        .catch(error => console.log('error', error));
    }
