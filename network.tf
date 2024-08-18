#archivo para configurar segmentos de red y subderes.

resource "azurerm_virtual_network" "vnet"{ # red virtual general
    name = "vnet-${var.project}-${var.environment}" #nomenclatura utilizada en el proyecto: tipoElemento-nombreProyecto-ambienteDesarrollo
    resource_group_name = azurerm_resource_group.rg.name # haciendo referencia a un recurso ya creado # el nombre con el que identificamos un grupo de recurso(en nuestro caso:rg). 
    location = var.location
    address_space = ["10.0.0.0/16"] # direccion de red que tendra la red
    tags = var.tags
}

# subredes(segmentos de red) que vamos a configurar que pertenecen a la red virtual general.
resource "azurerm_subnet" "subnetdb"{
    name = "subnet-db-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name  # la red a la que pertenece esta subred.
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnetapp"{
    name = "subnet-app-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name # la red a la que pertenece esta subred.
    address_prefixes = ["10.0.2.0/24"]
}


resource "azurerm_subnet" "subnetweb"{
    name = "subnet-web-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.3.0/24"]

    delegation {
        name = "webapp_delegation"
        service_delegation {
            name    = "Microsoft.Web/serverFarms"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
    }

}

resource "azurerm_subnet" "subnetfunction"{
    name = "subnet-function-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.4.0/24"]

}

