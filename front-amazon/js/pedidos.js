let usuario = JSON.parse(localStorage.getItem('usuario'));
if(!usuario){
  
  location.href ="http://143.244.157.68/";
}
const bodyPedidos = document.querySelector("#bodyPedidos");


var requestOptions = {
    method: 'GET',
    redirect: 'follow'
  };
  
  fetch("http://143.244.157.68:8080/api/ordenes/getOrdenesByUsuario/" + usuario.uid + "", requestOptions)
    .then(response => response.text())
    .then(result => {
        resultJson = JSON.parse(result);
        
        let strPedidos = '';
        let id = 1;
        if(resultJson.ordenes.length > 0){
            resultJson.ordenes.forEach((orden) =>{
                strPedidos += `
                <tr>
                    <td>${ id }</td>
                    <td>${ orden.domicilio }, ${ orden.municipio }, ${ orden.estado }, ${ orden.pais }</td>
                    <td>${ orden.costo }</td>
                    <td>
                        <button class="btn btn-warning">Ver pedido</button>
                    </td>
                </tr>
                `;
    
                id++;
    
    
                bodyPedidos.innerHTML = strPedidos;
            })
        }else{
            bodyPedidos.innerHTML = "<h2 class='text-center'>No tienes pedidos aun</h2>"
        }
        
})
    
    .catch(error => console.log('error', error));