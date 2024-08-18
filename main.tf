provider "azurerm"{ # con el que haremos las configuraciones de los recursos a levantar. en este caso Azure Recourse Manage // proveedor de la nube
    features{} #siempre es bueno definirlo

}  

resource "azurerm_resource_group" "rg"{//variable con la que la vamos a identicar rg
    name = "rg-${var.project}-${var.environment}" // es el nombre de como debe de crear el recurso en azure. 
    /*nomenclatura que usaremos: xx-yy-zz
        xx <- el tipo de recurso(resource grup).
        yy <- nombre del proyecto.
        zz <- el ambiente de desarrollo.
    */
    location = var.location
    tags = var.tags

}//definicion de un grupo de recurso. son los mismos campos se llenan mediante la int 

/*Pasos Siguientes:
    * Configurar el entorno de terraform    
        * Inicializar el versionamiento de esta carpeta en el repositorio:
    * Configurar el archivo .gitignoer para omitir  
    * ejecutar el comando:
        terraform plan <- visualizar cambios que se realizaran en la infraestructura. compara todo lo que esta en la plataforma con lo que cambimos.
    * confirmar cambios:
        terraform apply

*/